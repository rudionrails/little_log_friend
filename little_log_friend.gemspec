# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "little_log_friend/version"

Gem::Specification.new do |s|
  s.name        = "little_log_friend"
  s.version     = LittleLogFriend::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rudolf Schmidt"]
  
  s.homepage    = "http://github.com/rudionrails/little_log_friend"
  
  s.summary     = %q{An easy way to set your Ruby standard logger to a more readable format}
  s.description = %q{LittleLogFriend sets your standard logger to the format: "DATE TIME [ LEVEL ] PID : MESSAGE"}

  s.rubyforge_project = "little_log_friend"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  
  s.add_development_dependency "rake"
  s.add_development_dependency "activesupport", "~> 2.x"
end
