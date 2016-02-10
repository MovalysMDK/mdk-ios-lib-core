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
//  MFCoreDataHelper.h
//  MFCore
//
//

#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "MFCoreLog.h"
#import "MFCoreContext.h"

@interface MFCoreDataHelper : NSObject

@property(nonatomic,strong,readonly) NSMutableDictionary *entityIds ;
@property(nonatomic,strong,readonly) NSPersistentStore *sqliteStore;
/*@property(nonatomic,strong,readonly) NSPersistentStore *memoryStore;*/
@property(nonatomic, strong) NSError* lastSaveContextError;

/*!
 * @brief initialize singleton instance
 * @return singleton instance
 */
-(id)init ;

/*!
 * Return next id for entity
 * @param entity entity name
 * @return id
 */
-(NSNumber *) nextIdForEntity:(NSString *) entityName ;

/*!
 * Rollback the context
 * @param context context to rollback
 */
-(void) rollbackContext:(id<MFContextProtocol>) mfContext;

/*!
 * Save the context
 * @param context context to save
 * @return NSError if save technical failed
 */
-(NSError*) saveContext:(id<MFContextProtocol>) mfContext;

/*!
 * Register sqlite and memory stores
 * @param sqliteStore sqlite store
 * @param memoryStore memory store
 */
-(void) registerStore:(NSPersistentStore *)sqliteStore;

/*!
 * Log number of insert/deletion/update in coredata context
 * @param mfContext context
 * @param details details each entity inserted/deleted or updated
 */
- (void)logChanges:(id<MFContextProtocol>)mfContext withDetails:(BOOL)details;

@end
