#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    # Where the name in the header bar is different from the main list
    REMAP = {
      'Trygve Magnus Slagsvold Vedum (Centre Party)' => 'Trygve Slagsvold Vedum (Centre Party)',
    }.freeze

    field :name do
      header_data.split('(').first.tidy
    end

    field :position do
      name_and_position.sub(header_data, '').tidy
    end

    private

    def info
      noko.css('p.exerpts').text
    end

    # There's no separator here, but we can subtract out the name+party
    # from the header-bar list to be left with the position.
    # Unfortunately, sometimes the names differ between the two lists!
    def name_and_position
      noko.css('h2').text.tidy
    end

    def header_data
      all_ministers.find { |minister| name_and_position.include? minister }
    end

    # From the header bar we can get a list of all minister+party names
    # (but only with their ministries, but not the actual position)
    def all_ministers
      noko.xpath('//.').css('li a.dep-minister').map(&:text).map(&:tidy).map do |data|
        REMAP.fetch(data, data)
      end
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.flat_map do |member|
        data = fragment(member => Member).to_h
        [data.delete(:position)].flatten.map { |posn| data.merge(position: posn) }
      end
    end

    private

    def member_container
      noko.css('.listing .listItem')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
