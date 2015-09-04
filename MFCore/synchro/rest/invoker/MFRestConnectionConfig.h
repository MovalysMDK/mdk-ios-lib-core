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


#import <Foundation/Foundation.h>

/*!
 * @class MFRestConnectionConfig
 * @brief Class of configuration for the Rest connection
 * @discussion This class allows to customize the configuration for the rest connection. 
 * This class works with de RestConnectionConfiguration dictionary attribute of the Framework-config.plist file.
 */
@interface MFRestConnectionConfig : NSObject

#pragma mark - Properties

/*!
 *Mock mode
 */
@property (nonatomic, assign) BOOL mockMode;

/*!
 *Reason status
 */
@property (nonatomic, assign) NSInteger mockStatusCode;

/*!
 *Host
 */
@property (nonatomic, retain) NSString *host;

/*!
 *Port
 */
@property (nonatomic, assign) NSInteger port;

/*!
 *Path
 */
@property (nonatomic, retain) NSString *path;

/*!
 *Entry point for web service
 */
@property (nonatomic, retain) NSString *wsEntryPoint;

/*!
 *command
 */
@property (nonatomic, retain) NSString *command;

/*!
 *the user to use for synchronise
 */
@property (nonatomic, retain) NSString *user;

/*!
 *the password to use for synchronise
 */
@property (nonatomic, retain) NSString *password;

/*!
 *proxy url
 */
@property (nonatomic, retain) NSString *proxyHost;

/*!
 *proxy port
 */
@property (nonatomic, assign) NSInteger proxyPort;

/*!
 *the user to use for proxy
 */
@property (nonatomic, retain) NSString *proxyUser;

/*!
 *the password to use for proxy
 */
@property (nonatomic, retain) NSString *proxyPassword;

/*!
 *Timeout
 */
@property (nonatomic, assign) NSInteger timeout;

/*!
 *Socket timeout
 */
@property (nonatomic, assign) NSInteger soTimeout;


#pragma mark - Methods

/*!
 *
 */
-(void) initializeWithHost:(NSString *) host port:(NSInteger) port path:(NSString *) path wsEntryPoint:(NSString *) wsEntryPoint command:(NSString *)command user:(NSString *) user password:(NSString *) password proxyHost:(NSString *) proxyHost proxyPort:(NSInteger) proxyPort proxyUser: (NSString *) proxyUser proxyPassword:(NSString *) proxyPassword;

/*!
 *
 */
-(BOOL) isProxyAuth;

/*!
 * @brief Change the current configuration of the REST connection
 * @param The name of the configuration to use. This name allows to configured value for Rest Connection
 * from the Framework-config.plist file.
 */
-(void)changeConfigurationWithName:(NSString*)configurationName;


@end
