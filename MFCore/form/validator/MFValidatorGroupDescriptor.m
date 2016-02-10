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
//  MFValidatorGroupDescriptor.m
//  MFCore
//
//

#import "MFCoreI18n.h"
#import "MFCoreFormDescriptor.h"

#import "MFValidatorGroupDescriptor.h"

@implementation MFValidatorGroupDescriptor

-(NSArray *) validateDescriptor:(MFGroupDescriptor *) descriptor
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if(nil == descriptor.uitype || descriptor.uitype.length == 0)
    {
        NSString *message = [NSString stringWithFormat:@"%@ of group named %@ is mandatory", DESCRIPTOR_ATTRIBUTE_TYPE, descriptor.name];
        [list addObject:MFLocalizedStringFromKey(message)];
    }
    return list;
}

@end
