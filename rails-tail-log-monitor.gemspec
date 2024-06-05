Gem::Specification.new do |s|
  s.name        = 'rails-tail-log-monitor'
  s.version     = '1.0'
  s.summary     = 'Supports APIs related to Google Translate and more!'
  s.description = 'Translation service designed to help you with a variety of language-based features including direct translations, alternate translations, definitions, examples, transliterations, spelling suggestions, language detection, and highly relevant keyword suggestions.'
  s.authors     = ['datpmt']
  s.email       = 'datpmt.2k@gmail.com'
  s.files       = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*', 'app/**/*']
  s.homepage    =
    'https://rubygems.org/gems/rails-tail-log-monitor'
  s.license = 'MIT'
  s.metadata = {
    'source_code_uri' => 'https://github.com/datpmt/rails-tail-log-monitor',
    'changelog_uri' => 'https://github.com/datpmt/rails-tail-log-monitor/blob/main/CHANGELOG.md'
  }
  s.add_dependency 'rails', '~> 6.0'
end
