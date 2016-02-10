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
//  GroupDescriptor.m
//  MFCore
//
//


#import "MFCoreFoundationExt.h"
#import "MFCoreLog.h"
#import "MFCoreBean.h"
#import "MFCoreInit.h"

#import "MFGroupDescriptor.h"
#import "MFFieldDescriptor.h"
#import "MFConfigurationGroupDescriptor.h"

@interface MFGroupDescriptor ()

@property(nonatomic, strong) NSMutableDictionary *fieldsByTypeName;
@property(nonatomic, strong) NSMutableArray *privateFields;
@property(nonatomic, strong) NSMutableArray *privateFieldNames;
@property(nonatomic, strong) NSArray *fields;
//@property(nonatomic, strong) NSString *privateConfigurationName;

@end

@implementation MFGroupDescriptor

@synthesize configurationName = _configurationName;

-(id) init {
    if (self = [super init]) {
        self.fieldsByTypeName = [[NSMutableDictionary alloc] init];
        self.privateFields = [[NSMutableArray alloc] init];
        self.privateFieldNames = [[NSMutableArray alloc] init];
    }
    return self;
}

-(MFFieldDescriptor*) getFieldDescriptorLabel
{
    return [[self.fieldsByTypeName objectForKey:@"MFLabel"] objectAtIndex:0];
}

-(NSArray *) fields
{
    return self.privateFields;
}

-(NSArray *) fieldNames
{
    return self.privateFieldNames;
}

-(void) addField:(MFFieldDescriptor *) field
{
    NSAssert(field != nil, @"MFGroupDescriptor.addField : field can't be null");
    NSAssert(field.cellPropertyBinding != nil, @"No cellPropertyBinding element for field: '%@' in plist: '%@'",
           field.name, self.fileName);
    
    [self.privateFields addObject:field];
    [self.privateFieldNames addObject:field.cellPropertyBinding];
    
    NSMutableArray *existingFields = [self.fieldsByTypeName objectForKey:field.uitype];
    if(existingFields) {
        [existingFields addObject:field];
    }
    else {
        existingFields = [NSMutableArray arrayWithObject:field];
    }
    [self.fieldsByTypeName setObject:existingFields forKey:field.uitype];
}

-(void) addFields:(NSArray *) fields
{
    [self.privateFields addObjectsFromArray:fields];
    for (MFFieldDescriptor *field in fields)
    {
        [self addField:field];
    }
}

-(NSArray *) getFieldsByFieldType:(Class) fieldClass
{
    return[self.fieldsByTypeName objectForKey:NSStringFromClass(fieldClass)];
}

//-(void) setConfigurationName:(NSString *)configurationName
//{
//    self.privateConfigurationName = configurationName;
//}

-(void) setHeight:(NSNumber *)height {
    _height = height;
}

- (id)copyWithZone:(NSZone *)zone
{
    MFGroupDescriptor *copy = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_GROUP_DESCRIPTOR];
    if(copy)
    {
        copy.parent = self.parent;
        copy.name = self.name;
        copy.uitype = self.uitype;
        copy.configurationName = self.configurationName;
        copy.visible = self.visible;
        copy.classCSS = self.classCSS;
        copy.height = self.height;
        copy.heightNoLabel = self.heightNoLabel;
        [copy addFields:self.fields];
        copy.fileName = self.fileName;
    }
    return copy;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"MFGroupDescriptor:<name: %@, uitype: %@, configurationName: %@, visible: %@, classCSS: %@, height: %@, \nparent: %@,\nfields: %@>", self.name, self.uitype, self.configurationName, [MFHelperBOOL asString:self.visible], self.classCSS, self.height, self.parent.name, self.fields];
}

@end
