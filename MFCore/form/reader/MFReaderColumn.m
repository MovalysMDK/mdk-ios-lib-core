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
//  MFReaderColumn.m
//  MFCore
//
//

#import "MFReaderColumn.h"
#import "MFCoreBean.h"

#define FIELD_GROUPS ((@"groups"))

@interface MFReaderColumn()

@end

@implementation MFReaderColumn
@synthesize parentDescriptor = _parentDescriptor;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(MFColumnDescriptor *) readFromDictionary:(NSDictionary *) dictionary
{
    MFColumnDescriptor *column = nil;
    if(nil == dictionary)
    {
        return column;
    }
    column = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_COLUMN_DESCRIPTOR];
    column.parent = self.parentDescriptor;
    
    MFCoreLogVerbose(@"MFReaderColumn - Descriptor '%@' is the parent descriptor of '%@'", [self.parentDescriptor class], [column class]);
    MFCoreLogVerbose(@"column : %@, and dictionnary : %@",column,dictionary);
    [self fillDescriptorData:column withDataFromDictionary: dictionary];
    return column;
}

#pragma mark - MFReaderDelegate implementation

-(BOOL) processKey:(NSString *) key WithSimpleValue:(id) value ForCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    return YES;
}

-(BOOL) processKey:(NSString *) key WithDictionaryValue:(NSDictionary *) value ForCurrentDescriptor:(id<MFDescriptorCommonProtocol>) descriptor
{
    return YES;
}

-(void)setParentDescriptor:(id<MFDescriptorCommonProtocol>) desc {
    _parentDescriptor = desc;
}

@end
