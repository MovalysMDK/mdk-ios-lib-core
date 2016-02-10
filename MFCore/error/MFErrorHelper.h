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
//  MFErrorHelper.h
//  MFCore
//
//

/*!
 * NSError helper which helps developper to handle NSError object.
 */
@interface MFErrorHelper : NSObject

/*!
 * Create an NSError instance.
 *
 * @param domain - NSError's domain
 * @param localizedDescriptionKey - The primary user-presentable message for the error.
 * @param localizedFailureReasonErrorKey - Return a complete sentence which describes why the operation failed
 *
 * @return New NSError instance.
 */
+(NSError *) initErrorWithDomain: (NSString *) domain andLocalizedDescriptionKey: (NSString *)localizedDescriptionKey andLocalizedFailureReasonErrorKey: (NSString *) localizedFailureReasonErrorKey;

/*!
 * Create an NSError instance.
 *
 * @param domain - NSError's domain
 * @param localizedDescriptionKey - The primary user-presentable message for the error. localizedFailureReasonErrorKey is initialized with this value too.
 *
 * @return New NSError instance.
 */
+(NSError *) initErrorWithDomain: (NSString *) domain andLocalizedDescriptionKey: (NSString *)localizedDescriptionKey;

@end
