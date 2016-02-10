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
//  MFSectionDescriptor.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreFoundationExt.h"
#import "MFCoreBean.h"

#import "MFSectionDescriptor.h"

@interface MFSectionDescriptor ()

@property(nonatomic, strong) NSMutableDictionary *groups;
@property(nonatomic, strong) NSMutableArray *orderedGroupList;
@property(nonatomic, strong) NSArray *tempOrderedGroups;

@end

@implementation MFSectionDescriptor

-(id) init {
    if (self = [super init]){
        self.groups = [[NSMutableDictionary alloc]init];
        self.tempOrderedGroups = nil;
        self.orderedGroupList = [[NSMutableArray alloc] init];
        self.height = 0;
    }
    return self;
}

-(NSArray *) orderedGroups
{
    if(nil == self.tempOrderedGroups)
    {
        self.tempOrderedGroups = self.orderedGroupList;
    }
    return self.tempOrderedGroups;
}

-(void) addGroup:(MFGroupDescriptor*)groupDescriptor
{
    [self.groups setValue:groupDescriptor forKey:groupDescriptor.name];
    [self.orderedGroupList addObject:groupDescriptor];
    self.tempOrderedGroups = nil;
}

-(void) addGroups:(NSArray*) groups
{
    for (MFGroupDescriptor *group in groups) {
        group.fileName = self.fileName;
        [self addGroup:group];
    }
    [self checkAndPrepare];
}

-(void) checkAndPrepare {
    //On parcours les groupes et on cherche le type de la cellule associée :
    for(MFGroupDescriptor *group in self.orderedGroups) {
        if (group.uitype == nil){
            MFCoreLogError(@"Invalid configuration for group named '%@'", group.name);
            break;
        }
        if(group.height != nil)
        {
            self.height = [NSNumber numberWithFloat:([group.height floatValue] + [self.height floatValue])];
        }
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    MFSectionDescriptor *copy = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_SECTION_DESCRIPTOR];
    if(copy)
    {
        copy.parent = self.parent;
        copy.name = self.name;
        copy.uitype = self.uitype;
        copy.configurationName = self.configurationName;
        copy.visible = self.visible;
        copy.classCSS = self.classCSS;
        copy.fileName = self.fileName;
        [copy addGroups:self.orderedGroups];
        copy.height = self.height;
    }
    return copy;
}


-(NSString *) description
{
    return [NSString stringWithFormat:@"MFSectionDescriptor:<name: %@, uitype: %@, configurationName: %@, visible: %@, classCSS: %@, height: %@,\n parent: %@,\n groups:%@>", self.name, self.uitype, self.configurationName, [MFHelperBOOL asString:self.visible], self.classCSS, self.height, self.parent.name, self.orderedGroups];
}

@end
