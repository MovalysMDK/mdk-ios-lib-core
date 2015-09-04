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
//  MFDataLoaderParameter.m
//  MFCore
//
//

#import "MFDataLoaderActionParameter.h"

@implementation MFDataLoaderActionParameter

@synthesize loadingOptions;
@synthesize loadedData;
@synthesize dataIdentifiers;
@synthesize dataLoaderClassName;

-(id) initWithDataIds:(NSArray *)dataIds andDataLoader:(NSString *)dataLoader
{
    self = [super init];
    if (self) {
        self.dataIdentifiers = dataIds ;
        self.dataLoaderClassName = dataLoader;
    }
    
    return self;
}

@end
