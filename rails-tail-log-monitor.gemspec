# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'rails-tail-log-monitor'
  s.version     = '1.0.0'
  s.summary     = 'Purpose: Displays the tail of the server log in the terminal alongside the Rails server output.'
  s.description = 'The rails-tail-log-monitor gem simplifies the process of monitoring server logs by displaying ' \
                  'the tail of the log file directly in the terminal window alongside the standard Rails server output. ' \
                  'With rails-tail-log-monitor, developers can effortlessly keep track of the most recent log entries ' \
                  'without the need for manual log file inspection.'
  s.authors     = ['datpmt']
  s.email       = 'datpmt.2k@gmail.com'
  s.files       = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*', 'app/**/*', 'app/assets/**/*']
  s.homepage    =
    'https://rubygems.org/gems/rails-tail-log-monitor'
  s.license = 'MIT'
  s.metadata = {
    'source_code_uri' => 'https://github.com/datpmt/rails-tail-log-monitor',
    'changelog_uri' => 'https://github.com/datpmt/rails-tail-log-monitor/blob/main/CHANGELOG.md',
    'rubygems_mfa_required' => 'true'
  }
  s.add_dependency 'rails', '>= 6'
  s.required_ruby_version = '>= 2.6'
end
