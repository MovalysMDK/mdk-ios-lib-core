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
//  GroupDescriptor.h
//  MFCore
//
//

#import "MFFieldDescriptor.h"
#import "MFDescriptorCommonProtocol.h"
#import "MFDescriptorCommon.h"

/*!
 Description of Field group.
 Group's characteristics are:
  - Name
  - Cell's graphic type used to display
  - Cell's height
 */
//SMA TODO : voir si on continue le stockage de cette manière, ou si on met une référence plus forte vers une instance de cellule pour les information type et hauteur
// => utiliser directement un FormCellDescriptor
@interface MFGroupDescriptor : MFDescriptorCommon

#pragma mark - Properties

/*! 
 * @brief Sorted group's component set 
 */
@property(nonatomic, strong, readonly) NSArray *fields;

/*! 
 * @brief Field names 
 */
@property(nonatomic, strong, readonly) NSArray *fieldNames;

/*!
 * @brief Cell's height in pixels
 */
@property(nonatomic, strong) NSNumber *height;

/*!
 * @brief Cell's height in pixels without label
 */
@property(nonatomic, strong) NSNumber *heightNoLabel;




#pragma mark - Methods

/*!
 Label field descriptor.
 */
-(MFFieldDescriptor*) getFieldDescriptorLabel;

/*!
 Add a field to this group.
 
 @param field field to add
 */
-(void) addField:(MFFieldDescriptor *) field;

/*!
 Add fields to this group.
 
 @param fields field set to add.
 */
-(void) addFields:(NSArray *) fields;

/*!
 Retrieve fields descriptions from field type.
 
 @param fieldClass Field type (Class)
 @result Fields descriptor
 */
-(NSArray *) getFieldsByFieldType:(Class) fieldClass;

@end
