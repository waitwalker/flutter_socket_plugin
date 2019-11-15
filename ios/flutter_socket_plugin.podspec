#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_socket_plugin'
  s.version          = '1.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://waitwalker.cn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'waitwalker' => 'waitwalker@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.swift_version = '5.0'
  s.dependency 'Flutter'
  s.dependency 'CocoaAsyncSocket'

  s.ios.deployment_target = '9.0'
end

