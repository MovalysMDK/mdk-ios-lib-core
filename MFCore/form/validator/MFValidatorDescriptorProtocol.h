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
//  MFValidatorDescriptorProtocol.h
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

/*!
 * Describe descriptor validator functions.
 * The validator's goal is to validate descriptor data.
 * The validator's name must respect naming conventions.
 *
 * @see MFValidatorDescriptorFactory for more information about naming conventions.
 */
@protocol MFValidatorDescriptorProtocol <NSObject>

@required
/*!
 * Validate the descriptor passed as parameter.
 *
 * @see MFDescriptorCommonProtocol
 * @param descriptor descriptor to validate
 * @return String array which each string is an error message.
 */
-(NSArray *) validateDescriptor:(NSObject<MFDescriptorCommonProtocol> *) descriptor;

@end
