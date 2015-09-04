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

#import "MFCoreApplication.h"

/**
 * @class MFApplication+CoreData
 * @brief This category on MFApplication allows to store and retrieve the specifics store coordinator and
 * core data context for the Movalys Managed Objec Model.
 */
@interface MFApplication (CoreData)

#pragma mark - Methods
/**
 * @brief Sets the movalys store coordinator associated to its context
 * @param The movalys store coordinator
 * @param The core data context associated to the store coordinator
 */
-(void) setMovalysStoreCoordinator:(NSPersistentStoreCoordinator *)storeCoordinator withAssociatedContext:(NSManagedObjectContext *)context;

/**
 * @brief Retrieves the movalys store coordinator.
 * @return The movalys store coordinator
 */
-(NSPersistentStoreCoordinator *) movalysStoreCoordinator;

/**
 * @brief Retrieves the movalys core data context
 * @return The movalys core data context
 */
-(NSManagedObjectContext *) movalysContext;

@end
