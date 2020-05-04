#
# Be sure to run `pod lib lint KSCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSCore'
  s.version          = '0.1.0'
  s.summary          = 'A short description of KSCore.'


  s.description      = 'Pod for core view controller to ease development'

  s.homepage         = 'https://github.com/kseta233/KSCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kseta233' => 'kusuma.seta@silverglobe.com' }
  s.source           = { :git => 'https://github.com/kseta233/KSCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KSCore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KSCore' => ['KSCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MBProgressHUD', '~> 1.2.0'
end
