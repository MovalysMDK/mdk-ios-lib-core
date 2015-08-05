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
//  MFConfigurationHandler.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreBean.h"

#import "MFConfigurationHandler.h"
#import "MFProperty.h"
#import "MFFwkProperty.h"

@interface MFConfigurationHandler()

@end


@implementation MFConfigurationHandler

-(id)init{
    
    if (self=[super init]){
        _configuration = [[NSMutableDictionary alloc] initWithCapacity:10];
        // Framework property file loading
        [self loadPropertyFromPlist:@"Framework-config"];
        // Framework property file loading
        [self loadPropertyFromPlist:@"Framework-screens-menu"];
        // Merge with custom property file
        [self loadPropertyFromPlist:@"Project"];
    }
    
    return self;
}

#pragma mark - Loading
-(void) loadPropertyFromPlist:(NSString *) plistName{
    NSDictionary *localConfiguration = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
    MFProperty *localProperty = nil;
    MFProperty *tempProperty = nil;
    for (NSString *key in [localConfiguration allKeys]){
        
        localProperty = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_PROPERTY];
        localProperty.name = key;
        tempProperty = [localConfiguration objectForKey:[localProperty getKey]];
        if (tempProperty!=nil) {
            localProperty = tempProperty;
        }
        else
        {
            MFCoreLogInfo(@"Add property : %@",[localProperty getKey]);
            //[_configuration setValue:localProperty forKey:[localProperty getKey]];
            [_configuration setObject:localProperty forKey:[localProperty getKey]];
        }
        localProperty.value = [localConfiguration objectForKey:key];
    }
}



#pragma mark - Properties

- (MFProperty*) getProperty:(NSString *) propertyName {
    MFProperty *localProperty = [[MFProperty alloc]init];
    localProperty.name = propertyName;
    return [_configuration objectForKey:[localProperty getKey]];
}

- (BOOL) getBooleanProperty:(NSString *) propertyName withDefault:(BOOL) defaultValue {
    NSString *value = [[self getProperty: propertyName] getStringValue];
    if (value == nil) {
        return defaultValue;
    }
    else {
        if ([@"true" isEqualToString:[value lowercaseString]]) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

- (NSString *) getStringProperty:(NSString *) propertyName {
    return [[self getProperty: propertyName] getStringValue];
}

- (NSNumber *) getNumberProperty:(NSString *) propertyName {
    return [[self getProperty: propertyName] getNumberValue];
}

- (NSArray *) getArrayProperty:(NSString *) propertyName {
    return [[self getProperty: propertyName] getArray];
}

- (NSDictionary *) getDictionaryProperty:(NSString *) propertyName {
    return [[self getProperty: propertyName] getDictionaryValue];
}

- (id) getDelegateFromProperty: (NSString *) propertyName {
    return [[NSClassFromString([self getStringProperty : propertyName]) alloc] init];
}


@end
