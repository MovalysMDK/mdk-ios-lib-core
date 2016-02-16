#
#  Be sure to run `pod spec lint MDKControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "MFCore"
  spec.version      = "2.2.0"
  spec.summary      = "Movalys Framework MFCore."
  spec.homepage     = "http://www.movalys.org"
  spec.license      = { :type => 'LGPLv3', :file => 'LGPLv3-LICENSE.txt' }

  spec.author               = "Sopra Steria Group"
  spec.source               = { :git => "https://github.com/MovalysMDK/mdk-ios-lib-core.git", :tag => "2.2.0" }
  spec.platform             = :ios, '8.0'
  spec.header_mappings_dir  = '.'
  spec.requires_arc         = true
  spec.source_files         = 'MFCore/**/*.{h,m}'
  spec.xcconfig             = { 'OTHER_LDFLAGS' => '-lz' }
  spec.frameworks           =  'CoreText'

  spec.subspec 'Dependencies' do|dep|
    dep.dependency 'MDKJSONKit', '1.0.0'
    dep.dependency 'CocoaLumberjack', '2.0.0'
    dep.dependency 'MagicalRecord', '2.2'
    dep.dependency 'CocoaSecurity', '1.2.4'
  end

  spec.subspec 'SecurityWrapper' do |securitywrapper|
    securitywrapper.source_files = 'MFCore/security/KeychainItemWrapper.{h,m}'
    securitywrapper.requires_arc = false
  end

  spec.exclude_files = 'MFCore/security/KeychainItemWrapper.{h,m}'

end
