Pod::Spec.new do |s|
s.name        = "PMUtils"
s.version     = "1.2.2"
s.summary     = "PMUtils contains categories on Foundation and UIKit classes as well as a few custom classes for common use cases."
s.homepage    = "https://github.com/pm-dev/#{s.name}"
s.license     = 'MIT'
s.author      = { "Peter Meyers" => "petermeyers1@gmail.com" }
s.source      = { :git => "https://github.com/pm-dev/#{s.name}.git", :tag => s.version.to_s }
s.ios.deployment_target = '8.0'
s.tvos.deployment_target = '9.0'
s.public_header_files = 'Pod/Classes/**/*.h'
s.source_files = 'Pod/Classes/*.{h,m}'
s.requires_arc = true


s.subspec 'UIKit+PMUtils' do |ss|
ss.source_files = 'Pod/Classes/UIKit+PMUtils/*.{h,m}'
ss.public_header_files = 'Pod/Classes/UIKit+PMUtils/*.h'
ss.dependency 'PMUtils/Foundation+PMUtils'
ss.dependency 'PMUtils/PMProtocolInterceptor'
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
ss.public_header_files = 'Pod/Classes/PMProtocolInterceptor/*.h'
end

s.subspec 'PMCircularCollectionView' do |ss|
ss.source_files = 'Pod/Classes/PMCircularCollectionView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMCircularCollectionView/*.h'
ss.dependency 'PMUtils/UIKit+PMUtils'
ss.dependency 'PMUtils/PMProtocolInterceptor'
end

s.subspec 'PMImageFilmstrip' do |ss|
ss.source_files = 'Pod/Classes/PMImageFilmstrip/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMImageFilmstrip/*.h'
ss.dependency 'PMUtils/PMCircularCollectionView'
end

s.subspec 'PMFloatLabel' do |ss|
ss.source_files = 'Pod/Classes/PMFloatLabel/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMFloatLabel/*.h'
ss.dependency 'PMUtils/PMProtocolInterceptor'
end

s.subspec 'PMPlaceholderTextView' do |ss|
ss.source_files = 'Pod/Classes/PMPlaceholderTextView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMPlaceholderTextView/*.h'
ss.dependency 'PMUtils/PMProtocolInterceptor'
end

s.subspec 'PMProgressHUD' do |ss|
ss.source_files = 'Pod/Classes/PMProgressHUD/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMProgressHUD/*.h'
ss.resource_bundles = {
'PMProgressHUD' => ['Pod/Classes/PMProgressHUD/*.{xib,png}']
}
end

s.subspec 'PMCollectionViewSwipeCell' do |ss|
ss.source_files = 'Pod/Classes/PMCollectionViewSwipeCell/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMCollectionViewSwipeCell/*.h'
end

s.subspec 'PMInnerShadowView' do |ss|
ss.source_files = 'Pod/Classes/PMInnerShadowView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMInnerShadowView/*.h'
end

s.subspec 'PMGradientView' do |ss|
ss.source_files = 'Pod/Classes/PMGradientView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMGradientView/*.h'
end

s.subspec 'PMInfiniteScrollView' do |ss|
ss.source_files = 'Pod/Classes/PMInfiniteScrollView/*.{h,m}'
ss.public_header_files = 'Pod/Classes/PMInfiniteScrollView/*.h'
ss.dependency 'PMUtils/UIKit+PMUtils'
ss.frameworks = 'MapKit'
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
