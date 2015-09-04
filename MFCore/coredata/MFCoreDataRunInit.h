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

#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "MFCoreLog.h"
#import "MFCoreInit.h"

//#import "MFRunInitProtocol.h"

/*!
 * @brief Initialisation of coredata
 * @details CoreData is initialized in this RunInit. Counters of identifiers are initialized there too.
 */
@interface MFCoreDataRunInit : NSObject<MFRunInitProtocol>

#pragma mark - Methods

/*!
 * @brief Setups the persistent store as a Database named with the given parameter
 * @param dbName The name of the SQLITE file that represents the Database
 * @param modelName The name of the Movalys model.
 */
+(void) setupPersistentStoreForMovalysWithDbName:(NSString *)dbName andMovalysDefaultModelName:(NSString *)movalysDefaultModelName withModel:(NSManagedObjectModel *)model;
@end
