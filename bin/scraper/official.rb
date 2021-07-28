#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      name_and_party.split('(').first.tidy
    end

    field :position do
      name_and_position.sub(name_and_party, '').tidy
    end

    private

    def info
      noko.css('p.exerpts').text
    end

    def name_and_position
      noko.css('h2').text.tidy
    end

    def name_and_party
      all_ministers.find { |minister| name_and_position.include? minister }
    end

    # These are in the header bar, along with ministries
    def all_ministers
      noko.xpath('//.').css('li a.dep-minister').map(&:text).map(&:tidy)
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
