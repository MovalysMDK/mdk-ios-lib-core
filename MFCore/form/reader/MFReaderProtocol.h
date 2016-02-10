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
//  MFReaderProtocol.h
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

/*!
 * Describe the reader functions.
 * The reader goal is to build a descriptor from dictionary data.
 * It can use other readers to do that.
 * Reader's name must repect naming conventions.
 *
 * @see MFReaderFactory for more information about naming conventions.
 */
@protocol MFReaderProtocol <NSObject>

@required

/*!
 Number of errors occured during the read.
 */
@property(nonatomic) NSUInteger numberOfErrors;

/*!
 * Initialize teh reader.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor
 * @param parent - parent of descriptor which will be read by this reader
 * @return new instance of reader.
 */
-(id) initWithParentDescriptor:(id<MFDescriptorCommonProtocol>) parentDescriptor;

/*!
 * Read dictionary data to build descriptor.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor.
 * @param dictionary - Dictionary which contains data to build descriptor.
 * @return New descriptor.
 */
-(id<MFDescriptorCommonProtocol>) readFromDictionary:(NSDictionary *) dictionary;

@end
