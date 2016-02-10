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
//  MFApplication+CoreData.m
//  MFCore
//
//

#import "MFApplication+CoreData.h"

/**
 * @brief The key used to identify the specific Movalys persistent store
 */
NSString *MOVALYS_CORE_DATA_PERSISTENT_STORE_COORDINATOR_KEY = @"MOVALYS_CORE_DATA_PERSISTENT_STORE_COORDINATOR_KEY";

/**
 * @brief The key used to identify the specific Movalys managed object context
 */
NSString *MOVALYS_CORE_DATA_MANAGED_OBJECT_CONTEXT_KEY = @"MOVALYS_CORE_DATA_MANAGED_OBJECT_CONTEXT_KEY";


@implementation MFApplication (CoreData)

#pragma mark - Custom Methods

-(void) setMovalysStoreCoordinator:(NSPersistentStoreCoordinator *)storeCoordinator withAssociatedContext:(NSManagedObjectContext *)context {
    if(storeCoordinator && context) {
        self.movalysCoreDataContext = [NSDictionary dictionaryWithObjects:@[storeCoordinator, context] forKeys:@[MOVALYS_CORE_DATA_PERSISTENT_STORE_COORDINATOR_KEY, MOVALYS_CORE_DATA_MANAGED_OBJECT_CONTEXT_KEY]];
    }
}

-(NSPersistentStoreCoordinator *) movalysStoreCoordinator {
    return [self.movalysCoreDataContext objectForKey:MOVALYS_CORE_DATA_PERSISTENT_STORE_COORDINATOR_KEY];
}

-(NSManagedObjectContext *) movalysContext {
    return [self.movalysCoreDataContext objectForKey:MOVALYS_CORE_DATA_MANAGED_OBJECT_CONTEXT_KEY];
}

@end
