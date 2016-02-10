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
//  MFReaderAttributeNameDictionary.m
//  MFCore
//
//

#import "MFCoreLog.h"

#import "MFReaderAttributeNameDictionary.h"

@implementation MFReaderAttributeNameDictionary

+(NSMutableDictionary *) getDictionary
{
    static NSMutableDictionary *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = [[NSMutableDictionary alloc]init];
    });
    return dictionary;
}

+(BOOL) storeAndValidName:(NSString *) name
{
    // We check if the name already exists.
    NSNumber *currentValue = [[self getDictionary] objectForKey:name];
    if(currentValue == nil)
    {
        // The name doesn't exist : we register it
        [[self getDictionary] setObject:[NSNumber numberWithInt:1] forKey:name];
        return YES;
    }
    else
    {
        // The name already exists : we indicate descriptor number which have the same name.
        NSNumber *newValue = [NSNumber numberWithInt:([currentValue intValue] + 1)];
        [[self getDictionary] setObject:newValue forKey:name];
        [NSException raise:@"Invalid forms" format:@"2 elements have the same name : %@", name];
        return NO;
    }
}

+(void) reset
{
    [[self getDictionary] removeAllObjects];
}

@end
