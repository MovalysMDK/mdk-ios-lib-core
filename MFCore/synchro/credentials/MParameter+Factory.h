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
//  MParameter+Factory.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MParameter.h"
#import "MFContext.h"

@interface MParameter (Factory)

/*!
 * @brief Create a new instance of MParameter using MFContext
 * @param context MFContext
 * @return new instance of MParameter
 */
+ (MParameter *) MF_createMParameterInContext:(MFContext *)context;


/*!
 * @brief Create a new instance of MParameter using MFContext and the data contains in the dictionary
 * @param dictionary NSDictionary data to initialize object
 * @param context MFContext
 * @return new instance of MParameter
 */
+ (MParameter *) MF_createMParameterWithDictionary:(NSDictionary *)dictionary inContext:(MFContext *)context;


@end
