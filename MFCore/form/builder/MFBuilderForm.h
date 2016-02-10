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
//  MFFormBuilder.h
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

#import "MFFormBuilderProtocol.h"

@interface MFBuilderForm : NSObject<MFFormBuilderProtocol>

/*!
 * @brief This method creates  and fill a FormDescriptor from a PLIST file
 * @param plistFileName the name of the PLIST file necessary to fill the descriptor
 * @return A filled FormDescriptor
 */
-(MFFormDescriptor *) buildFromPlistFileName:(NSString *) plistFileName;

/*!
 * @brief This method creates  and fill a FormDescriptor from a dictionnary
 * @param formDictionnary The dictionnary containing all datas to fill the descriptor
 * @return A filled FormDescriptor
 */
-(MFFormDescriptor *) buildFromDictionary:(NSDictionary *) formDictionary;

@end
