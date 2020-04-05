# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'time'
require 'tzinfo'

module SFCOVID19
  class SFDPHScraper
    SFDPH_URL = 'https://www.sfdph.org/dph/alerts/coronavirus.asp'

    def scrape!
      data_time = estimated_data_time

      URI.open(SFDPH_URL) do |content|
        doc = Nokogiri::HTML(content)
        data = doc.css('div.box2 p').each_with_object({}) do |para, hash|
          case para.text
          when /([^:]+):\s+(\d+)/i
            raw_key = Regexp.last_match(1)
            raw_value = Regexp.last_match(2)

            key = raw_key.to_s.chomp.downcase.gsub(/ /, '_')
            value = raw_value.to_i

            hash[key] = value
          end
        end

        { data_time.iso8601 => data }
      end
    end

    private

    def estimated_data_time
      timezone = TZInfo::Timezone.get('America/Los_Angeles')
      time = timezone.now

      # SFDPH data is supposed to be updated at 9am every day
      data_time = timezone.local_time(time.year, time.month, time.day, 9, 0, 0)
      data_time -= (24 * 60 * 60) if time.hour < 9

      data_time.utc
    end
  end
end
