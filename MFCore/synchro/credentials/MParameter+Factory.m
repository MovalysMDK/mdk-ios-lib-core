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
//  MParameter+Factory.m
//  MFCore
//
//

#import "MParameter+Factory.h"
#import "MFCsvLoaderHelper.h"
#import "MFBeansKeys.h"
#import "MFBeanLoader.h"

@implementation MParameter (Factory)

+ (MParameter *) MF_createMParameterInContext:(id<MFContextProtocol>)context
{
    MParameter *newInstance =
    (MParameter *)[NSEntityDescription insertNewObjectForEntityForName:MParameterProperties.EntityName
                                             inManagedObjectContext:context.entityContext];
    
    return newInstance;
}


+ (MParameter *) MF_createMParameterWithDictionary:(NSDictionary *)dictionary inContext:(id<MFContextProtocol>)context
{
    if ([dictionary objectForKey:@"value" ] != nil) {
        MFCsvLoaderHelper *csvHelper = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CSV_LOADER_HELPER];
        MParameter *newInstance = [self MF_createMParameterInContext:context];
        
        // identifier attribute
        if ([dictionary objectForKey:@"identifier" ]) {
            newInstance.identifier = [csvHelper convertCsvStringToInteger:
                                      [dictionary objectForKey:@"identifier" ]];
        } else
            newInstance.identifier = [NSNumber numberWithInt:1];
        
        // attributes
        newInstance.name = [dictionary objectForKey:@"name" ];
        newInstance.value = [dictionary objectForKey:@"value" ];
        
        return newInstance;
    } else
        return nil;
}

@end
