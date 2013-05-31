Pod::Spec.new do |s|
  s.name         = "HGDependencyInjection"
  s.version      = "0.0.1"
  s.summary      = "Objective-C minimal DI framework."
  s.homepage     = "http://www.github.com/hugeinc/HGDependencyInjection"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Marc Ammann" => "mammann@hugeinc.com" }
  s.source       = { :git => "https://github.com/hugeinc/HGDependencyInjection.git", :tag => "0.0.1" }
  s.platform     = :ios, '5.0'
  s.source_files = 'Classes'
  s.requires_arc = true
end

