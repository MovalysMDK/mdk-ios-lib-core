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
//  FormDescriptor.m
//  MFCore
//
//

#import "MFCoreFoundationExt.h"
#import "MFCoreBean.h"

#import "MFFormDescriptor.h"
#import "MFSectionDescriptor.h"

@implementation MFFormDescriptor

static NSString *REGISTER_TYPE_OPTION = @"Type";
static NSString *REGISTER_CLASS_OPTION = @"Class";


- (id)copyWithZone:(NSZone *)zone
{
    MFFormDescriptor *copy = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_FORM_DESCRIPTOR];
    if(copy)
    {
        copy.parent = self.parent;
        copy.name = self.name;
        copy.uitype = self.uitype;
        copy.configurationName = self.configurationName;
        copy.visible = self.visible;
        copy.fileName = self.fileName;
    }
    return copy;
}

-(NSString *) description
{
    //return [super description];
    return [NSString stringWithFormat:@"MFFormDescriptor:<name: %@, uitype: %@, configurationName: %@, visible: %@, parent: %@, \nsections:%@>", self.name, self.uitype, self.configurationName, [MFHelperBOOL asString:self.visible], self.parent.name, self.sections];
}

/**
 * @brief The 'sections' setter is overloaded to split sections : 
 * The "noTable" sections are separated in the property "noTableSections"
 * @param sections An array of MFSectionDescriptor
 */
-(void)setSections:(NSArray *)sections {
    NSMutableArray *tableSections = [NSMutableArray array];
    NSMutableArray *noTableSections = [NSMutableArray array];
    for(MFSectionDescriptor *sectionDescriptor in sections) {
        if(sectionDescriptor.isInRootView) {
            [noTableSections addObject:sectionDescriptor];
        }
        else {
            [tableSections addObject:sectionDescriptor];
        }
    }
    _sections = tableSections;
    _noTableSections = noTableSections;
}

@end
