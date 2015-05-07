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
//  MFJSONKitService.m
//  MFCore
//
//

#import <JSONKit/JSONKit.h>
#import <objc/runtime.h>
#import "MFJSONKitService.h"
#import "MFAbstractDomEntityRequestBuilder.h"
#import "MFHelperIntrospection.h"

@implementation MFJSONKitService

NSDictionary *entityBuilders;

#pragma mark serializing methods
-(NSString *) toJson:(NSObject *) object withEntityBuilders:(NSDictionary *) pEntityBuilders
{
    entityBuilders = pEntityBuilders;
    
    NSDictionary *json = [self objectToJSON:object];
    
    NSError * error = nil;
    return [json JSONStringWithOptions:JKSerializeOptionNone error:&error];
//    return @"{}";
}

-(NSArray *) arrayToJSON:(NSArray *) array
{
    NSMutableArray * ret = [[NSMutableArray alloc] init];
    
    for (NSObject * row in array) {
        if ([row isKindOfClass:[NSArray class]]) {
            [ret addObject:[self arrayToJSON:(NSArray *) row]];
        } else if ([row isKindOfClass:[NSDictionary class]]) {
            [ret addObject:[self dictionaryToJSON:(NSDictionary *) row]];
        } else {
            [ret addObject:[self objectToJSON:row]];
        }
    }
    
    return ret;
}

-(NSDictionary *) dictionaryToJSON:(NSDictionary *) object
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in object) {
        if ([object valueForKey:key]) {
            if ([[object valueForKey:key] isKindOfClass:[NSArray class]]) {
                [ret setObject:[self arrayToJSON:[object valueForKey:key]] forKey:key];
            } else if ([[object valueForKey:key] isKindOfClass:[NSNumber class]]) {
                [ret setObject:[self numberToString:[object valueForKey:key]] forKey:key];
            } else if ([entityBuilders objectForKey:key]) {
                [ret setObject:[self objectToJSON:[object valueForKey:key]] forKey:key];
            } else {
                [ret setObject:[object valueForKey:key] forKey:key];
            }
        }
    }
    
    return ret;
}

-(NSDictionary *) objectToJSON:(NSObject *) object
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    
    NSDictionary *objectProperties = [MFHelperIntrospection classPropertiesFor:[object class]];
    
    for (NSString *key in objectProperties) {
        if ([object valueForKey:key]) {
            if ([[object valueForKey:key] isKindOfClass:[NSArray class]]) {
                [ret setObject:[self arrayToJSON:[object valueForKey:key]] forKey:key];
            } else if ([[object valueForKey:key] isKindOfClass:[NSNumber class]]) {
                [ret setObject:[self numberToString:[object valueForKey:key]] forKey:key];
            } else if ([entityBuilders objectForKey:key]) {
                [ret setObject:[self objectToJSON:[object valueForKey:key]] forKey:key];
            } else {
                [ret setObject:[object valueForKey:key] forKey:key];
            }
        }
    }
    
    return ret;
}

-(NSString *) numberToString:(id) number
{
    if ([NSStringFromClass([number class]) isEqualToString:@"__NSCFBoolean"]) {
        return [self booleanToString:[number boolValue]];
    } else {
        return [number stringValue];
    }
}

/**
 * Pour que cette partie fonctionne, les propriétés destinées à être gérées comme des booléens devront :
 * - être de type NSNumber
 * - être alimentées avec les valeurs @(YES) ou @(NO)
 */
-(NSString *) booleanToString:(BOOL) boolean
{
    return boolean ? @"true" : @"false";
}

#pragma mark parsing methods
-(id) fromJson:(NSString *) json
{
    if (json)
        return [json objectFromJSONString];
    else
        return nil;
}

@end
