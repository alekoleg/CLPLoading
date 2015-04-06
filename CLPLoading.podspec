Pod::Spec.new do |s|
  s.name         = "CLPLoading"
  s.version      = "0.0.2"
  s.summary      = "Loading lib"
  s.description  = "library that helps easy show loading and errors"
  s.homepage     = "https://github.com/alekoleg/CLPLoading"
  s.license      = 'MIT'
  s.author       = { "Oleg Alekseenko" => "alekoleg@gmail.com" }
  s.source       = { :git => "https://github.com/alekoleg/CLPLoading", :tag => s.version.to_s}
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m}'

  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'

end
