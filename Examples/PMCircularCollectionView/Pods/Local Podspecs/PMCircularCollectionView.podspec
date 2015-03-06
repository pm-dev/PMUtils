Pod::Spec.new do |s|
  s.name             = "PMCircularCollectionView"
  s.version          = "0.9.1"
  s.summary          = "PMCircularCollectionView is a subclass of UICollectionView that scrolls infinitely in the horizontal or vertical direction."
  s.homepage         = "https://github.com/pm-dev/#{s.name}"
  s.license          = 'MIT'
  s.author           = { "Peter Meyers" => "petermeyers1@gmail.com" }
  s.source           = { :git => "https://github.com/pm-dev/#{s.name}.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc     = true
  s.source_files     = 'Classes/**/*.{h,m}'
  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks       = 'Foundation', 'UIKit'
  s.dependency 'PMUtils', '1.0.1'
end
