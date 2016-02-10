Pod::Spec.new do |s|
  s.name         = "MFCore"
  s.version      = "1.1.3"
  s.summary      = "Movalys Framework MFCore."
  s.homepage     = "http://nansrvintc1.adeuza.fr/mfdocs-4.0/"
  s.license      = {
     :type => 'Commercial',
     :text => <<-LICENSE
          TODO
     LICENSE
  }

  s.author       = "Sopra Group"
  s.source       = { :git => "", :tag => "1.1.3" }
  s.platform     = :ios, '5.1'

  s.dependency 'JSONKit', '~>1.6'
  s.dependency 'CocoaLumberjack', '~>1.7'
  s.dependency 'MagicalRecord', '~>2.2'
  s.dependency 'CocoaSecurity', '~>1.2.4'
  s.frameworks   =  'CoreText'
  
  s.header_mappings_dir = '.'
  s.requires_arc = true
  s.source_files = 'MFCore/*.{h,m}'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-lz' }
 
  s.subspec 'FoundationExt' do |foundationExt|
    foundationExt.source_files = 'MFCore/foundationExt'
    foundationExt.compiler_flags = '-lz'
  end
 
  s.subspec 'Messsage' do |message|
    message.source_files = 'MFCore/message'
  end

  s.subspec 'Log' do |log|
    log.source_files = 'MFCore/log'
    log.dependency 'CocoaLumberjack', '~>1.6'
  end
  
  s.subspec 'I18n' do |i18n|
    i18n.source_files = 'MFCore/i18n'
  end
  
  s.subspec 'Error' do |error|
    error.source_files = 'MFCore/error'
    error.dependency 'MFCore/I18n'
  end

  s.subspec 'Bean' do |bean|
    bean.source_files = 'MFCore/bean'
    bean.dependency 'MFCore/Log'
  end
  
  s.subspec 'Context' do |context|
    context.source_files = 'MFCore/context'
    context.dependency 'MFCore/Bean'
  end
  
  s.subspec 'Config' do |config|
    config.source_files = 'MFCore/config'
    config.dependency 'MFCore/Bean'
    config.dependency 'MFCore/Log'
  end

  s.subspec 'Init' do |init|
    init.source_files = 'MFCore/init'
    init.dependency 'MFCore/Context'
    init.dependency 'MFCore/Config'
  end

  s.subspec 'Coredata' do |coredata|
    coredata.source_files = 'MFCore/coredata'
    coredata.dependency 'MFCore/Context'
    coredata.dependency 'MFCore/Log'
    coredata.dependency 'MFCore/Config'
  end

  s.subspec 'FormDescriptor' do |formdescriptor|
    formdescriptor.source_files = 'MFCore/form/descriptor'
    formdescriptor.dependency 'MFCore/FoundationExt'
    formdescriptor.dependency 'MFCore/Log'
    formdescriptor.dependency 'MFCore/Bean'
    formdescriptor.dependency 'MFCore/Config'
  end
  
  s.subspec 'FormValidator' do |formvalidator|
    formvalidator.source_files = 'MFCore/form/validator'
    formvalidator.dependency 'MFCore/FormDescriptor'
  end

  s.subspec 'FormReader' do |formreader|
    formreader.source_files = 'MFCore/form/reader'
    formreader.dependency 'MFCore/FormDescriptor'
    formreader.dependency 'MFCore/FormValidator'
  end

  s.subspec 'FormConfig' do |formconfig|
    formconfig.source_files = 'MFCore/form/config'
    formconfig.dependency 'MFCore/Config'
    formconfig.dependency 'MFCore/FormDescriptor'
  end

  s.subspec 'FormInit' do |forminit|
    forminit.source_files = 'MFCore/form/init'
    forminit.dependency 'MFCore/Log'
    forminit.dependency 'MFCore/Init'
    forminit.dependency 'MFCore/Bean'
    forminit.dependency 'MFCore/FormConfig'
  end

  s.subspec 'FormBuilder' do |formbuilder|
    formbuilder.source_files = 'MFCore/form/builder'
    formbuilder.dependency 'MFCore/Log'
    formbuilder.dependency 'MFCore/Bean'
    formbuilder.dependency 'MFCore/FormDescriptor'
    formbuilder.dependency 'MFCore/FormReader'
  end

  s.subspec 'Action' do |action|
    action.source_files = 'MFCore/Action'
    action.dependency 'MFCore/FoundationExt'
    action.dependency 'MFCore/Log'
    action.dependency 'MFCore/Coredata'
    action.dependency 'MFCore/Context'
  end

  s.subspec 'Dataloader' do |dataloader|
    dataloader.source_files = 'MFCore/dataloader'
    dataloader.dependency 'MFCore/Context'
    dataloader.dependency 'MFCore/Action'
  end

  s.subspec 'Csvloader' do |csvloader|
    csvloader.source_files = 'MFCore/csvloader'
    csvloader.dependency 'MFCore/Init'
    csvloader.dependency 'MFCore/Log'
    csvloader.dependency 'MFCore/Context'
  end
  
  s.subspec 'Application' do |application|
    application.source_files = 'MFCore/application'
    application.dependency 'MFCore/Bean'
    application.dependency 'MFCore/FoundationExt'
    application.dependency 'MFCore/Action'
  end

  s.subspec 'Business' do |business|
    business.source_files = 'MFCore/business'
    business.dependency 'MFCore/Bean'
    business.dependency 'MFCore/FoundationExt'
    business.dependency 'MFCore/Action'
  end
  
  s.subspec 'Synchro' do |synchro|
    synchro.source_files = 'MFCore/synchro'
  end

  s.subspec 'SynchroBusiness' do |synchrobusiness|
    synchrobusiness.source_files = 'MFCore/synchro/business'
    synchrobusiness.dependency 'MFCore/Application'
    synchrobusiness.dependency 'MFCore/Config'
    synchrobusiness.dependency 'MFCore/Action'
    synchrobusiness.dependency 'MFCore/SynchroResponse'
    synchrobusiness.dependency 'MFCore/SynchroService'
    synchrobusiness.dependency 'MFCore/SynchroInvocation'
    synchrobusiness.dependency 'MFCore/SynchroResponse'
    synchrobusiness.dependency 'MFCore/SynchroRequest'
    synchrobusiness.dependency 'MFCore/SynchroCredentials'
    synchrobusiness.dependency 'MFCore/SynchroReachability'
  end

  s.subspec 'SynchroCredentials' do |synchrocredentials|
    synchrocredentials.source_files = 'MFCore/synchro/credentials'
  end

  s.subspec 'SynchroReachability' do |synchroreachability|
    synchroreachability.source_files = 'MFCore/synchro/reachability'
  end
  
  s.subspec 'SynchroRest' do |synchrorest|
    synchrorest.source_files = 'MFCore/synchro/rest'
  end

  s.subspec 'SynchroAuthority' do |synchroauthority|
    synchroauthority.source_files = 'MFCore/synchro/rest/auth/**/*.{h,m}'
  end

  s.subspec 'SynchroInvocation' do |synchroinvocation|
    synchroinvocation.source_files = 'MFCore/synchro/rest/invoker'
    synchroinvocation.dependency 'JSONKit', '~>1.6'
    synchroinvocation.dependency 'MFCore/Context'
    synchroinvocation.dependency 'MFCore/Application'
    synchroinvocation.dependency 'MFCore/Action'
    synchroinvocation.dependency 'MFCore/Error'
    synchroinvocation.dependency 'MFCore/SynchroRequest'
    synchroinvocation.dependency 'MFCore/SynchroResponse'
    synchroinvocation.dependency 'MFCore/SynchroAuthority'
    synchroinvocation.dependency 'MFCore/SynchroBusiness'
    synchroinvocation.dependency 'MFCore/SynchroJson'
  end

  s.subspec 'SynchroJson' do |synchrojson|
    synchrojson.source_files = 'MFCore/synchro/rest/json'
    synchrojson.dependency 'MFCore/FoundationExt'
    synchrojson.dependency 'MFCore/SynchroRequest'
    synchrojson.dependency 'MFCore/Application'
    synchrojson.dependency 'JSONKit', '~>1.6'
  end

  s.subspec 'SynchroRequest' do |synchrorequest|
    synchrorequest.source_files = 'MFCore/synchro/rest/request'
    synchrorequest.dependency 'MFCore/Context'
    synchrorequest.dependency 'MFCore/FoundationExt'
    synchrorequest.dependency 'MFCore/Application'
    synchrorequest.dependency 'MFCore/Log'
    synchrorequest.dependency 'MFCore/SynchroBusiness'
    synchrorequest.dependency 'MFCore/SynchroJson'
  end

  s.subspec 'SynchroResponse' do |synchroresponse|
    synchroresponse.source_files = 'MFCore/synchro/rest/response'
    synchroresponse.dependency 'MFCore/Context'
    synchroresponse.dependency 'MFCore/Application'
    synchroresponse.dependency 'MFCore/SynchroRequest'
    synchroresponse.dependency 'MFCore/SynchroBusiness'
    synchroresponse.dependency 'MFCore/SynchroJson'
  end

  s.subspec 'SynchroService' do |synchroservice|
    synchroservice.source_files = 'MFCore/synchro/service'
    synchroservice.dependency 'MFCore/Context'
  end

  s.subspec 'Security' do |security|
    security.source_files = 'MFCore/security'
    security.dependency 'MFCore/Bean'
    security.dependency 'CocoaSecurity', '~>1.2.4'
  end

  s.subspec 'SecurityWrapper' do |securitywrapper|
    securitywrapper.source_files = 'MFCore/security/wrapper'
    securitywrapper.requires_arc = false
  end


end
