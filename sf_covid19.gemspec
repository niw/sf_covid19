# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'sf_covid19'
  spec.version = '0.1.0'
  spec.authors = ['Yoshimasa Niwa']
  spec.email = ['niw@niw.at']
  spec.summary = spec.description = 'Command line tool and library for COVID-19 in San Francisco'
  spec.homepage = 'https://github.com/niw/sf_covid19'
  spec.license = 'MIT'
  spec.metadata = {
    'source_code_uri' => 'https://github.com/niw/sf_covid19'
  }

  spec.extra_rdoc_files = `git ls-files -z -- README* LICENSE`.split("\x0")
  executable_files = `git ls-files -z -- bin/*`.split("\x0")
  spec.files = `git ls-files -z -- lib/*`.split("\x0") + spec.extra_rdoc_files + executable_files

  spec.bindir = 'bin'
  spec.executables = executable_files.map { |f| File.basename(f) }

  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'thor'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
end
