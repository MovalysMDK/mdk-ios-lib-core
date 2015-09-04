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


#import "MFObjectToSyncService.h"
#import "MObjectToSynchronize.h"
#import "NSManagedObject+MFCommonDao.h"
#import "NSPredicate+MFPredicateHelper.h"

@implementation MFObjectToSyncService

-(NSDictionary *) getObjectsToSyncWithContext:(id<MFContextProtocol>) context
{
    NSMutableDictionary *dictObjectsToSync = [[NSMutableDictionary alloc] init];
    
    NSArray *arrayObjectsToSync = [MObjectToSynchronize MF_findAllInContext:context];
    
    for (MObjectToSynchronize *objToSync in arrayObjectsToSync) {
        NSMutableArray *arraySyncObjects = [dictObjectsToSync objectForKey:[objToSync objectName]];
        
        if (!arraySyncObjects) {
            arraySyncObjects = [[NSMutableArray alloc] init];
            [dictObjectsToSync setObject:arraySyncObjects forKey:[objToSync objectName]];
        }
        
        [arraySyncObjects addObject:objToSync];
    }
    
    return dictObjectsToSync;
}

-(BOOL) isSynchronizedObject:(NSString *) objectType withIdentifier:(NSNumber *) identifier withContext:(id<MFContextProtocol>) context
{
    NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectName equalsToValue:objectType];
    NSPredicate *p2 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectId equalsToValue:identifier];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    return [MObjectToSynchronize MR_countOfEntitiesWithPredicate:predicate inContext:context.entityContext] > 0;
}

-(void) deleteObjectToSynchronize:(NSArray *) objects withContext:(id<MFContextProtocol>) context
{
    [MObjectToSynchronize MF_deleteList:objects inContext:context];
}

-(void) deleteObjectToSynchronizeByType:(NSString *) objectType andIdentifier:(NSNumber *) identifier withContext:(id<MFContextProtocol>) context
{
    NSPredicate *p1 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectName equalsToValue:objectType];
    NSPredicate *p2 = [NSPredicate MF_createPredicateWithProperty:MObjectToSynchronizeProperties.objectId equalsToValue:identifier];
    NSPredicate *deletePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
    [MObjectToSynchronize MR_deleteAllMatchingPredicate:deletePredicate inContext:[context entityContext]];
}

@end
