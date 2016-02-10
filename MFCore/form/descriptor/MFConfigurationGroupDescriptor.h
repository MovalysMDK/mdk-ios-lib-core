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
//  MFConfigurationGroupDescriptor.h
//  MFCore
//
//

#import "MFConfigurationUIComponent.h"

/*!
 * Configuration group descriptor.
 *
 */
@interface MFConfigurationGroupDescriptor : MFConfigurationUIComponent

/*!
 Group defined table view cell specification.
 This property defines cell height in point.
 */
@property(nonatomic) NSNumber *height;

/*!
 Group defined table view cell specification.
 This property defines cell height without label in point.
 */
@property(nonatomic) NSNumber *heightNoLabel;

@end
