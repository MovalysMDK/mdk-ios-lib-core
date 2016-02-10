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
//  MFFormBuilder.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreBean.h"
#import "MFCoreFormDescriptor.h"
#import "MFCoreFormReader.h"

#import "MFBuilderForm.h"

@implementation MFBuilderForm

-(MFFormDescriptor *) buildFromPlistFileName:(NSString *) plistFileName
{
    NSDictionary *formDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"]];
    return [self buildFromDictionary:formDictionary];
}

-(MFFormDescriptor *) buildFromDictionary:(NSDictionary *) formDictionary
{
    if(nil != formDictionary && formDictionary.count > 0)
    {
        NSString *typeName = [formDictionary objectForKey:DESCRIPTOR_ATTRIBUTE_TYPE];
        if(nil != typeName && typeName.length > 0)
        {
            id<MFReaderProtocol> readerFactory = [MFReaderFactory createReaderFromTypeName:typeName andParentDescriptor:nil];
            MFFormDescriptor *form = [readerFactory readFromDictionary: formDictionary];
            if(readerFactory.numberOfErrors > 0)
            {
                @throw [NSException exceptionWithName:@"InvalidPlistFile" reason:@"Errors occured during plist file processing. See logs for more information." userInfo:nil];
            }
            MFCoreLogVerbose(@"Form descriptor : %@", form);
            return form;
        }
    }
    return nil;
}

@end
