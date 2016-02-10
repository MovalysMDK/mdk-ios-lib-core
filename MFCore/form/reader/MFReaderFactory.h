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
//  MFReaderFactory.h
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

#import "MFReaderProtocol.h"

/*!
 * This factory build appropriate MFReaderProtocol reader.
 * To be used automatically by the system, reader's name must respect the following conventions:
 *      1) Use "MFReader" as prefix
 *      2) The rest of the name can be:
 *          2.1) The framework ui control type name like "MFFormViewController" without the two first characters "MF".
 *          2.2) The name of an attribute in the screen description plist file.
 *
 * For example: the framework contains the ui control named "MFFormViewController".
 * So the system can search a reader named "MFReaderForm".
 *
 * An other example: The screen description plist file contains an attribute named 'section'. So the system can search a reader named "MFReaderSection".
 * 
 * @see MFReaderProtocol for more information about MFReader.
 */
@interface MFReaderFactory : NSObject

/*!
 * Build the appropriate reader according framework ui control type name passed as parameter.
 * This function applies the first logic (first example) to find the appropriate reader.
 *
 * @see MFReaderProtocol for more information about MFReader.
 * @param typeName Type name which the reader is capable of reading.
 * @return Appropriate ui control type reader.
 */
+ (id<MFReaderProtocol>) createReaderFromTypeName:(NSString *) typeName andParentDescriptor:(id<MFDescriptorCommonProtocol>) parent;

/*!
 * Build the appropriate reader according top attribute name which is in the reader stack. This function applies the second logic (second example) to find the appropriate reader.
 *
 * @see MFReaderProtocol for more information about reader.
 * @see MFReaderStackAttribute for more information about reader stack.
 * @return Appropriate attribute name reader
 */
+ (id<MFReaderProtocol>) createReaderFromStackWithParentDescriptor:(id<MFDescriptorCommonProtocol>) parent;

@end
