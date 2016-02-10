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
//  MFBuilderFactory.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreBean.h"
#import "MFCoreFormDescriptor.h"
#import "MFCoreFormReader.h"

#import "MFBuilderFactory.h"
#import "MFBuilderForm.h"
#import "MFFormBuilderProtocol.h"

@implementation MFBuilderFactory

+(MFFormDescriptor *) buildFormDescriptorFromPlistFileName:(NSString *) plistFileName
{
    MFCoreLogVerbose(@"Try to open file named '%@.plist'", plistFileName);
    NSString *path = [[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"];
    if(!path)
    {
        MFCoreLogError(@"plist file named %@ doesn't exist", plistFileName);
    }
    NSDictionary *formDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    MFCoreLogVerbose(@"Dictionary from file named '%@' : %@", plistFileName, formDictionary);
    
    return [MFBuilderFactory buildFormDescriptorFromDictionary:formDictionary];
}

+(MFFormDescriptor *) buildFormDescriptorFromDictionary:(NSDictionary *) dictionary
{
    NSString *typeName = [dictionary objectForKey:DESCRIPTOR_ATTRIBUTE_TYPE];
    if(nil != typeName && typeName.length > 0)
    {
        id<MFFormBuilderProtocol> builder = [MFBuilderFactory getFromDictionary:dictionary andFormTypeName:typeName];
        if(nil == builder)
        {
            MFCoreLogError(@"Cannot instanciate builder for type '%@'", typeName);
        }
        [MFReaderAttributeNameDictionary reset];
        MFCoreLogVerbose(@"Dictionnary : %@",dictionary);
        return [builder buildFromDictionary:dictionary];
    }
    else
    {
        MFCoreLogError(@"Form type name not available (typeName element)");
        //@throw([NSException exceptionWithName:@"" reason:@"Form type name not available (typeName element)" userInfo:nil]);
    }
    return nil;
}

+(id<MFFormBuilderProtocol>) getFromDictionary:(NSDictionary *) dictionary andFormTypeName:(NSString *) typeName
{
    MFCoreLogVerbose(@"Asking for builder class named %@", typeName);
    if(nil == typeName || typeName.length < 2)
    {
        return nil;
    }
    NSString *builderTypeName = [@[@"MFBuilder", [typeName substringFromIndex:2]] componentsJoinedByString:@""];
    MFCoreLogVerbose(@"Try to load builder class named %@", builderTypeName);
    Class cl = NSClassFromString(builderTypeName);
    if(nil == cl)
    {
        MFCoreLogVerbose(@"To be unable to load builder class named %@", builderTypeName);
    }
    else
    {
        MFCoreLogVerbose(@"Builder class named %@ loading succeeded", builderTypeName);
    }
    return [[cl alloc] init];
}

@end
