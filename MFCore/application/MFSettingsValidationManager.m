/**
 * Copyright (C) 2010 Sopra (support_movalys@sopra.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
//
//  MFSettingsValidationManager.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreFoundationExt.h"
#import "MFCoreAction.h"
#import "MFCoreI18n.h"

#import "MFSettingsValidationManager.h"
#import "MFStarter.h"
#import "MFCoreSecurity.h"

const int TAG_FOR_SETTINGS_UNCOMPLETE_ALERT = 2 ;

NSString *const APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE  = @"username_preference" ;
NSString *const APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE  = @"pwd_preference" ;
NSString *const APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE = @"url_preference" ;

NSString *const APPLICATION_PARAMETER_PROXYLOGIN_KEY_PREFERENCE  = @"proxylogin_preference" ;
NSString *const APPLICATION_PARAMETER_PROXYPASSWORD_KEY_PREFERENCE  = @"proxypassword_preference" ;
NSString *const APPLICATION_PARAMETER_PROXYURL_KEY_PREFERENCE  = @"proxyurl_preference" ;

NSString *const APPLICATION_COMPUTE_PARAMETER_URLSERVERHOST_KEY_PREFERENCE  = @"urlserverhost_preference" ;
NSString *const APPLICATION_COMPUTE_PARAMETER_URLSERVERPORT_KEY_PREFERENCE  = @"urlserverport_preference" ;
NSString *const APPLICATION_COMPUTE_PARAMETER_URLSERVERPATH_KEY_PREFERENCE  = @"urlserverpath_preference" ;

NSString *const APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERHOST_KEY_PREFERENCE  = @"proxyurlserverhost_preference" ;
NSString *const APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERPORT_KEY_PREFERENCE  = @"proxyurlserverport_preference" ;
NSString *const APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERPATH_KEY_PREFERENCE  = @"proxyurlserverpath_preference" ;

@interface MFSettingsValidationManager()

/*!
 * @brief A decimal formatter
 */
@property(nonatomic, strong) NSNumberFormatter *decimalFormatter ;

/*!
 * @brief An integer formatter
 */
@property(nonatomic, strong) NSNumberFormatter *integerFormatter ;

/*!
 * @brief A predicate to validates an email string
 */
@property(nonatomic, strong) NSPredicate *emailValidationPredicate ;

@end

@implementation MFSettingsValidationManager

/*!
 * @brief The character n-duplicated to generate a fake password
 */
NSString *FAKE_PASSWORD_MARKER = @"●";

#pragma mark lifecycle

-(id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        [self setupValidationDescription];
    }
    return self;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Methods

-(void) setupValidationDescription {
    
    self.integerFormatter = [[NSNumberFormatter alloc] init];
    [self.integerFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.integerFormatter setAllowsFloats:NO];
    [self.integerFormatter setGeneratesDecimalNumbers:NO];
    
    self.decimalFormatter = [[NSNumberFormatter alloc] init];
    [self.decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.decimalFormatter setAllowsFloats:TRUE];
    
    self.emailValidationPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsUserChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
}


-(void) settingsUserChanged:(NSNotification*) notification {
    [self securePassword];
    [self isUserSettingsValuesCorrect];
}


-(void) securePassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDefaults stringForKey:APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE];
    BOOL isFakePassword = YES;
    if(password && password.length > 0) {
        for(int iCharIndex = 0; iCharIndex < [password length]-1 ; iCharIndex++) {
            isFakePassword = isFakePassword && [[password substringWithRange:NSMakeRange(iCharIndex, 1)] isEqualToString:FAKE_PASSWORD_MARKER];
        }
    }
    if(!isFakePassword) {
        [MFKeychain storePasswordInKeychain:password];
        NSMutableString *fakePassword = [[NSMutableString alloc] initWithCapacity:[password length]];
        for(int iCharIndex = 0; iCharIndex < [password length] ; iCharIndex++) {
            fakePassword = [[fakePassword stringByAppendingString:FAKE_PASSWORD_MARKER] mutableCopy];
        }
        [userDefaults setObject:fakePassword forKey:APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE];
        [userDefaults synchronize];
    }
    
}

