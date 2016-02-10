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
//  MFAbstractDataLoader.m
//  MFCore
//
//

#import <objc/runtime.h>

#import "MFAbstractDataLoader.h"

@interface MFAbstractDataLoader()

@property (nonatomic) id managedEntity;

@end

@implementation MFAbstractDataLoader

NSString *const MFAbstractDataLoader_MFilterParametersDepth2     = @"filterParametersDepth2";
NSString *const MFAbstractDataLoader_MFilterParametersDepth3     = @"filterParametersDepth3";
NSString *const MFAbstractDataLoader_MParametersTag              = @"parameters";

@synthesize dataIdentifiers;
@synthesize loadingOptions;

-(id)load:(id<MFContextProtocol>)context {
    [self reload:context];
    return context;
}

-(void) reload:(id<MFContextProtocol>)context  {
    [self reload:context withNotification:YES] ;
}

-(void) reload:(id<MFContextProtocol>)context withNotification:(BOOL)doNotification  {
    if ( doNotification ) {
        [self notifyOfReloadEnd:context];
    }
}

-(void) notifyOfReloadEnd:(id<MFContextProtocol>)context  {
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass(self.class) object:self] ;
}


#pragma mark -Searching/filter methods
/*!
 * @brief Builds a dictionary containing the value of filters for depth 2 and 3.
 * Each value is put in a array, and this array is put in the returned dictionary.
 * @return A dictionary containing value of filters for depth 2 and 3
 */
-(NSDictionary *)getFilterParameters {
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    [returnDictionary setObject:[self getFiltersArrayForDepth:MFAbstractDataLoader_MFilterParametersDepth2] forKey:MFAbstractDataLoader_MFilterParametersDepth2];
    [returnDictionary setObject:[self getFiltersArrayForDepth:MFAbstractDataLoader_MFilterParametersDepth3] forKey:MFAbstractDataLoader_MFilterParametersDepth3];
    
    return returnDictionary;
}

/*!
 * @brief Buils an array containing value of filters for a specific depth
 * @param depth A const String that indicates the value of the depth (2 or 3).
 * @return An array containing the an array containing value of filters for the specified depth
 */
-(NSArray *) getFiltersArrayForDepth:(NSString *)depth {
    NSMutableArray *returnArray = [NSMutableArray array];
    NSArray *filtersName = nil;;
    if([depth isEqualToString:MFAbstractDataLoader_MFilterParametersDepth2]) {
        filtersName = [self getFilterParametersForDepth2];
    }
    else {
        filtersName = [self getFilterParametersForDepth3];
    }
    if(filtersName) {
        for(NSString *key in filtersName) {
            id filterValue = [self valueForKey:key];
            if(filterValue) {
                [returnArray addObject:filterValue];
            }
        }
    }
    return returnArray;
}


-(NSArray *)getFilterParametersForDepth2 {
    return @[];
}

-(NSArray *)getFilterParametersForDepth3 {
    return @[];
}

-(void) setEntity:(id)entity {
    _managedEntity = entity;
}

-(id) getEntity {
    return _managedEntity;
}

@end
