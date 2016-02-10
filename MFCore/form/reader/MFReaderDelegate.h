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
//  MFReaderDelegate.h
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

/*!
 * This delegate allows reader creator to customize the plist file attribute processing.
 *
 * @see MFDescriptorCommonProtocol for more information about plist file.
 * @see MFReaderProtocol for more information about reader.
 */
@protocol MFReaderDelegate <NSObject>

@required
/*!
 * Call when attribute type isn't a collection type.
 *
 * @see MFDescriptorCommonProtocol for more information about attribute.
 * @param key - Attribute name
 * @param value - Attribute value
 * @param descriptor - Current descriptor which system is filling
 * @return YES if you decide to leave the system processes this attribute. In other case, NO which means that you process this attribute and you doesn't want that system process it again.
 */
-(BOOL) processKey:(NSString *) key withSimpleValue:(id) value forCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor;

/*!
 * Call when attribute type is NSDictionary.
 *
 * @see MFDescriptorCommonProtocol for more information about attribute.
 * @param key - Attribute name
 * @param value - Attribute value (NSDictionary)
 * @param descriptor - Current descriptor which system is filling
 * @return YES if you decide to leave the system processes this attribute. In other case, NO which means that you process this attribute and you doesn't want that system process it again.
 */
-(BOOL) processKey:(NSString *) key WithDictionaryValue:(NSDictionary *) value ForCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor;

/*!
 * Call when attribute type is NSArray.
 *
 * @see MFDescriptorCommonProtocol for more information about attribute.
 * @param key - Attribute name
 * @param value - Attribute value (NSArray)
 * @param descriptor - Current descriptor which system is filling
 * @return YES if you decide to leave the system processes this attribute. In other case, NO which means that you process this attribute and you doesn't want that system process it again.
 */
-(BOOL) processKey:(NSString *) key withArrayValue:(NSArray *) value forCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor;

@end
