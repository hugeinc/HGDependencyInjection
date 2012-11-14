Pod::Spec.new do |s|
  s.name         = "HGDependencyInjection"
  s.version      = "0.0.1"
  s.summary      = "A short description of HGDependencyInjection."
  s.homepage     = "http://www.github.com/hugeinc/HGDependencyInjection"
  s.license      = 'Apache'
  s.author       = { "Marc Ammann" => "mammann@hugeinc.com" }
  s.source       = { :git => "https://github.com/hugeinc/HGDependencyInjection.git", :tag => "0.0.1" }
  s.platform     = :ios, '5.0'
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/HGDI.h'
  s.requires_arc = true
end
