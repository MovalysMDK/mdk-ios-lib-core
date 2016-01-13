Pod::Spec.new do |s|
  s.name         = "MFCore"
  s.version      = "2.0.1"
  s.summary      = "Movalys Framework MFCore."
  s.homepage     = "http://nansrvintc1.adeuza.fr/mfdocs-5.1.0/"
  s.license      = {
     :type => 'Commercial',
     :text => <<-LICENSE
          TODO
     LICENSE
  }

  s.author       = "Sopra Steria"
  s.source       = { :git => "", :tag => "2.0.1" }
  s.platform     = :ios, '8.0'
  s.header_mappings_dir = '.'
  s.requires_arc = true
  s.source_files = 'MFCore/**/*.{h,m}'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-lz' }
  s.frameworks   =  'CoreText'


  s.subspec 'Dependencies' do|dep| 
    dep.dependency 'JSONKit', '>= 1.6'
    dep.dependency 'CocoaLumberjack', '2.0.0'
    dep.dependency 'MagicalRecord', '2.2'
    dep.dependency 'CocoaSecurity', '1.2.4'
  end

  s.subspec 'SecurityWrapper' do |securitywrapper|
    securitywrapper.source_files = 'MFCore/security/KeychainItemWrapper.{h,m}'
    securitywrapper.requires_arc = false
  end

  s.exclude_files = 'MFCore/security/KeychainItemWrapper.{h,m}'


end
