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


#import <Foundation/Foundation.h>
#import "MParameter.h"
#import "MFContextProtocol.h"
#import "MFFetchOptions.h"

@interface MParameter (Dao)
/*!
 * @brief Get MParameter by identifier
 * @param identifier
 * @return MParameter
 */
+ (MParameter *) MF_findByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;


/*!
 * @brief Get MParameter by identifier
 * @param identifier identifier
 * @param fetchOptions fetchOptions
 * @return MParameter
 */
+ (MParameter *) MF_findByIdentifier:(NSNumber *)identifier withFetchOptions:(MFFetchOptions *)fetchOptions
                        inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Exist MParameter by identifier
 * @param identifier
 * @return true if MParameter exists
 */
+ (BOOL) MF_existByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Get MParameter by name
 * @param name
 * @return MParameter
 */
+ (MParameter *) MF_findByName:(NSString *)name inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Get MParameter with name like parameter
 * @param name
 * @return MParameter
 */
+ (NSArray *) MF_findByNameLike:(NSString *)name inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Get all ids of MParameter
 * @return array of all ids of MParameter
 */
+ (NSArray *) MF_findIdsInContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Delete a MParameter
 * @param entity MParameter to delete
 * @param inContext context
 */
+ (void) MF_delete:(MParameter *)entity inContext:(id<MFContextProtocol>)mfContext;

/*!
 * @brief Delete MParameter by identifier
 * @param identifier identifier of entity to delete
 */
+ (void) MF_deleteByIdentifier:(NSNumber *)identifier inContext:(id<MFContextProtocol>)mfContext;

/*! delete by MParameter name property */
+ (void) MF_deleteByName:(NSString *)name inContext:(id<MFContextProtocol>)mfContext;

@end
