# -*- coding: utf-8 -*-
require File.expand_path('../lib/rss_conv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Keiichiro Ui"]
  gem.email         = ["keiichiro.ui@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rss_conv"
  gem.require_paths = ["lib"]
  gem.version       = RssConv::VERSION

  gem.add_runtime_dependency 'mechanize'
  gem.add_runtime_dependency 'nokogiri'
end
