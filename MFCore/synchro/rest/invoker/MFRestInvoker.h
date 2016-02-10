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
//  MFRestInvoker.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFRestInvokerProtocol.h"
#import "MFConnectionTimeout.h"

/*!
 * @brief classe en charge d'envoyer les requêtes au serveur
 */
@interface MFRestInvoker :  NSObject<MFRestInvokerProtocol, TimeoutsCheckerDelegate>

#pragma mark - Variables
/*!
 * @brief An enumeration for the differents protocols that could be used
 * MFRestInvokerUrlProtocolHTTP for HTTP
 * MFRestInvokerUrlProtocolHTTPS for HTTPS
 */
typedef enum {
    MFRestInvokerUrlProtocolHTTP = 0,
    MFRestInvokerUrlProtocolHTTPS = 1
    
} MFRestInvokerUrlProtocol;

#pragma mark - Properties
/*!
 * @brief Indicates if it's the first pass
 */
@property (nonatomic) BOOL firstPass;


#pragma mark - Methods

/*!
 * @brief Returns a MFRestInvokerUrlProtocol value to indicate what is the protocol to use
 * @return a MFRestInvokerUrlProtocol value
 */
-(MFRestInvokerUrlProtocol) restInvokerUrlProtocol;

/*!
 * @brief Allows to configure the readstream before the invocation.
 * Here you can apply some configurations like giving a certificate
 * for SSL connections
 */
-(void) configureReadstreamBeforeInvocation:(CFReadStreamRef)readStream;
@end
