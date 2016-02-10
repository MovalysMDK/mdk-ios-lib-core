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
//  MFReaderAttributeNameDictionary.h
//  MFCore
//
//

/*!
 * Store the names in a dictionary.
 *
 */
@interface MFReaderAttributeNameDictionary : NSObject

/*!
 * Store and valid the given name.
 *
 * @param name - Name
 * @return YES if the name is valid, NO in other cases.
 */
+(BOOL) storeAndValidName:(NSString *) name;

/*!
 * Clear this dictionary.
 */
+(void) reset;

@end
