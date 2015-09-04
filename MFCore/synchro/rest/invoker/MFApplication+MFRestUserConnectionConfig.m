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


#import "MFApplication+MFRestUserConnectionConfig.h"

NSString *const SYNCHRO_CONFIG_HOST_USERDEFAULTS_KEY = @"synchro_config_host_userdefaults_key";
NSString *const SYNCHRO_CONFIG_PORT_USERDEFAULTS_KEY = @"synchro_config_port_userdefaults_key";
NSString *const SYNCHRO_CONFIG_PATH_USERDEFAULTS_KEY = @"synchro_config_path_userdefaults_key";
NSString *const SYNCHRO_CONFIG_WSENTRYPOINT_USERDEFAULTS_KEY = @"synchro_config_wsEntryPoint_userdefaults_key";
NSString *const SYNCHRO_CONFIG_COMMAND_USERDEFAULTS_KEY = @"synchro_config_command_userdefaults_key";
NSString *const SYNCHRO_CONFIG_USER_USERDEFAULTS_KEY = @"synchro_config_user_userdefaults_key";
NSString *const SYNCHRO_CONFIG_PASSWORD_USERDEFAULTS_KEY = @"synchro_config_password_userdefaults_key";
NSString *const SYNCHRO_CONFIG_PROXYHOST_USERDEFAULTS_KEY = @"synchro_config_proxyHost_userdefaults_key";
NSString *const SYNCHRO_CONFIG_PROXYPORT_USERDEFAULTS_KEY = @"synchro_config_proxyPort_userdefaults_key";
NSString *const SYNCHRO_CONFIG_PROXYUSER_USERDEFAULTS_KEY = @"synchro_config_proxyUser_userdefaults_key";
NSString *const SYNCHRO_CONFIG_PROXYPASSWORD_USERDEFAULTS_KEY = @"synchro_config_proxyPassword_userdefaults_key";
NSString *const SYNCHRO_CONFIG_TIMEOUT_USERDEFAULTS_KEY = @"synchro_config_timeout_userdefaults_key";
NSString *const SYNCHRO_CONFIG_SOTIMEOUT_USERDEFAULTS_KEY = @"synchro_config_soTimeout_userdefaults_key";
NSString *const SYNCHRO_CONFIG_DEFAULTPORT_USERDEFAULTS_KEY = @"synchro_config_defaultPort_userdefaults_key";
NSString *const SYNCHRO_CONFIG_MOCKSTATUSCODE_USERDEFAULTS_KEY = @"synchro_config_mockStatusCode_userdefaults_key";


@implementation MFApplication (MFRestUserConnectionConfig)

#pragma mark - Methods

+(void) setSynchroHostConfig:(NSString *)host {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_HOST_USERDEFAULTS_KEY andValue:host];
}

+(void) setSynchroPathConfig:(NSString *)path {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_PATH_USERDEFAULTS_KEY andValue:path];
}

+(void) setSynchroWsEntryPointConfig:(NSString *)wsEntryPoint {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_WSENTRYPOINT_USERDEFAULTS_KEY andValue:wsEntryPoint];
}

+(void) setSynchroCommandConfig:(NSString *)command {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_COMMAND_USERDEFAULTS_KEY andValue:command];
}

+(void) setSynchroUserConfig:(NSString *)user {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_USER_USERDEFAULTS_KEY andValue:user];
}

+(void) setSynchroPasswordConfig:(NSString *)password {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_PASSWORD_USERDEFAULTS_KEY andValue:password];
}

+(void) setSynchroProxyHostConfig:(NSString *)proxyHost {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_PROXYHOST_USERDEFAULTS_KEY andValue:proxyHost];
}

+(void) setSynchroProxyUserConfig:(NSString *)proxyUser {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_PROXYUSER_USERDEFAULTS_KEY andValue:proxyUser];
}

+(void) setSynchroProxyPasswordConfig:(NSString *)proxyPassword {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_PROXYPASSWORD_USERDEFAULTS_KEY andValue:proxyPassword];
}

+(void) setSynchroPortConfig:(NSInteger)port {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_PORT_USERDEFAULTS_KEY andIntValue:port];
}

+(void) setSynchroProxyPortConfig:(NSInteger)proxyPort {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_PROXYPORT_USERDEFAULTS_KEY andIntValue:proxyPort];
}

+(void) setSynchroTimeOutConfig:(NSInteger)timeOut {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_TIMEOUT_USERDEFAULTS_KEY andIntValue:timeOut];
}

+(void) setSynchroSoTimeOutConfig:(NSInteger)soTimeOut {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_SOTIMEOUT_USERDEFAULTS_KEY andIntValue:soTimeOut];
}

+(void) setSynchroDefaultPortConfig:(NSInteger)defaultPort {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_DEFAULTPORT_USERDEFAULTS_KEY andIntValue:defaultPort];
}

+(void) setSynchroMockStatusCodeConfig:(NSInteger)mockStatusCode {
    [[MFApplication getInstance] setPreferenceWithKey:SYNCHRO_CONFIG_MOCKSTATUSCODE_USERDEFAULTS_KEY andIntValue:mockStatusCode];
}


@end
