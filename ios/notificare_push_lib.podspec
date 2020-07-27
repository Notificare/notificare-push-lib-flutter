#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'notificare_push_lib'
  s.version          = '2.4.0'
  s.summary          = 'Notificare Flutter Plugin'
  s.description      = <<-DESC
Notificare Flutter Plugin implements the power of smart notifications, location services, contextual marketing and powerful loyalty solutions provided by the Notificare platform in Flutter applications.\n\nFor documentation please refer to: http://docs.notifica.re\n\nFor support please use: http://support.notifica.re
                       DESC
  s.homepage         = 'https://notificare.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Notificare' => 'info@notificare.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'notificare-push-lib', '2.4-beta2'
  s.ios.deployment_target = '9.0'
  s.static_framework = true
end
