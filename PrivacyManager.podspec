Pod::Spec.new do |s|
  s.name             = 'PrivacyManager'
  s.version          = '1.0.1'
  s.summary          = 'Make it easier to obtain device information and make coding easier.'
  s.description      = <<-DESC
    A binary-only precompiled framework for retrieving iOS device information.
  DESC
  s.homepage         = 'https://github.com/kandaofu/PrivacyManager'
  s.license = { :type => 'Proprietary', :text => 'Binary-only internal distribution. All rights reserved.' }
  s.author           = { 'kandaofu' => '' }
  s.platform         = :ios, '13.0'

  s.source = {
    :http => 'https://github.com/kandaofu/PrivacyManager/releases/download/1.0.1/PrivacyManager.xcframework.zip'
  }

  s.vendored_frameworks = 'PrivacyManager.xcframework'
  s.preserve_paths = 'PrivacyManager.xcframework'
end