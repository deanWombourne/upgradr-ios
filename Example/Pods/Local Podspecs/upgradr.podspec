#
# Be sure to run `pod lib lint upgradr.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "upgradr"
  s.version          = "0.1.0"
  s.summary          = "Upgradr client library."
  s.description      = <<-DESC
                       Upgradr allows an app to prevent older versions running and to prompt for upgrades
                       DESC
  s.homepage         = "https://github.com/deanWombourne/upgradr"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = ''
  s.author           = { "Sam Dean" => "deanWombourne@gmail.com" }
  s.source           = { :git => "https://github.com/deanWombourne/upgradr.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/deanWombourne'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end