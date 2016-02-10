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
//  MFReaderGroup.m
//  MFCore
//
//

#import "MFCoreFoundationExt.h"
#import "MFCoreBean.h"
#import "MFCoreFormDescriptor.h"
#import "MFCoreFormConfig.h"

#import "MFReaderGroup.h"

#define FIELD_FIELDS ((@"fields"))

@interface MFReaderGroup()

@end


@implementation MFReaderGroup

-(id)init
{
    self = [super init];
    if(self)
    {
        self.delegate = self;
    }
    return self;
}

-(MFGroupDescriptor *) readFromDictionary:(NSDictionary *) dictionary
{
    MFGroupDescriptor *group = nil;
    if(nil == dictionary)
    {
        return group;
    }
    group = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_GROUP_DESCRIPTOR];
    group.fileName = self.parentDescriptor.fileName;
    group.parent = self.parentDescriptor;
    MFCoreLogVerbose(@"MFReaderField - Descriptor '%@' is the parent descriptor of '%@'", [self.parentDescriptor class], [group class]);
    [self fillDescriptorData:group withDataFromDictionary: dictionary];
    
    MFCoreLogVerbose(@"group.configurationName: '%@'", group.configurationName);
    MFCoreLogVerbose(@"group.configurationName: '%@'", dictionary[DESCRIPTOR_ATTRIBUTE_CONFIGURATION]);
    group.configurationName = dictionary[DESCRIPTOR_ATTRIBUTE_CONFIGURATION];
    
    MFCoreLogVerbose(@"group.configurationName: '%@'", group.configurationName);
    if(![NSString isNilOrEmpty:group.configurationName]) {
        MFConfigurationHandler *configHandler = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
        MFConfigurationGroupDescriptor *groupDesc = [configHandler getConfigurationGroupDescriptor:group.   configurationName];
        MFCoreLogVerbose(@"Apply configuration (%@) named '%@' on MFGroupDescriptor named '%@'", groupDesc, group.configurationName, group.name);
        group.height = groupDesc.height;
        group.heightNoLabel = groupDesc.heightNoLabel;
    }
    return group;
}

#pragma mark - MFReaderDelegate implementation

-(BOOL) processKey:(NSString *) key withSimpleValue:(id) value forCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    return YES;
}

-(BOOL) processKey:(NSString *) key WithDictionaryValue:(NSDictionary *) value ForCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    return YES;
}

-(BOOL) processKey:(NSString *) key withArrayValue:(NSArray *) value forCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    MFGroupDescriptor *groupDescriptor = (MFGroupDescriptor *) descriptor;
    if([FIELD_FIELDS isEqualToString:key]) {
        MFCoreLogVerbose(@"Specific process of field named '%@' in group descriptor", FIELD_FIELDS);
        [groupDescriptor addFields:value];
        return NO;
    }
    else if([DESCRIPTOR_ATTRIBUTE_CONFIGURATION isEqualToString:key])
    {
        MFCoreLogVerbose(@"Specific process of field named '%@' in group descriptor", FIELD_FIELDS);
        // We have already processed this key
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
