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
//  MFObjectToSynchronizeDao.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MObjectToSynchronize.h"
#import "MFContextProtocol.h"
#import "MFFetchOptions.h"

@interface MObjectToSynchronize (Dao)
/*!
 * @brief Get MFObjectToSynchronize by identifier
 * @param identifier
 * @return MFObjectToSynchronize
 */
+ (MObjectToSynchronize *) MF_findByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;


/*!
 * @brief Get MFObjectToSynchronize by type and identifier
 * @param type type
 * @param identifier identifier
 * @return MFObjectToSynchronize
 */
+ (MObjectToSynchronize *) MF_findByObjectType:(NSString *) objectType withIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Get MFObjectToSynchronize by identifier
 * @param identifier identifier
 * @param fetchOptions fetchOptions
 * @return MFObjectToSynchronize
 */
+ (MObjectToSynchronize *) MF_findByIdentifier:(NSNumber *)identifier withFetchOptions:(MFFetchOptions *)fetchOptions
                        inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Exist MFObjectToSynchronize by identifier
 * @param identifier
 * @return true if MFObjectToSynchronize exists
 */
+ (BOOL) MF_existByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Get all ids of MFObjectToSynchronize
 * @return array of all ids of MFObjectToSynchronize
 */
+ (NSArray *) MF_findIdsInContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Delete a MFObjectToSynchronize
 * @param entity MFObjectToSynchronize to delete
 * @param inContext context
 */
+ (void) MF_delete:(MObjectToSynchronize *)entity inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Delete MFObjectToSynchronize by identifier
 * @param identifier identifier of entity to delete
 */
+ (void) MF_deleteByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Delete MFObjectToSynchronize by identifier and type
 * @param type type of entity to delete
 * @param identifier identifier of entity to delete
 */
+ (void) MF_deleteByObjectType:(NSString *) objectType withIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;


@end
