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


#import "MFErrorProtocol.h"

/*!
 Framework base error :  All unmanaged error must be converted into specific MFError's descendant error.
 So all framework errors must inherit MFError.
 **/
@interface MFError : NSError<MFErrorProtocol>

/*
 Error Domain.
 */
@property (readonly) NSString *domainBase;

/* 
 Designated initializer. 
 @param code Error unique code.
 @param dict may be nil if no userInfo desired.
 */
- (id)initWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;

/*
 Designated initializer.
 @param code Error unique code.
 @param descriptionKey complete sentence which describes why the operation failed. In many cases this will be just the "because" part of the error message (but as a complete sentence, which makes localization easier).
 @param failureReasonKey The string that can be displayed as the "informative" (aka "secondary") message on an alert panel
 */
- (id)initWithCode:(NSInteger)code localizedDescriptionKey:(NSString *)descriptionKey localizedFailureReasonErrorKey: (NSString *) failureReasonKey;

/*
 Designated initializer.
 @param code Error unique code.
 @param descriptionKey complete sentence which describes why the operation failed. In many cases this will be just the "because" part of the error message (but as a complete sentence, which makes localization easier).
 */
- (id)initWithCode:(NSInteger)code localizedDescriptionKey:(NSString *)descriptionKey;

/*
 Designated initializer.
 @param code Error unique code.
 @param dict may be nil if no userInfo desired.
 */
+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;

@end
