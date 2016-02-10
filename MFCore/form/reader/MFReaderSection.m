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
//  MFReaderSection.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreBean.h"
#import "MFCoreFormDescriptor.h"

#import "MFReaderSection.h"

#define FIELD_GROUPS ((@"groups"))

@interface MFReaderSection()

@end

@implementation MFReaderSection

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(MFSectionDescriptor *) readFromDictionary:(NSDictionary *) dictionary
{
    MFSectionDescriptor *section = nil;
    if(nil == dictionary)
    {
        return section;
    }
    section = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_SECTION_DESCRIPTOR];
    section.parent = self.parentDescriptor;
    section.fileName = self.parentDescriptor.fileName;
    MFCoreLogVerbose(@"MFReaderField - Descriptor '%@' is the parent descriptor of '%@'", [self.parentDescriptor class], [section class]);
    MFCoreLogVerbose(@"section : %@, and dictionnary : %@",section,dictionary);
    [self fillDescriptorData:section withDataFromDictionary: dictionary];
    return section;
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
    MFSectionDescriptor *sectionDescriptor = (MFSectionDescriptor *) descriptor;
    if([key isEqualToString:FIELD_GROUPS]) {
        MFCoreLogVerbose(@"Specific process of field named '%@' in group descriptor", FIELD_GROUPS);
        [sectionDescriptor addGroups:value];
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
