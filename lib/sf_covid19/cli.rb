# frozen_string_literal: true

require 'rubygems'
require 'thor'
require 'json'

module SFCOVID19
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'scrape_sfdph', 'Scrape SFDPH website'
    def scrape_sfdph
      data = SFDPHScraper.scrape!
      puts JSON.dump(data)
    end
  end
end
