#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_photokit'
  s.version          = '0.1'
  s.summary          = 'Flutter plugin for interacting with PhotoKit on iOS.'
  s.description      = <<-DESC
Flutter plugin for interacting with PhotoKit on iOS.
                       DESC
  s.homepage         = 'https://github.com/kmorkos/flutter_photokit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Craterland, Inc.' => 'dev@crater.land' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end
