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
//  MFSectionDescriptor.h
//  MFCore
//
//

#import "MFDescriptorCommonProtocol.h"
#import "MFGroupDescriptor.h"
#import "MFDescriptorCommon.h"

/**
 * @class MFSectionDescriptor
 * @brief A descriptor for a form section
 * @discussion Sections are parts of a form. The are often described with PLIST 
 * files named "section-XXXXX.plist" where XXXX is the name of the section.
 */
@interface MFSectionDescriptor : MFDescriptorCommon

#pragma mark - Properties

/*!
 * @brief The set of groups of this section
 */
@property(nonatomic, strong, readonly) NSDictionary *groups;

/*! 
 * @brief The ordered array of groups of this section
 */
@property(nonatomic, strong, readonly) NSArray *orderedGroups;

/*!
 * @brief Section's height in points.
 */
@property(nonatomic, strong) NSNumber *height;

/*!
 * @brief Section's title visibility
 */
@property(nonatomic) BOOL titled;

/*!
 * @brief Indicates if the group is describes as a cell (default is YES)
 */
@property(nonatomic) BOOL isInRootView;


#pragma mark - Methods
/*!
 * @brief Add a group to this section from a groupDescriptor
 * @param groupDescritor The group to add
 */
-(void) addGroup:(MFGroupDescriptor *)groupDescriptor;

/*!
 * @brief Add groups to this section from an array of Group descriptors
 * @param groups An array of group descriptors to add
 */
-(void) addGroups:(NSArray *) groups;

/*!
 * @brief Valide le descripteur de formulaire, et cherche des informations présentes dans d'autres registres.
 * Pour valider le descripteur de formulaire, il faut valider l'ensemble des descripteurs de groupes.
 */
-(void) checkAndPrepare;

@end
