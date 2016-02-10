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
//  MFConfigurationHandler.h
//  MFCore
//
//

#import "MFProperty.h"

/*!
 * @brief Application property manager. There are two property types:
 * - simple property
 * - visual configuration
 *
 * There are 3 property origins:
 * - plist file
 * - Storyboard (only for visual configuration)
 * - Remote server
 */
@interface MFConfigurationHandler : NSObject

/*!
 * @brief le nom de la configuration
 */
@property(nonatomic) NSMutableDictionary *configuration;

/*!
 * @brief Allow to find property according to the given property name.
 * @param propertyName - Name of the searched property
 * @return searched property
 */
- (MFProperty*) getProperty:(NSString *) propertyName;

/*!
 * @brief Allow to find property according to the given property name.
 * @param propertyName - Name of the searched property
 * @param defaultValue the default value
 * @return searched property
 */
- (BOOL) getBooleanProperty:(NSString *) propertyName withDefault:(BOOL) defaultValue;

/*!
 * @brief Allow to find property according to the given property name.
 * @param propertyName - Name of the searched property
 * @return searched property as string
 */
- (NSString *) getStringProperty:(NSString *) propertyName;

/*!
 * @brief Allow to find property according to the given property name.
 * @param propertyName - Name of the searched property
 * @return searched property as number
 */
- (NSNumber *) getNumberProperty:(NSString *) propertyName;

/*!
 * @brief Allow to find property according to the given property name.
 * @param propertyName - Name of the searched property
 * @return searched property as array
 */
- (NSArray *) getArrayProperty:(NSString *) propertyName;

/*!
 * @brief Allow to find property according to the given property name.
 * @param propertyName - Name of the searched property
 * @return searched property as FormDescriptor
 */
- (NSDictionary *) getDictionaryProperty:(NSString *) propertyName;

/*!
 * @brief Create a delegate instance according to the the given name.
 * @param propertyName - Searched property name
 * @return delegate instance
 */
- (id) getDelegateFromProperty: (NSString *) propertyName;

@end
