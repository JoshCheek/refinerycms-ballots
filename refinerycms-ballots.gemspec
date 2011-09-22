Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-ballots'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Ballots engine for Refinery CMS'
  s.date              = '2011-09-13'
  s.summary           = 'Ballots engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir['lib/**/*', 'config/**/*', 'app/**/*']
  s.add_dependency              'refinerycms-members'
  s.add_development_dependency  'factory_girl', '~> 2.1.0'
end
