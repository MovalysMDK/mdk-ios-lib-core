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
//  NSManagedObject+MFCommonDao.h
//  MFCore
//
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

#import "MFCoreContext.h"

#import "MFFetchOptions.h"

@interface NSManagedObject (MFCommonDao)

/*!
 * @brief Return entity name
 * @return entity name
 **/
+(NSString *) MF_entityName ;

/*!
 * @brief Count of entities
 * @param mfContext context
 * @return count of entities
 */
+ (NSUInteger) MF_countInContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Count of entities with fetch options
 * @param fetchOptions fetchOptions
 * @param mfContext context
 */
+ (NSUInteger) MF_countWithFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Get all entities
 * @param mfContext context
 * @return array of all entities
 */
+ (NSArray *) MF_findAllInContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Get all entities
 * @param fetchOptions fetch options
 * @param mfContext context
 * @return array of all entities
 */
+ (NSArray *) MF_findAllWithFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief delete all entities of type entityName
 * @param inContext mfContext
 */
+(void) MF_deleteAllInContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief delete list of entities
 * @param listToDelete list to delete
 * @param inContext mfContext
 */
+(void) MF_deleteList:(NSArray *)listToDelete inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief apply fetch options to fetch request
 * @param fetchOptions fetch options
 * @param fetchRequest fetch request
 */
+(void) MF_applyFetchOptions:(MFFetchOptions *)fetchOptions onFetchRequest:(NSFetchRequest *) fetchRequest;

/*!
 * @brief apply fetch options to fetch request
 * @param fetchOptions fetch options
 * @param fetchRequest fetch request
 */
+(id) MF_aggregateFunction:(NSString *)function onAttribute:(NSString *)attributeName withFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief count distinct value for attribute
 * @param attributeName attribute name
 * @param fetchOptions fetch options
 * @param inContext context
 * @return count of distinct value
 */
+(NSUInteger) MF_countDistinctValueForAttribute:(NSString *)attributeName withFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext ;

/*!
 * @brief do a group by query
 * @param properties properties to group by on
 * @param withFunction function of group by
 * @param onProperty property used by function
 * @param fetchOptions fetch options
 * @param mfContext context
 * @return result of group by
 */
+(NSArray *) MF_groupBy:(NSArray *)properties withFunction:(NSString *)function onProperty:(NSString *)propertyName andFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief find all entities using a fetch controller
 * @param fetchOptions fetch options
 * @param mfContext context
 * @return fetch controller
 */
+ (NSFetchedResultsController *) MF_findAllWithFetchControllerAndFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext;

@end
