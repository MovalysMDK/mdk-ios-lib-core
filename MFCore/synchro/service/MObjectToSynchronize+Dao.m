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
//  MFObjectToSynchronizeDao.m
//  MFCore
//
//

#import "MObjectToSynchronize+Dao.h"
#import "NSManagedObject+MFCommonDao.h"
#import "NSPredicate+MFPredicateHelper.h"
#import "NSManagedObject+MagicalFinders.h"

@implementation MObjectToSynchronize (Dao)

+ (MObjectToSynchronize *) MF_findByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext
{
    return [MObjectToSynchronize MF_findByIdentifier:identifier withFetchOptions:nil inContext:mfContext];
}


+ (MObjectToSynchronize *) MF_findByObjectType:(NSString *) objectType withIdentifier:(NSNumber *)identifier inContext:(MFContext *)mfContext
{
    NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectName equalsToValue:objectType];
    NSPredicate *p2 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectId equalsToValue:identifier];
    NSPredicate *findPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    
    NSFetchRequest *request = [MObjectToSynchronize MR_requestAllWithPredicate:findPredicate];
    return [MObjectToSynchronize MR_executeFetchRequestAndReturnFirstObject:request inContext:mfContext.entityContext];
}


+ (MObjectToSynchronize *) MF_findByIdentifier:(NSNumber *)identifier withFetchOptions:(MFFetchOptions *)fetchOptions
                        inContext:(MFContext *)mfContext
{
    NSFetchRequest *request = [MObjectToSynchronize MR_requestFirstByAttribute:MObjectToSynchronizeProperties.identifier
                                                        withValue:identifier inContext:mfContext.entityContext];
    [self MF_applyFetchOptions:fetchOptions onFetchRequest:request];
    return [MObjectToSynchronize MR_executeFetchRequestAndReturnFirstObject:request inContext:mfContext.entityContext];
}


+ (BOOL) MF_existByIdentifier:(NSNumber *)identifier inContext:(MFContext *)mfContext
{
    NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.identifier equalsToValue:identifier];
    return [self MR_countOfEntitiesWithPredicate:p1 inContext:mfContext.entityContext] > 0;
}


+ (NSArray *) MF_findIdsInContext:(id<MFContextProtocol>)mfContext
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:mfContext.entityContext];
    [request setPropertiesToFetch:@[MObjectToSynchronizeProperties.identifier]];
    [request setResultType:NSDictionaryResultType];
    NSArray *fetchedObjects = [self MR_executeFetchRequest:request inContext:mfContext.entityContext];
    NSMutableArray *ids = [NSMutableArray array];
    for (NSManagedObject *fetchedObject in fetchedObjects) {
        [ids addObject:[fetchedObject valueForKey:MObjectToSynchronizeProperties.identifier]];
    }
    return ids;
}


+ (void) MF_delete:(MObjectToSynchronize *)entity inContext:(MFContext *)mfContext
{
    [entity MR_deleteInContext:[mfContext entityContext]];
}


+ (void) MF_deleteByIdentifier:(NSNumber *)identifier inContext:(MFContext *)mfContext
{
    NSPredicate *deletePredicate = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.identifier equalsToValue:identifier];
    [self MR_deleteAllMatchingPredicate:deletePredicate inContext:[mfContext entityContext]];
}

+ (void) MF_deleteByObjectType:(NSString *) objectType withIdentifier:(NSNumber *)identifier inContext:(MFContext *)mfContext
{
    NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectName equalsToValue:objectType];
    NSPredicate *p2 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectId equalsToValue:identifier];
    NSPredicate *deletePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    
   [self MR_deleteAllMatchingPredicate:deletePredicate inContext:[mfContext entityContext]];
}

@end
