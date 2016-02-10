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
//  MFProperty.h
//  MFCore
//
//

#import "MFAbstractConfiguration.h"

/*!
 * Simple property definition.
 *
 */
@interface MFProperty : MFAbstractConfiguration

/*!
 Property value.
 */
@property(nonatomic) id value;

/*!
 * Return the property value as a string value.
 *
 * @return string value of property.
 */
-(NSString *) getStringValue;

/*!
 * Return the property value as an array.
 *
 * @return array value of property.
 */
-(NSArray *) getArray;

/*!
 * Return the property value as a number value.
 *
 * @return number value of property.
 */
-(NSNumber*) getNumberValue;

/*!
 * Return the property value as a dictionnary.
 *
 * @return dictionnary of property.
 */
-(NSDictionary*) getDictionaryValue;

/*!
 * Return the property value as a BOOL value.
 *
 * @return BOOL value of property.
 */
-(BOOL) getBOOLValue;

@end
