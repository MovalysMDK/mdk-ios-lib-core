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
//  MFReaderStackAttribute.h
//  MFCore
//
//

/*!
 * This stack stores the current read attribute.
 * At the stack's top, we find the most recent current read attribute.
 * At the stack's bottom, we find the oldest current attribute.
 * 
 * We use the word 'current' because all attributes in this stack are been processing by the system.
 * Attributes which the system finished to process were deleted from the stack.
 *
 */
@interface MFReaderStackAttribute : NSObject

/*!
 * Insert the new attribute at the stack top.
 *
 * @param name - Attribute's name
 */
+(void) beginReadAttribute:(NSString *) name;

/*!
 * Get the attribute name at the stack top.
 * Doesn't pop the attribute name.
 *
 * @return Last pushed attribute.
 */
+(NSString *) getCurrentReadAttribute;

/*!
 * Retrieve the previous key from the stack.
 *
 * @return previous key
 */
+(NSString *) retrievePreviousKeyFromStack;


/*!
 * Pop the last pushed attribute name from the stack.
 * Check if the popped attribute's name is the same as the parameter.
 * If the two attribute's names are different then it throws an exception.
 *
 * @param name - Attribute's name to pop.
 */
+(void) endReadAttribute:(NSString *) name;

@end
