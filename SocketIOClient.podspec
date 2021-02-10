#
# Be sure to run `pod lib lint SocketIOClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# CREATE
#   * pod lib create SocketIOClient
#   * ios>swift>yes>None>No
#   * Push to git and release
#   * pod trunk register rashedgit@gmail.com 'Rz Rasel'
#   * pod lib lint SocketIOClient.podspec --allow-warnings
#   * [pod lib lint SocketIOClient.podspec --allow-warnings --no-clean --verbose]
#   * pod trunk push --allow-warnings
# UPDATE
#   * pod lib lint --allow-warnings
#   * Push to git and release
#   * pod trunk push --allow-warnings ORRR>> pod trunk push SocketIOClient.podspec --allow-warnings
# SocketIOClient Version - 0.1.0.00

Pod::Spec.new do |s|
  s.name             = 'SocketIOClient'
  s.version          = '0.1.0.00'
  s.summary          = 'A short description of SocketIOClient.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'A short description of SocketIOClient.'
                       DESC

  s.homepage         = 'https://github.com/arzrasel/SocketIOClient'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Md. Rashed - Uz - Zaman' => 'rashedgit@gmail.com' }
  s.source           = { :git => 'https://github.com/arzrasel/SocketIOClient.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

#  s.ios.deployment_target = '9.0'

#  s.source_files = 'SocketIOClient/Classes/**/*'
  s.ios.deployment_target = '11.0'
  s.source_files = 'Source/**/*.swift'
  
  # s.resource_bundles = {
  #   'SocketIOClient' => ['SocketIOClient/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Socket.IO-Client-Swift', '~> 15.2.0'
end
