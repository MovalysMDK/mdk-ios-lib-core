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

#import "MFContextProtocol.h"

@protocol MFContextFactoryProtocol<NSObject>

/*!
 * @brief Initialize helper
 */
-(id)init ;

/*!
 * @brief Create a MFContext instance
 */
-(id<MFContextProtocol>) createMFContext ;

/*!
 * @brief Create a MFContext instance
 * @param entityContext core data context
 * @return MFContext
 */
-(id<MFContextProtocol>) createMFContextWithCoreDataContext:(NSManagedObjectContext *) entityContext ;

/*!
 * @brief Create a MFContext instance using context for current thread
 * @return MFContext
 */
-(id<MFContextProtocol>) createMFContextWithCoreDataContextForCurrentThread ;

/*!
 * @brief Create a MFContext instance using a new child coredata context (parent context is the default context)
 * @return MFContext
 */
-(id<MFContextProtocol>) createMFContextWithChildCoreDataContext;

/*!
 * @brief Create a MFContext instance using a new child coredata context whose parent is passed in parameter
 * @return MFContext
 */
-(id<MFContextProtocol>) createMFContextWithChildCoreDataContextWithParent:(NSManagedObjectContext *)parentContext;

/*!
 * @brief Create a MFContext instance using default coredata context
 * @return MFContext
 */
-(id<MFContextProtocol>) createMFContextWithDefaultCoreDataContext ;

@end
