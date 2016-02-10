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
//  MFRestConnectionConfig.m
//  MFCore
//
//

#import "MFRestConnectionConfig.h"
#import "MFCoreBean.h"
#import "MFConfigurationHandler.h"
#import "MFException.h"
#import "MFApplication+MFRestUserConnectionConfig.h"

NSString * REST_CONNECTION_CONFIGURATION_KEY = @"RestConnectionConfiguration";


NSString * REST_CONNECTION_CONFIGURATION_HOST_KEY = @"host";
NSString * REST_CONNECTION_CONFIGURATION_PORT_KEY = @"port";
NSString * REST_CONNECTION_CONFIGURATION_PATH_KEY = @"path";
NSString * REST_CONNECTION_CONFIGURATION_WSENTRYPOINT_KEY = @"wsEntryPoint";
NSString * REST_CONNECTION_CONFIGURATION_COMMAND_KEY = @"command";
NSString * REST_CONNECTION_CONFIGURATION_USER_KEY = @"user";
NSString * REST_CONNECTION_CONFIGURATION_PASSWORD_KEY = @"password";
NSString * REST_CONNECTION_CONFIGURATION_PROXYHOST_KEY = @"proxyHost";
NSString * REST_CONNECTION_CONFIGURATION_PROXYPORT_KEY = @"proxyPort";
NSString * REST_CONNECTION_CONFIGURATION_PROXYUSER_KEY = @"proxyUser";
NSString * REST_CONNECTION_CONFIGURATION_PROXYPASSWORD_KEY = @"proxyPassword";
NSString * REST_CONNECTION_CONFIGURATION_CURRENT_KEY = @"currentConfiguration";

@interface MFRestConnectionConfig()

/*!
 *Connection timeout
 */
@property (nonatomic, assign) NSInteger TIME_OUT;

/*!
 *Timeout for receiving data
 */
@property (nonatomic, assign) NSInteger SO_TIME_OUT;

/*!
 *default web port
 */
@property (nonatomic, assign) NSInteger DEFAULT_PORT;

/*!
 *Reason status
 */
@property (nonatomic, assign) NSDictionary *configuredValues;

/*!
 * The name of the current configuration
 */
@property (nonatomic, assign) NSString *currentConfiguration;

@end

@implementation MFRestConnectionConfig

-(void) initializeWithHost:(NSString *) host port:(NSInteger) port path:(NSString *) path wsEntryPoint:(NSString *) wsEntryPoint command:(NSString *)command user:(NSString *) user password:(NSString *) password proxyHost:(NSString *) proxyHost proxyPort:(NSInteger) proxyPort proxyUser: (NSString *) proxyUser proxyPassword:(NSString *) proxyPassword
{
    self.host = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_HOST_KEY] ? host : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_HOST_KEY]);
    self.port = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PORT_KEY] ? port : [[self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PORT_KEY] integerValue]);
    self.path = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PATH_KEY] ? path : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PATH_KEY]);
    self.wsEntryPoint = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_WSENTRYPOINT_KEY] ? wsEntryPoint : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_WSENTRYPOINT_KEY]);
    self.command = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_COMMAND_KEY] ? command : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_COMMAND_KEY]);
    self.user = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_USER_KEY] ? user : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_USER_KEY]);
    self.password = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PASSWORD_KEY] ? password : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PASSWORD_KEY]);
    self.proxyHost = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYHOST_KEY] ? proxyHost : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYHOST_KEY]);
    self.proxyPort = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYPORT_KEY] ? proxyPort : [[self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYPORT_KEY] integerValue]);
    self.proxyUser = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYUSER_KEY] ? proxyUser : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYUSER_KEY]);
    self.proxyPassword = (![self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYPASSWORD_KEY] ? proxyPassword : [self retrieveConfiguredValueForKey:REST_CONNECTION_CONFIGURATION_PROXYPASSWORD_KEY]);
}


-(id) init {
    self = [super init];
    if(self) {
        self.TIME_OUT = 50000;
        self.SO_TIME_OUT = 180000;
        self.DEFAULT_PORT = 80;
        self.port = self.DEFAULT_PORT;
        self.proxyPort = self.DEFAULT_PORT;
        self.timeout = self.TIME_OUT;
        self.soTimeout = self.SO_TIME_OUT;
        self.mockStatusCode = 200;
        
        MFConfigurationHandler *registry = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
        self.configuredValues = [registry getDictionaryProperty:REST_CONNECTION_CONFIGURATION_KEY];
    }
    return self;
}

-(BOOL) isProxyAuth
{
    return (self.proxyUser && self.proxyPassword);
}

-(NSString *)host {
    return _host;
}

-(id) retrieveConfiguredValueForKey:(NSString *)key {
    self.currentConfiguration = [self.configuredValues objectForKey:REST_CONNECTION_CONFIGURATION_CURRENT_KEY];
    if(!self.currentConfiguration) {
        [MFException throwExceptionWithName:@"Undefined value" andReason:@"The currentConfiguration attribute of RestConnectionConfiguration must be defined in Framework-configu.plist or programmatically." andUserInfo:nil];
    }
    return [[self.configuredValues objectForKey:key] objectForKey:self.currentConfiguration];
}

-(void)changeConfigurationWithName:(NSString*)configurationName {
    [self setCurrentConfiguration:configurationName];
    [self initializeWithHost:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_HOST_USERDEFAULTS_KEY]
                        port:[[MFApplication getInstance] intPreferenceWithKey:SYNCHRO_CONFIG_PORT_USERDEFAULTS_KEY]
                        path:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PATH_USERDEFAULTS_KEY]
                wsEntryPoint:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_WSENTRYPOINT_USERDEFAULTS_KEY]
                     command:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_COMMAND_USERDEFAULTS_KEY]
                        user:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_USER_USERDEFAULTS_KEY]
                    password:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PASSWORD_USERDEFAULTS_KEY]
                   proxyHost:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PROXYHOST_USERDEFAULTS_KEY]
                   proxyPort:[[MFApplication getInstance] intPreferenceWithKey:SYNCHRO_CONFIG_PROXYPORT_USERDEFAULTS_KEY]
                   proxyUser:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PROXYUSER_USERDEFAULTS_KEY]
               proxyPassword:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PROXYPASSWORD_USERDEFAULTS_KEY]];
}

@end
