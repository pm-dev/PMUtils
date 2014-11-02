Pod::Spec.new do |s|
s.name        = "PMUtils"
s.version     = "1.1.1"
s.summary     = "PMUtils contains categories on Foundation and UIKit classes as well as a few custom classes for common use cases."
s.homepage    = "https://github.com/pm-dev/#{s.name}"
s.license     = 'MIT'
s.author      = { "Peter Meyers" => "petermeyers1@gmail.com" }
s.source      = { :git => "https://github.com/pm-dev/#{s.name}.git", :tag => s.version.to_s }
s.platform    = :ios, '7.0'
s.public_header_files = 'Pod/Classes/**/*.h'
s.source_files = 'Pod/Classes/*.{h,m}'
s.requires_arc = true


s.subspec 'UIKit+PMUtils' do |ss|
ss.source_files = 'Pod/Classes/UIKit+PMUtils/*.{h,m}'
ss.public_header_files = 'Pod/Classes/UIKit+PMUtils/*.h'
ss.dependency 'PMUtils/Foundation+PMUtils'
end

s.subspec 'Foundation+PMUtils' do |ss|
ss.source_files = 'Pod/Classes/Foundation+PMUtils/*.{h,m}'
ss.public_header_files = 'Pod/Classes/Foundation+PMUtils/*.h'
ss.frameworks = 'CoreData'
end

s.subspec 'PMAnimationOperation' do |ss|
ss.source_files = 'Pod/Classes/PMAnimationOperation/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMAnimationOperation/*.h'
end

s.subspec 'PMOrderedDictionary' do |ss|
ss.source_files = 'Pod/Classes/PMOrderedDictionary/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMOrderedDictionary/*.h'
end

s.subspec 'PMProtocolInterceptor' do |ss|
ss.source_files = 'Pod/Classes/PMProtocolInterceptor/*.{h,m}'
ss.public_header_files = 'Classes/PMProtocolInterceptor/*.h'
end

s.subspec 'PMImageFilmstrip' do |ss|
ss.source_files = 'Pod/Classes/PMImageFilmstrip/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMImageFilmstrip/*.h'
ss.dependency 'PMUtils/UIKit+PMUtils'
end

s.subspec 'PMCollectionViewSwipeCell' do |ss|
ss.source_files = 'Pod/Classes/PMCollectionViewSwipeCell/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMCollectionViewSwipeCell/*.h'
ss.dependency 'PMUtils/UIKit+PMUtils'
end

s.subspec 'PMInnerShadowView' do |ss|
ss.source_files = 'Pod/Classes/PMInnerShadowView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMInnerShadowView/*.h'
end

s.subspec 'PMInfiniteScrollView' do |ss|
ss.source_files = 'Pod/Classes/PMInfiniteScrollView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMInfiniteScrollView/*.h'
ss.dependency 'PMUtils/UIKit+PMUtils'
end

s.subspec 'PMRoundedBorderView' do |ss|
ss.source_files = 'Pod/Classes/PMRoundedBorderView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMRoundedBorderView/*.h'
end

s.subspec 'PMKeyboardListener' do |ss|
ss.source_files = 'Pod/Classes/PMKeyboardListener/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMKeyboardListener/*.h'
end

s.subspec 'PMStickyHeaderFlowLayout' do |ss|
ss.source_files = 'Pod/Classes/PMStickyHeaderFlowLayout/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMStickyHeaderFlowLayout/*.h'
end

end