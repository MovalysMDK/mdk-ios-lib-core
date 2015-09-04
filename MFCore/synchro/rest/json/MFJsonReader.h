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
#import "MFJsonObject.h"

/*!
 * @class MFJsonReader
 * @brief The JSON Reader used by Synchronization actions
 */
@interface MFJsonReader : NSObject

#pragma mark - Properties

/*!
 * @brief The Json object to read
 */
@property (nonatomic, retain) MFJsonObject *object;

#pragma mark - Methods

/*!
 * @brief Indicated to the flow the message that will be treat
 * @param p_message The message to treat
 * @return YES if the message has been treat, NO otherwhise.
 */
-(BOOL) processMessagePart:(NSString *) p_message;

/*!
 * @brief Read the flow to search a JSON object and return YES if an JSON object has been found.
 * @return YES if a JSON object has been found, NO otherwhise.
 */
-(BOOL) hasNext;

/*!
 * @brief Returns the current path on the flow.
 * @return The current path on the flow
 */
-(NSString *) getCurrentPath;

@end
