# frozen_string_literal: true

require 'rubygems'
require 'thor'
require 'json'
require 'time'

module SFCOVID19
  class CLI < Thor
    DEFAULT_DATA_PATH = File.expand_path('../../data/sfdph_historic_data.json', __dir__)

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

    desc 'update_data', 'Update historic data'
    option :path, type: :string, default: DEFAULT_DATA_PATH, desc: 'Path to JSON file'
    option :replace, type: :boolean, desc: 'Replace content of path'
    option :pretty, type: :boolean, default: true, desc: 'Make JSON pretty.'
    def update_data
      path = options[:path]
      historic_data = JSON.parse(File.read(path))
      new_data = SFDPHScraper.new.scrape!
      data = historic_data.merge(new_data)
      json = options[:pretty] ? JSON.pretty_generate(data) : JSON.generate(data)
      if options[:replace]
        File.open(path, 'w') { |file| file.puts json }
      else
        puts json
      end
    end

    TIMESTAMP_COLUMN_KEY = 'timestamp'

    desc 'convert_to_tsv [PATH]', 'Convert historic data to TSV'
    option :path, type: :string, default: DEFAULT_DATA_PATH, desc: 'Path to JSON file'
    def convert_to_tsv
      path = options[:path]
      historic_data = JSON.parse(File.read(path))

      columns = Set.new
      data = {}
      historic_data.each do |key, value|
        columns += value.keys
        data[Time.parse(key)] = value
      end
      columns = columns.sort.to_a

      tsv = []
      tsv << [TIMESTAMP_COLUMN_KEY] + columns
      data.keys.sort.each do |key|
        tsv << [key.iso8601] + columns.map { |value_key| data[key][value_key] }
      end

      tsv.each do |row|
        puts row.join("\t")
      end
    end
  end
end
