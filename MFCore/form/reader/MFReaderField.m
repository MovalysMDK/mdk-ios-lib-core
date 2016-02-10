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
//  MFReaderField.m
//  MFCore
//
//

#import "MFCoreBean.h"

#import "MFReaderField.h"

#define FIELD_TYPE_NAME ((@"typeName"))

@interface MFReaderField()

@end

@implementation MFReaderField

- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(MFFieldDescriptor *) readFromDictionary:(NSDictionary *) dictionary
{    
    MFFieldDescriptor *field = nil;
    if(nil == dictionary)
    {
        return field;
    }
    field =  [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_FIELD_DESCRIPTOR];
    field.parent = self.parentDescriptor;
    MFCoreLogVerbose(@"MFReaderField - Descriptor '%@' is the parent descriptor of '%@'", [self.parentDescriptor class], [field class]);
    [self fillDescriptorData:field withDataFromDictionary: dictionary];
    return field;
}

#pragma mark - MFReaderDelegate implementation

-(BOOL) processKey:(NSString *) key withSimpleValue:(id) value forCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    MFFieldDescriptor *fieldDescriptor = (MFFieldDescriptor *) descriptor;
    if([key isEqualToString:FIELD_TYPE_NAME]) {
        MFCoreLogVerbose(@"Specific process of field named '%@' in group descriptor", FIELD_TYPE_NAME);
        fieldDescriptor.uitype = value;
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL) processKey:(NSString *) key WithDictionaryValue:(NSDictionary *) value ForCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    return YES;
}

-(BOOL) processKey:(NSString *) key withArrayValue:(NSArray *) value forCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    return YES;
}

@end
