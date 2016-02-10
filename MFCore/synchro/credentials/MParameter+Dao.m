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
//  MParameter+Dao.m
//  MFCore
//
//

#import "MParameter+Dao.h"
#import "NSManagedObject+MFCommonDao.h"
#import "NSPredicate+MFPredicateHelper.h"

@implementation MParameter (Dao)

+ (MParameter *) MF_findByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext
{
    return [MParameter MF_findByIdentifier:identifier withFetchOptions:nil inContext:mfContext];
}


+ (MParameter *) MF_findByIdentifier:(NSNumber *)identifier withFetchOptions:(MFFetchOptions *)fetchOptions
                        inContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest *request = [MParameter MR_requestFirstByAttribute:MParameterProperties.identifier
                                                        withValue:identifier inContext:mfContext.entityContext];
    [self MF_applyFetchOptions:fetchOptions onFetchRequest:request];
    return [MParameter MR_executeFetchRequestAndReturnFirstObject:request inContext:mfContext.entityContext];
}


+ (BOOL) MF_existByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext
{
    NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:MParameterProperties.identifier equalsToValue:identifier];
    return [self MR_countOfEntitiesWithPredicate:p1 inContext:mfContext.entityContext] > 0;
}


+ (MParameter *) MF_findByName:(NSString *)name inContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest *request = [MParameter MR_requestFirstByAttribute:MParameterProperties.name
                                                           withValue:name inContext:mfContext.entityContext];
    [self MF_applyFetchOptions:nil onFetchRequest:request];
    return [MParameter MR_executeFetchRequestAndReturnFirstObject:request inContext:mfContext.entityContext];
}


+ (NSArray *) MF_findByNameLike:(NSString *)name inContext:(id<MFContextProtocol>)mfContext
{
    NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:MParameterProperties.name valueContains:name];
    NSFetchRequest *request = [self MR_createFetchRequestInContext:mfContext.entityContext];
    [request setPredicate:p1];
    return [self MR_executeFetchRequest:request inContext:mfContext.entityContext];
}


+ (NSArray *) MF_findIdsInContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:mfContext.entityContext];
    [request setPropertiesToFetch:@[MParameterProperties.identifier]];
    [request setResultType:NSDictionaryResultType];
    NSArray *fetchedObjects = [self MR_executeFetchRequest:request inContext:mfContext.entityContext];
    NSMutableArray *ids = [NSMutableArray array];
    for (NSManagedObject *fetchedObject in fetchedObjects) {
        [ids addObject:[fetchedObject valueForKey:MParameterProperties.identifier]];
    }
    return ids;
}


+ (void) MF_delete:(MParameter *)entity inContext:(id<MFContextProtocol>)mfContext
{
    [entity MR_deleteInContext:[mfContext entityContext]];
}


+ (void) MF_deleteByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext
{
    NSPredicate *deletePredicate = [NSPredicate MF_createPredicateWithProperty:MParameterProperties.identifier equalsToValue:identifier];
    [self MR_deleteAllMatchingPredicate:deletePredicate inContext:[mfContext entityContext]];
}


+ (void) MF_deleteByName:(NSString *)name inContext:(id<MFContextProtocol>)mfContext
{
    NSPredicate *deletePredicate = [NSPredicate MF_createPredicateWithProperty:MParameterProperties.name equalsToValue:name];
    [self MR_deleteAllMatchingPredicate:deletePredicate inContext:[mfContext entityContext]];
}

@end
