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
//  MObjectToSynchronizeDao.m
//  MFCore
//
//

#import "MObjectToSynchronize+Factory.h"
#import "MFCsvLoaderHelper.h"
#import "MFApplication.h"
#import "MFBeansKeys.h"

@implementation MObjectToSynchronize (Factory)

+ (MObjectToSynchronize *) MF_createMObjectToSynchronizeInContext:(id<MFContextProtocol>)context
{
    MObjectToSynchronize *newInstance =
    (MObjectToSynchronize *)[NSEntityDescription insertNewObjectForEntityForName:MObjectToSynchronizeProperties.EntityName
                                             inManagedObjectContext:context.entityContext];
    
    return newInstance;
}


+ (MObjectToSynchronize *) MF_createMObjectToSynchronizeWithDictionary:(NSDictionary *)dictionary inContext:(id<MFContextProtocol>)context
{
    MFCsvLoaderHelper *csvHelper = [[MFApplication getInstance] getBeanWithKey:BEAN_KEY_CSV_LOADER_HELPER];
    MObjectToSynchronize *newInstance = [self MF_createMObjectToSynchronizeInContext:context];
    
    // identifier attribute
    newInstance.identifier = [csvHelper convertCsvStringToInteger:
                              [dictionary objectForKey:@"identifier" ]];
        
    // attributes
    newInstance.objectId = [dictionary objectForKey:@"objectId" ];
    newInstance.objectName = [dictionary objectForKey:@"objectName" ];
    
    return newInstance;
}

@end
