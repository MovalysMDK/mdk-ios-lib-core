Pod::Spec.new do |s|
  s.name         = "MFCore"
  s.version      = "1.0.0"
  s.summary      = "Movalys Framework MFCore."  
  s.homepage     = "http://nansrvintc1.adeuza.fr/mfdocs-4.0/"
  s.license      = {
     :type => 'Commercial',
     :text => <<-LICENSE
          TODO
     LICENSE
  }

  s.author       = "Sopra Group"
  s.source       = { :git => "gitmovalys@git.ptx.fr.sopra:mfcore.git", :branch => "Cotopaxi" }
  s.platform     = :ios, '5.0'

  s.dependency 'Nimbus', '~>1.0'
  s.dependency 'CocoaLumberjack', '~>1.6'
  s.dependency 'MagicalRecord', '~>2.1'
  s.dependency 'ViewDeck', '~>2.2.0'
  s.dependency 'Typhoon'
  s.dependency 'MBProgressHUD'
  s.frameworks   = 'QuartzCore', 'CoreText'
  s.header_mappings_dir = '.'

  s.subspec 'MFCore_Application' do |application|
    application.source_files = 'MFCore/**/MFBeansKeys.{h,m}' ,'MFCore/**/MFConstants.{h,m}' ,'MFCore/**/MFSettingsValidationManager.{h,m}' ,'MFCore/**/MFApplication.{h,m}' ,'MFCore/**/MFSplashViewDelegateProtocol.{h,m}' ,'MFCore/**/MFDelegate.{h,m}' ,'MFCore/**/MFTransitionController.{h,m}' ,'MFCore/**/MFLocalizedString.{h,m}'
    application.requires_arc = true
  end

  s.subspec 'MFCore_Configuration' do |configuration|
    configuration.source_files = 'MFCore/**/MF*{Configuration,Property}*.{h,m}'
    configuration.requires_arc = true
  end

  s.subspec 'MFCore_Reader' do |mfreader|
    mfreader.source_files = 'MFCore/**/MFReader*.{h,m}'
    mfreader.requires_arc = true
  end

  s.subspec 'MFCore_Builder' do |builder|
    builder.source_files = 'MFCore/**/MFBuilder*.{h,m}'
    builder.requires_arc = true
  end

  s.subspec 'MFCore_Validator' do |mfvalidator|
    mfvalidator.source_files = 'MFCore/**/MFValidator*.{h,m}'
    mfvalidator.requires_arc = true
  end

  s.subspec 'MFCore_Action' do |action|
    action.source_files = 'MFCore/**/MFAction*.{h,m}', 'MFCore/**/*Action.{h,m}'
    action.requires_arc = true
  end

  s.subspec 'MFCore_Context' do |context|
    context.source_files = 'MFCore/**/MFContext*.{h,m}'
    context.requires_arc = true
  end

  s.subspec 'MFCore_CSV' do |csv|
    csv.source_files = 'MFCore/**/*Csv*.{h,m}', 'MFCore/**/*CSV*.{h,m}'
    csv.requires_arc = true
  end

  s.subspec 'MFCore_DataLoader' do |dataloader|
    dataloader.source_files = 'MFCore/**/*DataLoader*.{h,m}', 'MFCore/**/MFEntityLoaderProtocol.{h,m}','MFCore/**/MFListEntitiesLoaderProtocol.{h,m}'
    dataloader.requires_arc = true
  end

  s.subspec 'MFCore_DataStructure' do |dataStructure|
    dataStructure.source_files = 'MFCore/**/MFLinkedList.{h,m}', 'MFCore/**/MFStack.{h,m}','MFCore/**/NSString+StringUtilities.{h,m}', 'MFCore/**/MFURL.{h,m}', 'MFCore/**/NSData+Utilities.{h,m}'
    dataStructure.requires_arc = true
  end

  s.subspec 'MFCore_FormDescriptor' do |formDescriptor|
    formDescriptor.source_files = 'MFCore/descriptor/form/MF*Descriptor*.{h,m}'
    formDescriptor.requires_arc = true
  end

  s.subspec 'MFCore_Error' do |error|
    error.source_files = 'MFCore/**/MF*Error*.{h,m}'
    error.requires_arc = true
  end

  s.subspec 'MFCore_Exception' do |exception|
    exception.source_files = 'MFCore/**/MF*Exception*.{h,m}', 'MFCore/**/MFKeyNotFound.{h,m}'
    exception.requires_arc = true
  end

  s.subspec 'MFCore_Helper' do |helper|
    helper.source_files = 'MFCore/**/MFHelper*.{h,m}'
    helper.requires_arc = true
  end

  s.subspec 'MFCore_Logging' do |logging|
    logging.source_files = 'MFCore/**/MF*Logging*.{h,m}'
    logging.requires_arc = true
  end

  s.subspec 'MFCore_Message' do |message|
    message.source_files = 'MFCore/**/MFMessage*.{h,m}'
    message.requires_arc = true
  end

  s.subspec 'MFCore_RunInit' do |runinit|
    runinit.source_files = 'MFCore/**/MF*RunInit*.{h,m}'
    runinit.requires_arc = true
  end

  s.subspec 'MFCore_ViewController' do |viewcontroller|
    viewcontroller.source_files = 'MFCore/**/MF*ViewController*.{h,m}'
    viewcontroller.requires_arc = true
  end

  s.subspec 'MFCore__Classes' do |classes|
    classes.source_files = 'MFCore/**/*.{h,m}'
    classes.exclude_files = 'MFCore_Reader', 'MFCore_Builder', 'MFCore_Validator', 'MFCore_Action', 'MFCore_Context', 'MFCore_CSV', 'MFCore_DataLoader', 'MFCore_DataStructure', 'MFCore_FormDescriptor', 'MFCore_Error', 'MFCore_Exception', 'MFCore_Helper', 'MFCore_Logging', 'MFCore_Message', 'MFCore_RunInit', 'MFCore_ViewController'
    classes.requires_arc = true
  end
end