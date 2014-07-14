Gem::Specification.new do |s|
  s.name        = 'dir_manifest'
  s.version     = '0.0.0'
  s.date        = '2014-07-02'
  s.summary     = "Hola!"
  s.description = "A simple hello world gem"
  s.authors     = ["Dave Liggat"]
  s.email       = 'dliggat@gmail.com'
  s.files       = Dir["{lib}/*.rb", "bin/*", "*.md", "{lib/dir_manifest}/*.rb"]   #["lib/dir_manifest.rb"]
  s.require_paths = ["lib"]
  s.executables << 'dir_manifest'
  s.homepage    =
    'http://rubygems.org/gems/dir_manifest'
  s.license       = 'MIT'
  s.add_development_dependency "bundler"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-its"
  s.add_runtime_dependency "activemodel"
  s.add_runtime_dependency "activesupport"
end
