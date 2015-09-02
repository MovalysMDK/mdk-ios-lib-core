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
//  MFProperty.m
//  MFCore
//
//

#import "MFProperty.h"


@implementation MFProperty

-(id)init{
    if (self=[super init]){
        self.type = CONF_PROPERTY;
    }
    return self;
}

-(NSNumber *) getNumberValue {
    if ([self.value isKindOfClass:[NSNumber class]]) {
        return (NSNumber* )self.value;
    }
    else {
        return nil;
    }
}

-(NSString *) getStringValue {
    if ([self.value isKindOfClass:[NSString class]]) {
        return (NSString *)self.value;
    }
    else {
        return nil;
    }
}

-(NSArray *) getArray {
    if ([self.value isKindOfClass:[NSArray class]]) {
        return (NSArray*)self.value;
    }
    else {
        return nil;
    }
}

-(NSDictionary*) getDictionaryValue {
    if ([self.value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)self.value;
    }
    else {
        return nil;
    }
}


-(BOOL) getBOOLValue
{
    if([self.value isKindOfClass:[NSNumber class]]) {
        return (BOOL) [self.value boolValue];
    }
    return self.value;
}

@end