#pragma mark - Data type and value Validators
/*!
 *@brief verify that the value has a decimal format contains only true or false
 *@return true if the value is valid
 */
-(NSString *) validateBoolean:(NSString *) value item:(NSDictionary *) item {
    //MFCoreLogVerbose(@"> validateBoolean value %@ item %@ " , value , item );
    
    NSString *upperValue = nil ;
    if ( [value isKindOfClass:[NSString class]] ) {
        upperValue = [value uppercaseString] ;
    } else if ( [value isKindOfClass:[NSNumber class]] ) {
        upperValue = [NSString stringWithFormat:@"%@", (NSNumber*)value ];
    }
    if ( [upperValue  isEqualToString:@"YES"] || [upperValue isEqualToString:@"NO"]
        ||[upperValue isEqualToString:@"TRUE"] ||[upperValue isEqualToString:@"FALSE"]
        ||[upperValue isEqualToString:@"0"] ||[upperValue isEqualToString:@"1"] )
    {
        return @"YES" ;
    }
    return @"NO" ;
}
/*!
 *@brief verify that the value has is conformed to the string specification
 *@return ALWAYS YES
 */
-(NSString *) validateString:(NSString *) value item:(NSDictionary *) item  {
    //MFCoreLogVerbose(@"> validateString value %@ item %@ " , value , item );
    
    NSString *maxLengthSetting = [item objectForKey:@"Max length"] ;
    if ( maxLengthSetting == nil ) {
        maxLengthSetting = [item objectForKey:@"max length"];
    }
    if ( maxLengthSetting && [value length] > [maxLengthSetting intValue] ) {
        return @"NO" ;
    }
    
    NSString *minLengthSetting = [item objectForKey:@"Min length"] ;
    if ( minLengthSetting == nil ) {
        minLengthSetting = [item objectForKey:@"min length"];
    }
    if ( minLengthSetting && [value length] < [minLengthSetting intValue] ) {
        return @"NO" ;
    }
    
    NSString *regexSetting = [item objectForKey:@"Regex"] ;
    if ( regexSetting == nil ) {
        regexSetting = [item objectForKey:@"regex"];
    }
    if ( regexSetting ) {
        NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexSetting];
        return [MFHelperBOOL asString:[regexTest evaluateWithObject:value] ];
    }
    return @"YES" ;
}
/*!
 *@brief verify that the value has is conformed with the regex "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
 *@return YES if OK , NO if not
 */
-(NSString *) validateEmail:(NSString *) value item:(NSDictionary *) item  {
    //MFCoreLogVerbose(@"> validateEmail value %@ item %@ " , value , item );
    
    return [MFHelperBOOL asString:[self.emailValidationPredicate evaluateWithObject:value] ];
}
/*!
 *@brief verify that the value is conformed to the URL specification that conforms to RFC 2396
 *@return ALWAYS YES
 */
-(NSString *) validateUrl:(NSString *) value item:(NSDictionary *) item  {
    //MFCoreLogVerbose(@"> validateURL value %@ item %@ " , value , item );
    NSURL * url = [NSURL URLWithString:value];
    if ( url && url.scheme && url.host ) {
        return @"YES" ;
    }
    return @"NO" ;
}
/*!
 *@brief verify that the value has a decimal format contains only numbers and a decimal sign
 *@return true if the value is valid
 */
-(NSString *) validateDecimal:(NSString *) value item:(NSDictionary *) item  {
    //MFCoreLogVerbose(@"> validateDecimal value %@ item %@ " , value , item );
    
    NSNumber *decimalValue = nil ;
    if ( [value isKindOfClass:[NSString class]] ) {
        decimalValue = [self.decimalFormatter numberFromString:value];
    } else if ( [value isKindOfClass:[NSNumber class]] ) {
        decimalValue = (NSNumber *)value ;
    }
    
    if (!decimalValue) {
        return @"NO" ;
    }
    
    NSString *maxValueSetting = [item objectForKey:@"Maximum"] ;
    if ( maxValueSetting == nil ) {
        maxValueSetting = [item objectForKey:@"maximum"];
    }
    if (maxValueSetting && [self validateDecimal:decimalValue withMaximum:maxValueSetting] == NO) {
        return @"NO" ;
    }
    
    NSString *minValueSetting = [item objectForKey:@"Minimum"] ;
    if ( minValueSetting == nil ) {
        minValueSetting = [item objectForKey:@"minimum"];
    }
    if (minValueSetting && [self validateDecimal:decimalValue withMinimum:minValueSetting] == NO) {
        return @"NO" ;
    }
    return @"YES" ;
}
/*!
 *@brief verify that the value has a integer format , contains only numbers
 *@return true if the value is valid
 */
