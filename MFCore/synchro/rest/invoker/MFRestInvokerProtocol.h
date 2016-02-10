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
//  FRestInvokerProtocol.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFSyncRestResponseProtocol.h"
#import "MFActionProtocol.h"
#import "MFContext.h"

@class MFRestInvocationConfig;
@class MFRestResponse;
@class MFRestConnectionConfig;

@protocol MFRestInvokerProtocol <NSObject>

@property (nonatomic, retain) Class ResponseClass;
@property (nonatomic, retain) NSString *urlProtocol;
@property (nonatomic, retain) NSMutableArray *getParameters;
@property (nonatomic, retain) NSObject<MFActionProtocol> *actionSynchro;
@property (nonatomic, retain) MFRestConnectionConfig *connectionConfig;
@property (nonatomic, retain) MFRestInvocationConfig *invocationConfig;


-(void) initializeWithResponseClass:(Class <MFSyncRestResponseProtocol>) responseClass withActionSynchro:(id<MFActionProtocol>) actionSynchro withConnectionConfig:(MFRestConnectionConfig *) connectionConfig withInvocations:(MFRestInvocationConfig *) invocations;

/*!
 * @brief prépare la requête à envoyer au serveur
 */
-(void) prepare;

-(void) initializeWithContext:(MFContext *) context;

/*!
 * @brief envoie la requête au serveur et traite la réponse reçue
 */
-(Class <MFSyncRestResponseProtocol>) processWithDispatcher:(MFActionProgressMessageDispatcher*) dispatcher withContext:(MFContext *) context;

@end
