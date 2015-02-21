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
//  MFDescriptorCommonProtocol.h
//  MFCore
//
//

/*!
 * Display screen description plist file is represented by a descriptor tree.
 * This descriptor tree is used by framework to build display screen.
 * Descriptor represents ui elements like form, section, row, ...
 * Readers build descriptors.
 *
 * All descriptors must implement this protocol.
 * It defines the descriptor common mandatory properties.
 *
 * @see MFBuilderProtocol for more information about plist file.
 */
@protocol MFDescriptorCommonProtocol <NSObject, NSCopying>

@required
/*!
 UI element's parent
 */
@property(nonatomic, weak) id<MFDescriptorCommonProtocol> parent;

/*!
 UI element name. This element must be unique.
 */
@property(nonatomic, strong) NSString *name;

/*!
 UI element type.
 There are some types of cell, form, section, ...
 This property allow to define exactly the type to in.
 */
@property(nonatomic, strong) NSString *uitype;

/*
 UI element's configuration name.
 Use to load configuration.
 */
@property(nonatomic, strong) NSString *configurationName;

/*
 Define the ui element's visibility
 */
@property(nonatomic) NSString *visible;

/*
 Define the label visibility
 */
@property(nonatomic) NSString *noLabel;

@property(nonatomic, strong) NSString *fileName;

@end
