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
#import "MFSyncRestResponseProtocol.h"
#import "MFActionProtocol.h"

@class MFSynchronisationResponseTreatmentInformation;
@class MFSynchronizationActionParameterIN;
@class MFSynchronizationActionParameterOUT;
@class MFRestConnectionConfig;
@class MFRestInvoker;
@class MFRestInvocationConfig;


/*!
 * @protocol MFSynchronizationActionProtocol
 * @brief The default protocol to define synchronization actions
 */
@protocol MFSynchronizationActionProtocol

/*!
 * @brief Returns the invocation to invoke during the synchronization
 */
- (NSArray *) getInvocationConfigs:(NSDictionary *) objectsToSynchronize;

@end


/*!
 * @class MFSynchronizationAction
 * @brief The base default synchronization action
 * @discussion It contains the base code to execute an action of synchronization.
 */
@interface MFSynchronizationAction : NSObject<MFActionProtocol>

/*!
 * @brief The class that will get the response
 */
@property (nonatomic, retain) Class ResponseClass;

/*!
 * @brief an object that describes the response treatment informations
 */
@property (nonatomic, retain) MFSynchronisationResponseTreatmentInformation *information;

/*!
 * @brief the command to execute to synchronize
 */
@property (nonatomic, retain) NSString *command;

@end
