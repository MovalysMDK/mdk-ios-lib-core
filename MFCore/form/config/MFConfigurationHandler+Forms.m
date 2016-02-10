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
//  MFConfigurationHandler+Forms.m
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"
#import "MFCoreLog.h"
#import "MFCoreBean.h"
#import "MFCoreFormReader.h"

#import "MFProperty+Forms.h"
#import "MFConfigurationHandler+Forms.h"
#import "MFFormConstants.h"

@implementation MFConfigurationHandler (Forms)

static NSString *const CONST_ATTRIBUT_TYPE_NAME = @"typeName";

- (void) loadFormWithName:(NSString *)fileName {
    if([self getFormDescriptorProperty:[NSString stringWithFormat:@"form-%@", fileName]]) {
        MFCoreLogWarn(@"The form PLIST descriptor named %@ has bean already load by the configuration handler", fileName);
        return;
    }
    
    fileName = [NSString stringWithFormat:@"form-%@", fileName];
    NSString * fileFullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    //If PLIST file repressents a form or a section, read an save it into a descriptor
    if((![fileName hasPrefix:CONST_FORM_RESOURCE_PREFIX]) && (![fileName hasPrefix:CONST_SECTION_RESOURCE_PREFIX]) && (![fileName hasPrefix:CONST_WORK_RESOURCE_PREFIX]) ) {
        MFCoreLogVerbose(@"Le fichier %@ est ignoré car ce n'est pas un formulaire ou une section", fileName);
    }
    else
    {
        NSDictionary *descriptorDictionnary = [[NSDictionary alloc] initWithContentsOfFile:fileFullPath];
        MFDescriptorCommon *descriptor = nil;
        
        if([fileName hasPrefix:CONST_FORM_RESOURCE_PREFIX])
        {
            NSString *shortFileName = [[fileName componentsSeparatedByString:@"-"] objectAtIndex:1];
            MFCoreLogInfo(@"Lecture du formulaire: %@", fileName);
            descriptor = (MFFormDescriptor*)[[[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_READER_FORM] readFromDictionary:descriptorDictionnary withFileName:shortFileName];
        }
        
        if([fileName hasPrefix:CONST_WORK_RESOURCE_PREFIX])
        {
            NSString *shortFileName = [[fileName componentsSeparatedByString:@"-"] objectAtIndex:1];
            MFCoreLogInfo(@"Lecture du formulaire: %@", fileName);
            descriptor = (MFWorkspaceDescriptor*)[[[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_READER_WORKSPACE] readFromDictionary:descriptorDictionnary withFileName:shortFileName];
        }
        
        if(descriptor !=nil)
        {
            MFCoreLogInfo(@"Mise en cache de  %@", fileName);
            MFProperty *formProperty = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_PROPERTY];
            formProperty.value = descriptor;
            formProperty.name = fileName;
            [self.configuration setValue:formProperty forKey:[formProperty getKey]];
        }
    }

}

- (void) loadForms {
    NSArray *resourcesFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"plist" inDirectory:@""];
    for(NSString *fileFullPath in resourcesFiles) {
        
        //Getting all plist files in resources
        NSString *fileName = [[fileFullPath substringFromIndex:[fileFullPath rangeOfString:@"/" options:NSBackwardsSearch].location +1] stringByDeletingPathExtension];
        
        //If PLIST file repressents a form or a section, read an save it into a descriptor
        if((![fileName hasPrefix:CONST_FORM_RESOURCE_PREFIX]) && (![fileName hasPrefix:CONST_SECTION_RESOURCE_PREFIX]) && (![fileName hasPrefix:CONST_WORK_RESOURCE_PREFIX]) ) {
            MFCoreLogVerbose(@"Le fichier %@ est ignoré car ce n'est pas un formulaire ou une section", fileName);
            continue;
        }
        else
        {
            NSDictionary *descriptorDictionnary = [[NSDictionary alloc] initWithContentsOfFile:fileFullPath];
            MFDescriptorCommon *descriptor = nil;
            
            if([fileName hasPrefix:CONST_FORM_RESOURCE_PREFIX])
            {
                NSString *shortFileName = [[fileName componentsSeparatedByString:@"-"] objectAtIndex:1];
                MFCoreLogInfo(@"Lecture du formulaire: %@", fileName);
                descriptor = (MFFormDescriptor*)[[[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_READER_FORM] readFromDictionary:descriptorDictionnary withFileName:shortFileName];
            }
            
            if([fileName hasPrefix:CONST_WORK_RESOURCE_PREFIX])
            {
                NSString *shortFileName = [[fileName componentsSeparatedByString:@"-"] objectAtIndex:1];
                MFCoreLogInfo(@"Lecture du formulaire: %@", fileName);
                descriptor = (MFWorkspaceDescriptor*)[[[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_READER_WORKSPACE] readFromDictionary:descriptorDictionnary withFileName:shortFileName];
            }
            
            if(descriptor !=nil)
            {
                MFCoreLogInfo(@"Mise en cache de  %@", fileName);
                MFProperty *formProperty = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_PROPERTY];
                formProperty.value = descriptor;
                formProperty.name = fileName;
                [self.configuration setValue:formProperty forKey:[formProperty getKey]];
            }
        }
    }
}

- (MFFormDescriptor *) getFormDescriptorProperty:(NSString *) propertyName {
    return [[self getProperty: propertyName] getFormDescriptorValue];
}

- (MFSectionDescriptor *) getSectionDescriptorProperty:(NSString *) propertyName {
    return [[self getProperty: propertyName] getSectionDescriptorValue];
}

-(MFWorkspaceDescriptor *)getWorkspaceDescriptorProperty:(NSString *)propertyName {
    return [[self getProperty: propertyName] getWorkspaceDescriptorValue];
}

#pragma mark - Visual Configuration

- (MFConfigurationUIComponent*) getVisualConfiguration:(NSString *) configurationName {
    MFConfigurationUIComponent *localConfiguration = [[MFConfigurationUIComponent alloc]init];
    localConfiguration.name = configurationName;
    return [self.configuration objectForKey:[localConfiguration getKey]];
}



-(MFConfigurationKeyboardingUIComponent *)getConfigurationKeyboardingUIComponent:(NSString *)configurationName {
    MFConfigurationUIComponent *data = [self getVisualConfiguration:configurationName];
    if([data isKindOfClass:[MFConfigurationKeyboardingUIComponent class]])
    {
        return (MFConfigurationKeyboardingUIComponent *) data;
    }
    else
    {
        return nil;
    }
}

-(MFConfigurationKeyboardingRegularExpressionUIComponent *)getConfigurationKeyboardingRegularExpressionUIComponent:(NSString *)configurationName {
    MFConfigurationUIComponent *data = [self getVisualConfiguration:configurationName];
    if([data isKindOfClass:[MFConfigurationKeyboardingRegularExpressionUIComponent class]])
    {
        return (MFConfigurationKeyboardingRegularExpressionUIComponent *) data;
    }
    else
    {
        return nil;
    }
}

-(void) loadVisualConfigurations
{
    //Récupération des fichiers de configuration visuelle
    NSArray *resourcesFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"plist" inDirectory:@""];
    for(NSString *fileFullPath in resourcesFiles) {
        
        NSString *fileName = [[fileFullPath substringFromIndex:[fileFullPath rangeOfString:@"/" options:NSBackwardsSearch].location +1] stringByDeletingPathExtension];
        
        if([fileName rangeOfString:CONST_CONFIGURATION_RESOURCE_PREFIX].location != 0) {
            MFCoreLogVerbose(@"Le fichier %@ est ignoré car ce n'est pas un fichier de configuration", fileName);
            continue;
        }
        
        [self loadVisualConfigurationFromPlist:fileFullPath];
    }
}

