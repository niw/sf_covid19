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

    desc 'update_data PATH', 'Update historic data at path in JSON format'
    option :pretty, type: :boolean, desc: 'Make JSON pretty.'
    def update_data(path)
      historic_data = JSON.parse(File.read(path))
      new_data = SFDPHScraper.new.scrape!
      data = historic_data.merge(new_data)
      json = options[:pretty] ? JSON.pretty_generate(data) : JSON.generate(data)
      File.open(path, 'w') { |file| file.puts json }
    end
  end
end
