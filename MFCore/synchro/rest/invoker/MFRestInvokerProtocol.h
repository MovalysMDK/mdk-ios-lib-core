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
#import "MFActionProtocol.h"
#import "MFContext.h"

@class MFRestInvocationConfig;
@class MFRestResponse;
@class MFRestConnectionConfig;
@protocol MFSyncRestResponseProtocol;

/*!
 * @protocol MFRestInvokerProtocol
 * @brief A protocol that describes a Rest Invoker object that should be used for synchronization actions
 */
@protocol MFRestInvokerProtocol <NSObject>;

#pragma mark - Properties

/*!
 * @brief The response class of the synchronization
 */
@property (nonatomic, retain) Class ResponseClass;

/*!
 * @brief The protocol to use in URL
 */
@property (nonatomic, retain) NSString *urlProtocol;

/*!
 * @brief The GET parameters of the URL
 */
@property (nonatomic, retain) NSMutableArray *getParameters;

/*!
 * @brief The synchronization action object that use this Rest Invoker
 */
@property (nonatomic, retain) NSObject<MFActionProtocol> *actionSynchro;

/*!
 * @brief The Rest Connection Configuration object that is used for this synchronization action
 * @see MFRestConnectionConfig
 */
@property (nonatomic, retain) MFRestConnectionConfig *connectionConfig;

/*!
 * @brief The Rest Invocation Configuration object that is used for this synchronization action
 * @see MFRestInvocationConfig
 */
@property (nonatomic, retain) MFRestInvocationConfig *invocationConfig;


#pragma mark - Methods

/*!
 * @brief Initializes the REST Invoket given some parameters
 * @param responseClass The response class of this Rest Invoker
 * @param actionSynchro The synchronization action that uses this Rest Invoker
 * @param connectionConfig The Rest Connection configuration object
 * @param invocations The Rest Invocaitions configuration object
 */
-(void) initializeWithResponseClass:(Class <MFSyncRestResponseProtocol>) responseClass withActionSynchro:(id<MFActionProtocol>) actionSynchro withConnectionConfig:(MFRestConnectionConfig *)connectionConfig withInvocations:(MFRestInvocationConfig *)invocations;

/*!
 * @brief Prepares the request to send to the server.
 */
-(void) prepare;

/*!
 * @brief Initializes a RestInvoker given a context
 * @param context A MDK context
 */
-(void) initializeWithContext:(MFContext *)context;

/*!
 * @brief Send the request to the server and treats the response
 * @param dispatch A dispatcher used to dispatch the progression of the action
 * @param context The context aof the synchronization action
 * @return A kind-of MFSyncRestResponseProtocol Class that will be used to treat the response.
 */
-(Class <MFSyncRestResponseProtocol>)processWithDispatcher:(MFActionProgressMessageDispatcher*)dispatcher withContext:(MFContext *)context;

@end
