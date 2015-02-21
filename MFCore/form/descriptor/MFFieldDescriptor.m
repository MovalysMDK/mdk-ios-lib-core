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
//  FieldDescriptor.m
//  MFCore
//
//

#import "MFCoreFoundationExt.h"
#import "MFCoreLog.h"
#import "MFCoreBean.h"

#import "MFFieldDescriptor.h"

@implementation MFFieldDescriptor

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString *) getLabel {
    NSString *label = self.name;
    NSArray *strings = [self.name componentsSeparatedByString:@"__"];
    if ([strings count]==3) {
        label = [strings objectAtIndex:1];
    }
    return label;
}

- (id)copyWithZone:(NSZone *)zone
{
    MFFieldDescriptor *copy = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_FIELD_DESCRIPTOR];
    if(copy)
    {
        copy.parent = self.parent;
        copy.name = self.name;
        copy.uitype = self.uitype;
        copy.configurationName = self.configurationName;
        copy.visible = self.visible;
        copy.mandatory = self.mandatory;
        copy.bindingKey = self.bindingKey;
        copy.vmValueChangedMethodName = self.vmValueChangedMethodName;
        copy.backgroundColor = self.backgroundColor;
        copy.textColor = self.textColor;
        copy.converter = self.converter;
        copy.i18nKey = self.i18nKey;
        copy.editItemListener = self.editItemListener;
        copy.addItemListener = self.addItemListener;
        copy.deleteItemListener = self.deleteItemListener;
        copy.parameters = self.parameters;
        copy.innerComponentsBackgroundColor = self.innerComponentsBackgroundColor;
        copy.editable = self.editable;
        copy.cellPropertyBinding = self.cellPropertyBinding;
        copy.componentAlignment = self.componentAlignment;

    }
    return copy;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"MFFieldDescriptor:<name: %@, uitype: %@, configurationName: %@, visible: %@, mandatory: %@,parent: %@, bindingKey : %@, methode custom pour changement dans View model : %@, converter :%@, backgroundColor : %@, editable : %@", self.name, self.uitype, self.configurationName, [MFHelperBOOL asString:self.visible], ((self.mandatory) ? @"OUI" : @"NON"), self.parent.name, self.bindingKey,
            self.vmValueChangedMethodName, self.converter, self.backgroundColor, self.editable];
}

-(NSString *)bindingKey {
    NSString *returnBindingKey = _bindingKey;
    if(_bindingKey == nil) {
        returnBindingKey = self.name;
    }

    return returnBindingKey;
}


-(id)valueForUndefinedKey:(NSString *)key {
    MFCoreLogWarn(@"La propriété \"%@\" n'est pas définie sur MFFieldDescriptor", key);
    return nil;
}

@end
