#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    # Where the name in the header bar is different from the main list
    REMAP = {
      'Trygve Magnus Slagsvold Vedum (Centre Party)' => 'Trygve Slagsvold Vedum (Centre Party)',
    }.freeze

    field :name do
      header_minister
    end

    field :position do
      name_and_position.sub(header_minister, '').gsub(/^The /, '').tidy
    end

    private

    def info
      noko.css('p.exerpts').text
    end

    # There's no separator here, but we can subtract out the name+party
    # from the header-bar list to be left with the position.
    # Unfortunately, sometimes the names differ between the two lists!
    def name_and_position
      noko.css('h2').text.split('(').first.tidy
    end

    def header_minister
      header_minister_names.find { |minister| name_and_position.include? minister }
    end

    def header_minister_names
      @header_minister_names ||= header_ministers_with_party.map do |name_and_party|
        name_and_party.split('(').first.tidy
      end
    end

    # From the header bar we can get a list of all minister+party names
    def header_ministers_with_party
      @header_ministers_with_party ||= noko.xpath('//.').css('li a.dep-minister').map(&:text).map(&:tidy).map do |data|
        REMAP.fetch(data, data)
      end
    end
  end

  class Members
    def member_container
      noko.css('.listing .listItem')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
