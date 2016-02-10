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
//  MFValidatorDescriptorFactory.h
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

#import "MFValidatorDescriptorProtocol.h"

/*!
 * Build the appropriate descriptor validator.
 * To be used by the system, validator's name must respect the following convention:
 *      1) Use "MFValidator" as prefix.
 *      2) Rest of the name is the descriptor's name without the two first characters "MF".
 *
 * For example, the validator of 'MFGroupDescriptor' is 'MFValidatorGroupDescriptor'.
 *
 * @see MFValidatorDescriptorProtocol for more information about validator.
 */
@interface MFValidatorDescriptorFactory : NSObject

/*!
 * Get the appropriate validator according parameter.
 *
 * @see MFValidatorDescriptorProtocol for more information about validator.
 * @see MFDescriptorCommonProtocol for more information about descriptor.
 * @param descriptor - Descriptor which the system wants to validate.
 * @return Appropriate validator if it exists.
 */
+ (id<MFValidatorDescriptorProtocol>) getValidatorFromDescriptor:(id<MFDescriptorCommonProtocol>) descriptor;

@end
