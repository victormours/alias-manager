Gem::Specification.new do |gem|
  gem.name        = 'alias-manager'
  gem.version     = '0.0.0'
  gem.licenses    = ['MIT']
  gem.summary     = "Better shell alias management"
  gem.description = "Alias Manager finds which of your aliases are unused and which ones can be improved"
  gem.authors     = ["Victor Mours"]
  gem.email       = 'victor.mours@gmail.com'
  gem.files       = Dir["lib/**/*.rb"]
  gem.executables = ['alias-manager']
end
