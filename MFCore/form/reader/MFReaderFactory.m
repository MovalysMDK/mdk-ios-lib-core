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
//  MFReaderFactory.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreFoundationExt.h"
#import "MFCoreFormDescriptor.h"

#import "MFReaderFactory.h"
#import "MFReaderStackAttribute.h"

@implementation MFReaderFactory

static NSString *const BASE_NAME = @"MFReader";

+ (id<MFReaderProtocol>) createReaderFromStackWithParentDescriptor:(id<MFDescriptorCommonProtocol>) parent
{
    NSString *currentAttribute = [MFReaderStackAttribute getCurrentReadAttribute];
    NSString *readerTypeName = [@[BASE_NAME,[currentAttribute capitalizedString]] componentsJoinedByString:@""];
    NSString *typeName = [readerTypeName endsWithCharacter:L's'] ? [readerTypeName truncateLastCharacter] : readerTypeName;
    return [MFReaderFactory createReaderFromReaderTypeName:typeName andParentDescriptor:parent];
}

+ (id<MFReaderProtocol>) createReaderFromTypeName:(NSString *) typeName andParentDescriptor:(id<MFDescriptorCommonProtocol>) parent
{
    MFCoreLogVerbose(@"Asking for reader class named %@", typeName);
    if(nil == typeName || typeName.length < 2)
    {
        return nil;
    }
    NSString *readerTypeName = [@[BASE_NAME, [typeName substringFromIndex:2]] componentsJoinedByString:@""];
    MFCoreLogVerbose(@"Try to load class named %@", readerTypeName);
    return [MFReaderFactory createReaderFromReaderTypeName:readerTypeName andParentDescriptor:parent];
}

/**
 * Buil a new reader from the given type name.
 *
 * @see MFReaderProtocol for more information
 * @param readerTypeName - reader type name to instanciate
 * @return Instance of given type name
 */
+ (id<MFReaderProtocol>) createReaderFromReaderTypeName:(NSString *) readerTypeName andParentDescriptor:(id<MFDescriptorCommonProtocol>) parentDescriptor
{
    Class cl = NSClassFromString(readerTypeName);
    if(nil == cl)
    {
        MFCoreLogVerbose(@"To be unable to load reader class named '%@'", readerTypeName);
    }
    else
    {
        MFCoreLogVerbose(@"Reader class named '%@' loading succeeded", readerTypeName);
    }
    id<MFReaderProtocol> instance = [cl alloc];
    return [instance initWithParentDescriptor:parentDescriptor];
}

@end
