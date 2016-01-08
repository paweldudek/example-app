source 'https://github.com/CocoaPods/Specs'
source 'https://github.com/Taptera/cocoapods-specs'

platform :ios, '8.0'

inhibit_all_warnings!

xcodeproj 'ExampleApp'

target 'ExampleApp' do
  pod 'MTDates'
  pod 'PureLayout'
  pod 'FastImageCache'
  pod 'KZPropertyMapper'
end

target 'ExampleAppSpecs' do
  # Turn on once Cocoapods 1.0 ships
  # inherit! :search_paths
  pod 'OCMockito'
  pod 'Expecta'
  pod 'Specta', :git => 'https://github.com/taptera/specta', :commit => '1ee950e0ec6c115c2cf1c0a9444d7f2b198f3bd4'
end
