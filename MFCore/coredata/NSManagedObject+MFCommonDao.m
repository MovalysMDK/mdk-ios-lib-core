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
//  NSManagedObject+MFCommonDao.m
//  MFCore
//
//

#import "NSManagedObject+MFCommonDao.h"
#import "NSPredicate+MFPredicateHelper.h"
#import "MFFetchOptions.h"

//#import "MFApplication.h"
#import "MFCoreDataHelper.h"

@implementation NSManagedObject (MFCommonDao)

+(NSString *) MF_entityName
{
    return NSStringFromClass(self);
}

+ (NSArray *) MF_findAllInContext:(id<MFContextProtocol>)mfContext
{
    return [self MF_findAllWithFetchOptions:nil inContext:mfContext];
}

+ (NSArray *) MF_findAllWithFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest *request = [self MR_requestAllInContext:mfContext.entityContext];
    if (fetchOptions != nil) {
        [self MF_applyFetchOptions:fetchOptions onFetchRequest:request];
    }
    return [self MR_executeFetchRequest:request inContext:mfContext.entityContext];
}

+ (NSUInteger) MF_countInContext:(id<MFContextProtocol>)mfContext
{
    return [self MR_countOfEntitiesWithContext:mfContext.entityContext];
}

+ (NSUInteger) MF_countWithFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext
{
    return [self MR_countOfEntitiesWithPredicate:fetchOptions.predicate inContext:mfContext.entityContext];
}

+(void) MF_deleteAllInContext:(id<MFContextProtocol>)mfContext
{
    NSManagedObjectContext *context = [mfContext entityContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *entityName = [self MF_entityName];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSArray *allEntities = [self MF_executeFetchRequest:fetchRequest inContext:mfContext];
    
    for (NSManagedObject *entity in allEntities) {
        [context deleteObject:entity];
    }
}

+(void) MF_deleteList:(NSArray *)listToDelete inContext:(id<MFContextProtocol>)mfContext
{
    for(id entity in listToDelete )
    {
    	[entity MR_deleteInContext: [mfContext entityContext]];
    }
}

+(void) MF_applyFetchOptions:(MFFetchOptions *)fetchOptions onFetchRequest:(NSFetchRequest *) fetchRequest
{
    if ( fetchOptions.fetchLimit != nil)
    {
        [fetchRequest setFetchLimit: [fetchOptions.fetchLimit intValue]];
    }
    if ( fetchOptions.fetchOffset != nil)
    {
        [fetchRequest setFetchOffset: [fetchOptions.fetchOffset intValue]];
    }
    if ( [fetchOptions.sortDescriptors count] > 0 )
    {
        [fetchRequest setSortDescriptors: fetchOptions.sortDescriptors];
    }
    if ( fetchOptions.predicate != nil )
    {
        if ( fetchRequest.predicate != nil ) {
            [fetchRequest setPredicate: [NSCompoundPredicate andPredicateWithSubpredicates:@[fetchOptions.predicate, fetchRequest.predicate]]];
        }
        else {
            [fetchRequest setPredicate:fetchOptions.predicate];
        }
    }
}

+(id) MF_aggregateFunction:(NSString *)function onAttribute:(NSString *)attributeName withFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext
{
    NSExpression *ex = [NSExpression expressionForFunction:function
        arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:attributeName]]];
        
    NSExpressionDescription *ed = [[NSExpressionDescription alloc] init];
    [ed setName:@"result"];
    [ed setExpression:ex];
        
    NSAttributeDescription *attributeDescription = [[[self MR_entityDescription] attributesByName] objectForKey:attributeName];
    if ( [function isEqualToString:MFQUERY_FUNCTION_CNT] ) {
        [ed setExpressionResultType:NSDecimalAttributeType];
    }
    else {
        [ed setExpressionResultType:[attributeDescription attributeType]];
    }
    NSArray *properties = [NSArray arrayWithObject:ed];
        
    NSFetchRequest *request = [self MR_requestAllWithPredicate:fetchOptions.predicate inContext:mfContext.entityContext];
    [request setPropertiesToFetch:properties];
    [request setResultType:NSDictionaryResultType];
        
    NSDictionary *resultsDictionary = [self MR_executeFetchRequestAndReturnFirstObject:request inContext:mfContext.entityContext];
    return [resultsDictionary objectForKey:@"result"];
}


+(NSUInteger) MF_countDistinctValueForAttribute:(NSString *)attributeName withFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName: [self MF_entityName]];
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = @[attributeName];
    fetchRequest.returnsDistinctResults = YES;
    fetchRequest.predicate = fetchOptions.predicate;
    NSArray *dictionaries = [self MR_executeFetchRequest:fetchRequest inContext:mfContext.entityContext];
    return [dictionaries count];
}

+(NSArray *) MF_groupBy:(NSArray *)properties withFunction:(NSString *)function onProperty:(NSString *)propertyName andFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest* fetch = [NSFetchRequest fetchRequestWithEntityName: [self MF_entityName]];
    NSEntityDescription* entity = [NSEntityDescription entityForName:[self MF_entityName]
                                              inManagedObjectContext:mfContext.entityContext];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: propertyName];
    NSExpression *countExpression = [NSExpression expressionForFunction: function
                                                              arguments: [NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: @"result"];
    [expressionDescription setExpression: countExpression];
    [expressionDescription setExpressionResultType: NSInteger32AttributeType];

    NSMutableArray *propertiesToFetch = [[NSMutableArray alloc] init];
    NSMutableArray *propertiesToGroupBy = [[NSMutableArray alloc] init];
    for( NSString *prop in properties) {
        NSAttributeDescription* statusDesc = [entity.attributesByName objectForKey:prop];
        [propertiesToFetch addObject:statusDesc];
        [propertiesToGroupBy addObject:statusDesc];
    }
    [propertiesToFetch addObject:expressionDescription];
    
    [fetch setPropertiesToFetch: propertiesToFetch ];
    [fetch setPropertiesToGroupBy: propertiesToGroupBy];
    [fetch setResultType:NSDictionaryResultType];
    [fetch setPredicate: fetchOptions.predicate];
    return [self MR_executeFetchRequest:fetch inContext:mfContext.entityContext];
}

+(NSArray *) MF_executeFetchRequest:(NSFetchRequest *)fetchRequest inContext:(id<MFContextProtocol>)mfContext
{
    NSManagedObjectContext *context = [mfContext entityContext];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if ( result == nil)
    {
        [NSException raise:@"Fetch request failed" format:@"error: %@", error];
    }
    return result;
}

+ (NSFetchedResultsController *) MF_findAllWithFetchControllerAndFetchOptions:(MFFetchOptions *)fetchOptions inContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest *fetchRequest = [self MR_requestAllInContext:mfContext.entityContext];
    [self MF_applyFetchOptions:fetchOptions onFetchRequest:fetchRequest];
    [NSFetchedResultsController deleteCacheWithName:[fetchOptions cacheName]];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                                initWithFetchRequest:fetchRequest
                                              managedObjectContext:mfContext.entityContext
                                              sectionNameKeyPath:nil
                                              cacheName: [fetchOptions cacheName]];
    NSError *error;
    BOOL success = [controller performFetch:&error];
    if ( success == NO)
    {
        [NSException raise:@"Fetch request failed" format:@"error: %@", error];
    }
    return controller;
}

@end
