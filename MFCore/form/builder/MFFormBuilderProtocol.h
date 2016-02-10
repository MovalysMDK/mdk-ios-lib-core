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
//  MFBuilderProtocol.h
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

/*!
 * This is the start point of display screen building.
 * In this framework, each display screen is defined by a plist file.
 * This file is composed of attributes which can be grouped by value type:
 *      1) Collection type (NSDictionary, NSArray)
 *      2) Other types
 *
 * This plist file can have lots of forms. Each form corresponds to a specific ui view controller.
 * Each kind of ui view controller does have a specific builder which implements MFBuilderProtocol protocol.
 * Builder uses reader to construct descriptor tree. Descriptor tree represents plist file.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor.
 * @see MFReaderProtocol for more information about reader.
 */
@protocol MFFormBuilderProtocol <NSObject>

/*!
 * Build the descriptor tree from plist file.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor.
 * @param plistFileName - plist file to analyze
 * @return Descriptor tree root.
 */
-(MFFormDescriptor *) buildFromPlistFileName:(NSString *) plistFileName;

/*!
 * Build the descriptor tree from dictionary data.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor.
 * @param formDictionary - data to analyze
 * @return Descriptor tree root.
 */
-(MFFormDescriptor *) buildFromDictionary:(NSDictionary *) formDictionary;

@end
