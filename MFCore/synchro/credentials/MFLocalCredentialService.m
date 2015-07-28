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
//  MFLocalCredentialService.m
//  MFCore
//
//

#import "MFLocalCredentialService.h"
#import "MFSynchroProperty.h"
#import "MFConfigurationHandler.h"
#import "MParameter+Dao.h"
#import "MParameter+Factory.h"
#import "MFAESUtil.h"
#import "MFBeanLoader.h"
#import "MFBeansKeys.h"
#import "MFApplication.h"

NSString *const PREVIOUS_LOGIN_PARAMETER  = @"previous-login" ;
NSString *const PREVIOUS_RESOURCE_PARAMETER  = @"resourceId" ;
NSString *const PREVIOUS_SYNC_DATE_PARAMETER  = @"previous-sync-date" ;
int const MILLISECONDS_IN_ONE_DAY  = 86400000 ;

@implementation MFLocalCredentialService

- (IdentifyResult) doIdentifyWithLogin:(NSString *) login withContext: (id<MFContextProtocol>) context
{
    IdentifyResult result = Identified_KO;
    
    BOOL identified = false;
    
    MFConfigurationHandler* config = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    
    if ([config getBooleanProperty:sync_mock_mode withDefault:NO] && [[config getNumberProperty:sync_mock_testid] isEqualToNumber:[NSNumber numberWithInt:408]]) { // 408 : Request Timeout (HTTP/1.1 - RFC 2616)
        result = Identified_KOCauseDate;
    } else {
        MParameter *param = [MParameter MF_findByName:PREVIOUS_LOGIN_PARAMETER inContext:context];
        identified = param == nil || (param != nil && [login isEqualToString:[param value]]);
        
        if (identified) {
            param = [MParameter MF_findByName:PREVIOUS_SYNC_DATE_PARAMETER inContext:context];
            identified = (param != nil);
            
            if (identified) {
                NSNumber *maxTimeWithoutSync = [config getNumberProperty:synchronization_max_time_without_sync];
                
                if (maxTimeWithoutSync > 0){
                    identified = ([[NSDate date] timeIntervalSince1970] * 1000.0) < [param.value doubleValue] + [maxTimeWithoutSync doubleValue];
                }
                if (identified) {
                    param = [MParameter MF_findByName:PREVIOUS_RESOURCE_PARAMETER inContext:context];
                    identified = (param != nil);
                    
                    if (identified) {
                        [[MFApplication getInstance] setCurrentUserResource:[[MFAESUtil decryptText:param.value] integerValue]];
                        result = Identified_OK;
                    }
                } else {
                    result = Identified_KOCauseDate;
                }
            }
        }
    }
    
    return result;
}

- (void) storeCredentialsWithLogin:(NSString *) login withResource:(long) resource withContext: (id<MFContextProtocol>) context
{
    long currentResource = [[MFApplication getInstance] getCurrentUserResource];
    
    // on supprime la dernière date de synchronisation
    [MParameter MF_deleteByName:PREVIOUS_SYNC_DATE_PARAMETER inContext:context];
    
    // on met à jour la date de dernière synchronisation
    [MParameter MF_createMParameterWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:PREVIOUS_SYNC_DATE_PARAMETER, MParameterProperties.name,[NSString stringWithFormat:@"%f",([[NSDate date] timeIntervalSince1970] * 1000.0)], MParameterProperties.value, nil] inContext:context];
    
    // si la resource de sunchro a changée, on et à jour les données
    if (currentResource < 1 || (resource > 0 && resource != currentResource)) {
        [MParameter MF_deleteByName:PREVIOUS_LOGIN_PARAMETER inContext:context];
        [MParameter MF_deleteByName:PREVIOUS_RESOURCE_PARAMETER inContext:context];
        
        [MParameter MF_createMParameterWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:PREVIOUS_LOGIN_PARAMETER, MParameterProperties.name, login, MParameterProperties.value, nil] inContext:context];
        
        [MParameter MF_createMParameterWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:PREVIOUS_RESOURCE_PARAMETER, MParameterProperties.name, [MFAESUtil encryptText:[NSString stringWithFormat:@"%ld",resource]], MParameterProperties.value, nil] inContext:context];
        
        [[MFApplication getInstance] setCurrentUserResource:resource];
    }
}

- (void) deleteLocalCredentialsWithContext:(id<MFContextProtocol>) context
{
    [MParameter MF_deleteByName:PREVIOUS_LOGIN_PARAMETER inContext:context];
    [MParameter MF_deleteByName:PREVIOUS_RESOURCE_PARAMETER inContext:context];
    [MParameter MF_deleteByName:PREVIOUS_SYNC_DATE_PARAMETER inContext:context];
}

@end
