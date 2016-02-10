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
//  MFApplication.m
//  MFCore
//
//

#import "MFCoreBean.h"
#import "MFCoreFoundationExt.h"
#import "MFCoreAction.h"

#import "MFApplication.h"
#import "MFSettingsValidationManager.h"
#import "MFSecurityUtils.h"

@interface MFApplication()

@end


@implementation MFApplication

/*! identifier of the connected resource */
long currentUserResource;
static NSTimeInterval startDate;
NSString *synchroEntryPoint ;

+(instancetype) getInstance{
    //Faire un singleton
    static MFApplication *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(id)init {
    self = [super init];
    if(self) {
        MFApplication.startDate = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (id) getBeanWithKey:(NSString *) key{
    @synchronized([MFBeanLoader getInstance]) {
        return [[MFBeanLoader getInstance] getBeanWithKey:key];
    }
}

- (id) getBeanWithType:(id)classOrProtocol {
    @synchronized([MFBeanLoader getInstance]) {
        return [[MFBeanLoader getInstance] getBeanWithType:classOrProtocol];
    }
}

- (id) getOptionalBeanWithKey:(NSString *)key {
    @synchronized([MFBeanLoader getInstance]) {
        return [[MFBeanLoader getInstance] getOptionalBeanWithKey:key];
    }
}

- (NSArray *) getAllBeansWithType:(id)classOrProtocol {
    @synchronized([MFBeanLoader getInstance]) {
        return [[MFBeanLoader getInstance] getAllBeansWithType:classOrProtocol];
    }
}

-(BOOL) isInMainQueue {
    return [MFHelperQueue isInMainQueue];
}

-(void) execInMainQueue:(void (^)())bloc {
    [MFHelperQueue execInMainQueue:bloc];
}

-(void) execSyncInMainQueue:(void (^)())bloc {
    [MFHelperQueue execSyncInMainQueue:bloc];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn {
    [[MFActionLauncher getInstance] launchAction:actionName withCaller:caller withInParameter:parameterIn andChainActions:nil];
}

-(NSString *) userName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE] ;
}

-(void) setUserName:(NSString *) p_userName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:p_userName forKey:APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE];
    [defaults synchronize] ;
}

-(NSString *) userPassword {
    return [MFKeychain retrievePasswordFromKeychain];
}

-(void) setUserPassword:(NSString *) p_userPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:p_userPassword forKey:APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE];
    [defaults synchronize] ;
}

-(NSURL *) urlServer {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults URLForKey:APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE] ;
}

-(void) setUrlServer:(NSURL *) p_serverUrl {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setURL:p_serverUrl forKey:APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE];
    [defaults synchronize] ;
}

-(NSURL *) proxyUrl {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * urlsstring = [defaults stringForKey:APPLICATION_PARAMETER_PROXYURL_KEY_PREFERENCE] ;
    return urlsstring ? [[NSURL alloc] initWithString:urlsstring] : nil ;
}

-(void) setPreferenceWithKey:(NSString *) key andValue:(NSString *) p_value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:p_value forKey:key];
    [defaults synchronize] ;
}

-(NSString *) preferenceWithKey:(NSString *) key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:key] ;
}



-(NSString *) getUniqueId
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

-(void) computeSettings
{
    NSURL *url = self.urlServer;
    
    [self setPreferenceWithKey:APPLICATION_COMPUTE_PARAMETER_URLSERVERHOST_KEY_PREFERENCE andValue:[url host]];
    [self setPreferenceWithKey:APPLICATION_COMPUTE_PARAMETER_URLSERVERPORT_KEY_PREFERENCE andIntValue:[[url port] intValue]];
    [self setPreferenceWithKey:APPLICATION_COMPUTE_PARAMETER_URLSERVERPATH_KEY_PREFERENCE andValue:[url path]];
    
    url = self.proxyUrl;
    
    if (url != nil) {
        [self setPreferenceWithKey:APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERHOST_KEY_PREFERENCE andValue:[url host]];
        [self setPreferenceWithKey:APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERPORT_KEY_PREFERENCE andIntValue:[[url port] intValue]];
        [self setPreferenceWithKey:APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERPATH_KEY_PREFERENCE andValue:[url path]];
    }
}

-(void) setPreferenceWithKey:(NSString *) key andIntValue:(NSInteger) p_value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:p_value forKey:key];
    [defaults synchronize] ;
}

-(NSInteger) intPreferenceWithKey:(NSString *) key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

-(long) getCurrentUserResource
{
    return currentUserResource;
}

-(void) setCurrentUserResource:(long)userResource
{
    currentUserResource = userResource;
}

+(NSTimeInterval) timeSinceApplicationLaunch {
    return [[NSDate date] timeIntervalSince1970] - MFApplication.startDate;
}

+(void) setStartDate:(NSTimeInterval) date {
    startDate = date;
}

+(NSTimeInterval) startDate {
    return startDate;
}

@end