-(NSString *) validateInteger:(NSString *) value item:(NSDictionary *) item  {
    //MFCoreLogVerbose(@"> validateInteger value %@ item %@ " , value , item );
    
    NSNumber *integerValue = nil ;
    if ( [value isKindOfClass:[NSString class]] ) {
        integerValue = [self.integerFormatter numberFromString:value];
    } else if ( [value isKindOfClass:[NSNumber class]] ) {
        integerValue = (NSNumber *)value ;
    }
    if (!integerValue) {
        return @"NO" ;
    }
    
    NSString *maxValueSetting = [item objectForKey:@"Maximum"] ;
    if ( maxValueSetting == nil ) {
        maxValueSetting = [item objectForKey:@"maximum"];
    }
    if (maxValueSetting && [self validateInteger:integerValue withMaximum:maxValueSetting] == NO) {
        return @"NO" ;
    }
    
    NSString *minValueSetting = [item objectForKey:@"Minimum"] ;
    if ( minValueSetting == nil ) {
        minValueSetting = [item objectForKey:@"minimum"];
    }
    if (minValueSetting && [self validateInteger:integerValue withMinimum:minValueSetting] == NO) {
        return @"NO" ;
    }
    return @"YES" ;
}
/*!
 *@brief verify that the value is less than the max given
 *@return true if the value is valid
 */
-(BOOL) validateInteger:(NSNumber *) integerValue withMaximum:(NSString *) max{
    NSNumber *integerMax = [self.integerFormatter numberFromString:max] ;
    
    if ( [integerValue compare:integerMax] == NSOrderedDescending ) {
        return NO ;
    }
    return YES ;
}
/*!
 *@brief verify that the value is greater than the min given
 *@return true if the value is valid
 */
-(BOOL) validateInteger:(NSNumber *) integerValue withMinimum:(NSString *) min{
    NSNumber *integerMin = [self.integerFormatter numberFromString:min] ;
    if ( [integerValue compare:integerMin] == NSOrderedAscending ) {
        return NO ;
    }
    return YES ;
}
/*!
 *@brief verify that the value is less than the max given
 *@return true if the value is valid
 */
-(BOOL) validateDecimal:(NSNumber *) decimalValue withMaximum:(NSString *) max{
    NSNumber *decimalMax = [self.decimalFormatter numberFromString:max] ;
    
    if ( [decimalValue compare:decimalMax] == NSOrderedDescending ) {
        return NO ;
    }
    return YES ;
}
/*!
 *@brief verify that the value is greater than the min given
 *@return true if the value is valid
 */
-(BOOL) validateDecimal:(NSNumber *) decimalValue withMinimum:(NSString *) min{
    NSNumber *decimalMin = [self.decimalFormatter numberFromString:min] ;
    if ( [decimalValue compare:decimalMin] == NSOrderedAscending ) {
        return NO ;
    }
    return YES ;
}

#pragma mark - Global verification of data

-(BOOL) isUserSettingsValuesCorrect {
    return [self verifySettingsValuesOfPList:@"Root"] ;
}

