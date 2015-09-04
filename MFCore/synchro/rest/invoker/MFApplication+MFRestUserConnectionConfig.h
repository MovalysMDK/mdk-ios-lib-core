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


#import "MFApplication.h"


FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_HOST_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_PORT_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_PATH_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_WSENTRYPOINT_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_COMMAND_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_USER_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_PASSWORD_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_PROXYHOST_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_PROXYPORT_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_PROXYUSER_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_PROXYPASSWORD_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_TIMEOUT_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_SOTIMEOUT_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_DEFAULTPORT_USERDEFAULTS_KEY;
FOUNDATION_EXPORT NSString * const SYNCHRO_CONFIG_MOCKSTATUSCODE_USERDEFAULTS_KEY;


@interface MFApplication (MFRestUserConnectionConfig)


#pragma mark - Methods

/*!
 * @brief Set the host value to use for server synchronization
 * @param host The host value
 */
+(void) setSynchroHostConfig:(NSString *)host;

/*!
 * @brief Set the path value to use for server synchronization
 * @param path The path value
 */
+(void) setSynchroPathConfig:(NSString *)path;

/*!
 * @brief Set the webservice entry point value to use for server synchronization
 * @param wsEntryPoint The webservice entry point value
 */
+(void) setSynchroWsEntryPointConfig:(NSString *)wsEntryPoint;

/*!
 * @brief Set the command value to use for server synchronization
 * @param command The command value
 */
+(void) setSynchroCommandConfig:(NSString *)command;

/*!
 * @brief Set the user (login) value to use for server synchronization
 * @param user The user (login) value
 */
+(void) setSynchroUserConfig:(NSString *)user;

/*!
 * @brief Set the password value to use for server synchronization
 * @param password The password value
 */
+(void) setSynchroPasswordConfig:(NSString *)password;

/*!
 * @brief Set the proxy host value to use for server synchronization
 * @param proxyHost The proxy host value
 */
+(void) setSynchroProxyHostConfig:(NSString *)proxyHost;

/*!
 * @brief Set the proxy user (login) value to use for server synchronization
 * @param proxyUser The proxy user (login) value
 */
+(void) setSynchroProxyUserConfig:(NSString *)proxyUser;

/*!
 * @brief Set the proxy password value to use for server synchronization
 * @param proxyPassword The proxy password value
 */
+(void) setSynchroProxyPasswordConfig:(NSString *)proxyPassword;

/*!
 * @brief Set the port value to use for server synchronization
 * @param port The port value
 */
+(void) setSynchroPortConfig:(NSInteger)port;

/*!
 * @brief Set the proxy port value to use for server synchronization
 * @param proxyPort The proxy port value
 */
+(void) setSynchroProxyPortConfig:(NSInteger)proxyPort;

/*!
 * @brief Set the time-out value (response time-out in milliseconds) to use for server synchronization
 * @param timeOut The time-out value
 */
+(void) setSynchroTimeOutConfig:(NSInteger)timeOut;

/*!
 * @brief Set the time-out value (socket connection time-out in milliseconds) to use for server synchronization
 * @param soTimeOut The time-out value
 */
+(void) setSynchroSoTimeOutConfig:(NSInteger)soTimeOut;

/*!
 * @brief Set the default port to use for server synchronization
 * @param defaultPort The default port value
 */
+(void) setSynchroDefaultPortConfig:(NSInteger)defaultPort;

/*!
 * @brief Set the mock status code to use for server synchronization
 * @param mockStatusCode The mock status code port value
 */
+(void) setSynchroMockStatusCodeConfig:(NSInteger)mockStatusCode;


@end
