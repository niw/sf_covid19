# frozen_string_literal: true

require 'rubygems'
require 'thor'
require 'json'

module SFCOVID19
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'scrape_sfdph', 'Scrape SFDPH website and dump data in JSON format'
    option :pretty, type: :boolean, desc: 'Make JSON pretty.'
    def scrape_sfdph
      data = SFDPHScraper.new.scrape!
      json = options[:pretty] ? JSON.pretty_generate(data) : JSON.generate(data)
      puts json
    end
  end
end