-(BOOL) verifySettingsValuesOfPList:(NSString *) childPanePListFileName {
    //MFCoreLogVerbose(@">verifySettingsValuesOfPList panel %@ ", childPanePListFileName );
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSString *settingsPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *plistFile = [settingsPath stringByAppendingPathComponent:[childPanePListFileName stringByAppendingString:@".plist"]];
    
    //Get the Preferences Array from the dictionary
    NSArray *preferencesArray = [[NSDictionary dictionaryWithContentsOfFile:plistFile] objectForKey:@"PreferenceSpecifiers"];
    
    //Loop through the array
    BOOL isInvalidSettings = NO ;
    for(NSDictionary *item in preferencesArray)
    {
        NSString *typeOfPreference = [item objectForKey:@"Type"];
        if ( [typeOfPreference isEqualToString:@"PSChildPaneSpecifier"] == YES ) {
            isInvalidSettings = [self verifySettingsValuesOfPList:[item objectForKey:@"File"]] == NO ;
        } else {
            isInvalidSettings = [self verifySettingsItem:item] ;
        }
        if ( isInvalidSettings ) {
            break ;
        }
    }
    // message seulement si y a une erreur récupérée dans le fichier principal
    if ( [childPanePListFileName isEqualToString:@"Root"] && isInvalidSettings ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:MFLocalizedStringFromKey(@"error_nosettingsparameterized") delegate:self cancelButtonTitle:MFLocalizedStringFromKey(@"error_nosettingsparameterized_quitbutton") otherButtonTitles: nil] ;
        alert.tag = TAG_FOR_SETTINGS_UNCOMPLETE_ALERT ;
        [alert show];
        MFCoreLogVerbose(@"<verifySettingsValuesOfPList NO");
        return NO ;
    }
    MFCoreLogVerbose(@"<verifySettingsValuesOfPList YES");
    return YES ;
}
-(BOOL) verifySettingsItem:(NSDictionary *) item {
    BOOL r_isIncompleteSettings = NO ;
    NSString *typeOfPreference = [item objectForKey:@"Type"];
    // les groupes et titre n'ont pas de valeur
    if ( [typeOfPreference isEqualToString:@"PSTitleValueSpecifier"] == NO
        &&  [typeOfPreference isEqualToString:@"PSGroupSpecifier"] == NO ){
        
        r_isIncompleteSettings = [self verifyMandatorySettingsItem:item];
        if ( r_isIncompleteSettings == NO ) {
            r_isIncompleteSettings = [self verifyDataTypeSettingsItem:item];
        }
    }
    return r_isIncompleteSettings ;
}
-(BOOL) verifyMandatorySettingsItem:(NSDictionary *) item {
    BOOL r_isIncompleteSettings = NO ;
    // on tolere l'oubli de la majuscule
    id isMandatory = [item objectForKey:@"Mandatory"];
    if ( isMandatory == nil ) {
        isMandatory = [item objectForKey:@"mandatory"];
    }
    if ( [MFHelperBOOL booleanValue:isMandatory] ) {
        NSString *keyPreference = [item objectForKey:@"Key"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userPreference = [defaults stringForKey:keyPreference] ;
        MFCoreLogVerbose(@"verify mandatory of key '%@' with value '%@'", keyPreference , userPreference);
        if ( userPreference == nil || [userPreference length] == 0) {
            MFCoreLogVerbose(@"verifyMandatorySettingsItem FALSE with key '%@'" , keyPreference);
            r_isIncompleteSettings = YES ;
        }
    }
    return r_isIncompleteSettings ;
}

-(BOOL) verifyDataTypeSettingsItem:(NSDictionary *) item {
    //MFCoreLogVerbose(@"> verifyDataTypeSettingsItem");
    
    BOOL r_isInvalidSettings = NO ;
    // on tolere l'oubli de la majuscule
    id dataType = [item objectForKey:@"Data type"];
    if ( dataType == nil ) {
        dataType = [item objectForKey:@"data type"];
    }
    
    if (dataType) {
        NSString *userPreference = [[NSUserDefaults standardUserDefaults] stringForKey:[item objectForKey:@"Key"]] ;
        //MFCoreLogVerbose(@"verify data type ('%@') of key '%@' with value '%@'", dataType , [item objectForKey:@"Key"] , userPreference);
        
        if ( userPreference && [userPreference length] > 0) { // we have a value in the user defaults
            SEL validateSelector  = NSSelectorFromString([@"validate" stringByAppendingFormat:@"%@:item:",[dataType capitalizedString]]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([self respondsToSelector:validateSelector]) {
                id isValid = [self performSelector:validateSelector withObject:userPreference withObject:item];
                //MFCoreLogVerbose(@"> validate result isValid %@ item %@ value %@" , isValid , item , userPreference);
                
                r_isInvalidSettings = [isValid isEqualToString:@"NO"];
            }
#pragma clang diagnostic pop
        }
    }
    //MFCoreLogVerbose(@"< verifyDataTypeSettingsItem %d" , r_isInvalidSettings );
    
    return r_isInvalidSettings ;
}

-(void) verifyIfUserFwkSettingsHasChanged{
    //MFCoreLogVerbose(@"> verifyIfUserFwkSettingsHasChanged (_started %d) (isFirstLaunching %d)", [[MFApplication getInstance] isStarted]  , [[MFApplication getInstance] isFirstLaunching]);
    
    if ( [[MFStarter getInstance] isFirstLaunching] == NO ){
        if ( [self isUserFwkSettingsHasChanged] == YES) {
            if ([[MFStarter getInstance] isStarted] == NO ) {
                [[MFStarter getInstance] start];
            }
            // launch export of database
            [[MFActionLauncher getInstance] launchAction:@"MFExportDatabaseAction" withCaller:self  withInParameter:nil];
            MFCoreLogError(@"After export Reset database to launch because settings have changed");
            // launch reset of database
            [[MFActionLauncher getInstance] launchAction:@"MFResetDatabaseAction" withCaller:self  withInParameter:nil];
            [self copyUserFwkSettingsToNotModifiableSettings];
        }
    } else {
        [self copyUserFwkSettingsToNotModifiableSettings];
    }
    MFCoreLogVerbose(@"< verifyIfUserFwkSettingsHasChanged");
}

NSString *const SUFFIX_NOT_MODIFIABLE_PREFERENCES = @"_notModifiableByInterface";

-(void) copyUserFwkSettingsToNotModifiableSettings {
    MFCoreLogVerbose(@"> copyUserFwkSettingsToNotModifiableSettings");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userNameSettings = [defaults stringForKey:APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE] ;
    [defaults setObject:userNameSettings forKey:[APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE stringByAppendingString:SUFFIX_NOT_MODIFIABLE_PREFERENCES]] ;
    
    NSString *pwdSettings = [defaults stringForKey:APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE] ;
    [defaults setObject:pwdSettings forKey:[APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE stringByAppendingString:SUFFIX_NOT_MODIFIABLE_PREFERENCES]] ;
    
    NSString *urlServerSettings = [defaults stringForKey:APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE] ;
    [defaults setObject:urlServerSettings forKey:[APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE stringByAppendingString:SUFFIX_NOT_MODIFIABLE_PREFERENCES]] ;
    [defaults synchronize];
    MFCoreLogVerbose(@"< copyUserFwkSettingsToNotModifiableSettings");
}
-(BOOL) isUserFwkSettingsHasChanged {
    MFCoreLogVerbose(@"isUserFwkSettingsHasChanged");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *settings = [defaults stringForKey:APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE] ;
    NSString *notModifiableSettings = [defaults stringForKey:[APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE stringByAppendingString:SUFFIX_NOT_MODIFIABLE_PREFERENCES]] ;
    if ( settings != nil && [settings isEqualToString:notModifiableSettings] == NO){
        MFCoreLogVerbose(@"isUserFwkSettingsHasChanged YES username '%@' to '%@' "  , notModifiableSettings, settings);
        return YES ;
    }
    settings = [defaults stringForKey:APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE] ;
    notModifiableSettings = [defaults stringForKey:[APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE stringByAppendingString:SUFFIX_NOT_MODIFIABLE_PREFERENCES]] ;
    if ( settings != nil &&  [settings isEqualToString:notModifiableSettings] == NO){
        MFCoreLogVerbose(@"isUserFwkSettingsHasChanged YES pwd '%@' to '%@' " , notModifiableSettings, settings);
        return YES ;
    }
    settings = [defaults stringForKey:APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE] ;
    notModifiableSettings = [defaults stringForKey:[APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE stringByAppendingString:SUFFIX_NOT_MODIFIABLE_PREFERENCES]] ;
    if ( settings != nil && [settings isEqualToString:notModifiableSettings] == NO){
        MFCoreLogVerbose(@"isUserFwkSettingsHasChanged YES urlserver '%@' to '%@' " , notModifiableSettings, settings);
        return YES ;
    }
    MFCoreLogVerbose(@"isUserFwkSettingsHasChanged NO");
    return NO ;
}

@end
