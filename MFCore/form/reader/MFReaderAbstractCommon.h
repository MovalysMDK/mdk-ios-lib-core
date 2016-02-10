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
//  MFReaderCommon.h
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreFormDescriptor.h"

#import "MFReaderDelegate.h"
#import "MFReaderProtocol.h"

/*!
 * Implement the basic system research of appropriate reader.
 * Use of this class in readers isn't mandatory but this is very helpful.
 * This implementation introduces the partial plist file concept: a plist file can redirect reader to other plist files.
 * This other plist files can be incomplete.
 * MFReaderCommon implementation implements the following logics:
 *      1) Array process logic : create an array an process each item
 *      2) Dictionary process logic : find the appropriate reader of this dictionary
 *      3) other type process logic : try to map descriptor property with screen description plist file attribute name.
 *
 * @see MFDescriptorProtocol for more information about plist file.
 */
@interface MFReaderAbstractCommon : NSObject<MFReaderProtocol>

/*!
 MFReaderDelegate called  during reading.
 */
@property(nonatomic, weak) id<MFReaderDelegate> delegate;

/*!
 Parent of descriptor which is built by reader instance.
 */
@property(nonatomic, strong, readonly) id<MFDescriptorCommonProtocol> parentDescriptor;

/*!
 * Fill the given descriptor with the given dictionary data.
 *
 * @see MFDescriptorProtocol
 * @param parentDescriptor - Descriptor to fill
 * @param dictionary - plist file dictionary data
 */
-(void) fillDescriptorData:(NSObject<MFDescriptorCommonProtocol> *) parentDescriptor withDataFromDictionary:(NSDictionary *) dictionary;

/*!
 * Find and execute the appropriate reader according dictionary data.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor
 * @see MFReaderProtocol for more information about reader
 * @param dictionary - Dictionary which reader must read.
 * @return Descriptor.
 */
-(NSObject<MFDescriptorCommonProtocol> *) findAndExecuteReaderFromDictionary:(NSDictionary *) dictionary  andParentDescriptor:(id<MFDescriptorCommonProtocol>) parent;

/*!
 * Process an array plist file attribute.
 *
 * @param array - Array from the plist file.
 * @param toArray - Descriptor's array. This array is modfied by the function.
 */
-(void) readDescriptorDataFromArray:(NSArray *) array toNewArray:(NSMutableArray *) toArray withParentDescriptor:(id<MFDescriptorCommonProtocol>) parent;

@end
