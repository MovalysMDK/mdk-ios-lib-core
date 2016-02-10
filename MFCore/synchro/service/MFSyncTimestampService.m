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
//  MFSyncTimestampService.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFSyncTimestampService.h"
#import "MParameter+Dao.h"
#import "MParameter+Factory.h"

NSString *const SYNCHRO_TIMESTAMP_PREFIX = @"synchro_timestamp_";

@implementation MFSyncTimestampService

-(NSDictionary *) getSyncTimestampsWithContext:(id<MFContextProtocol>) context
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSArray *timeStampsList = [MParameter MF_findByNameLike:SYNCHRO_TIMESTAMP_PREFIX inContext:context];
    
    for (MParameter *timeStamp in timeStampsList) {
        [result setObject:timeStamp.value forKey:[timeStamp.name substringFromIndex:[SYNCHRO_TIMESTAMP_PREFIX length]]];
    }
    
    return result;
}

-(void) saveSyncTimestamps:(NSDictionary *) timeStampsToSave withContext:(id<MFContextProtocol>) context
{
    NSMutableDictionary *existingTimeStamps = [[NSMutableDictionary alloc] init];
    
    NSArray *timeStampsList = [MParameter MF_findByNameLike:SYNCHRO_TIMESTAMP_PREFIX inContext:context];
    
    for (MParameter *timeStamp in timeStampsList) {
        [existingTimeStamps setObject:timeStamp forKey:[timeStamp.name substringFromIndex:[SYNCHRO_TIMESTAMP_PREFIX length]]];
    }
    
    for (NSString *key in timeStampsToSave) {
        MParameter *param = [existingTimeStamps objectForKey:key];
        
        if (param == nil) {
            param = [MParameter MF_createMParameterInContext:context];
            param.name = [NSString stringWithFormat:@"%@%@", SYNCHRO_TIMESTAMP_PREFIX, key];
        }
        
        param.value = [NSString stringWithFormat:@"%@",[timeStampsToSave objectForKey:key]];
    }
}

@end
