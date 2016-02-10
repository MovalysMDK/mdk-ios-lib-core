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
//  MFValidatorDescriptorFactory.m
//  MFCore
//
//

#import <objc/runtime.h>

#import "MFValidatorDescriptorFactory.h"

@implementation MFValidatorDescriptorFactory

static NSString *const PREFIX = @"MFValidator";

+ (id<MFValidatorDescriptorProtocol>) getValidatorFromDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    NSString *descriptorClassName = [NSString stringWithUTF8String:class_getName([descriptor class])];
    if(!descriptorClassName || descriptorClassName.length < 2)
    {
        return nil;
    }
    NSString *validatorClassName = [@[PREFIX, [descriptorClassName substringFromIndex:2]] componentsJoinedByString:@""];
    Class validatorClass = NSClassFromString(validatorClassName);
    if(nil == validatorClass)
    {
        return nil;
    }
    else
    {
        return [[validatorClass alloc] init];
    }
}

@end