- (void) loadVisualConfigurationFromPlist:(NSString *) url
{
    MFCoreLogVerbose(@"Retrieve configuration from the following file : %@", url);
    NSDictionary *localConfiguration = [[NSDictionary alloc] initWithContentsOfFile:url];
    BOOL occuredError = NO;
    for (NSString *key in [localConfiguration allKeys]){
        MFCoreLogVerbose(@"Retrieve the following configuration : %@", key);
        occuredError = ![self processAttributNamed:key configurationDictionary:[localConfiguration objectForKey:key]];
    }
    if(occuredError)
    {
        @throw [NSException exceptionWithName:@"InvalidConfigurationError" reason:@"Some errors occured during configuration reading. Read application logs for more information." userInfo:nil];
    }
}

- (BOOL) processAttributNamed:(NSString *) attributName configurationDictionary:(NSDictionary *) data
{
    NSString *typeName = [data objectForKey:CONST_ATTRIBUT_TYPE_NAME];
    if(typeName)
    {
        Class cl = NSClassFromString(typeName);
        MFConfigurationUIComponent *temp = [[cl alloc] init];
        temp.name = attributName;
        MFConfigurationUIComponent *instance = [self.configuration objectForKey:[temp getKey]];
        if(!instance)
        {
            instance = temp;
            [self.configuration setObject:instance forKey:[instance getKey]];
        }
        id value = nil;
        // Indicates if an error occured during process
        BOOL errorOccured = NO;
        for (NSString *key in data.allKeys)
        {
            if(![CONST_ATTRIBUT_TYPE_NAME isEqualToString:key])
            {
                value = [data objectForKey:key];
                if(value) {
                    [instance setValue:value forKey:key];
                }
                else {
                    MFCoreLogError(@"An error occured while framework tries to use function named '%@' on configuration named '%@'",key, attributName);
                    errorOccured = YES;
                }
            }
        }
        return !errorOccured;
    }
    else
    {
        MFCoreLogError(@"Type name is missing for attribut named '%@'", attributName);
        return NO;
    }
}

- (MFConfigurationGroupDescriptor *) getConfigurationGroupDescriptor:(NSString *) configurationName;
{
    MFConfigurationUIComponent *data = [self getVisualConfiguration:configurationName];
    if([data isKindOfClass:[MFConfigurationGroupDescriptor class]])
    {
        return (MFConfigurationGroupDescriptor *) data;
    }
    else
    {
        return nil;
    }
}

@end
