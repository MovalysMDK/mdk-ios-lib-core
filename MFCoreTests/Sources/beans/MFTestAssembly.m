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
//  MFFrameworkComponentsAssembly.m
//  lemon
//
//  Created by Movalys MDK.
//  Copyright (c) 2014 Sopra Consulting. All rights reserved.
//

#import "MFTestAssembly.h"
#import "MFCsvLoaderHelper.h"
#import "MFUserCsvLoaderRunInit.h"
#import "MFFwkCsvLoaderRunInit.h"
#import "MFProjectCsvLoaderRunInit.h"
#import "MFExportDatabaseAction.h"
#import "MFImportDatabaseAction.h"
#import "MFResetDatabaseAction.h"
#import "MFExportLogsAction.h"
#import "MFLoggingFormatter.h"
#import "MFSyncTimestampService.h"
#import "MFObjectToSyncService.h"
#import "MFRestConnectionConfig.h"
#import "MFSynchronizationAction.h"
#import "MFJSONKitService.h"
#import "MFBasicRestAuth.h"
#import "MFLocalCredentialService.h"
#import "MFRestInvoker.h"
#import "MFSecurityHelper.h"
#import "MFKeychainRunInit.h"
#import "MFEmptyAction.h"
#import "MFURL.h"

/**
 * @brief Class containing the beans managed by Typhoon used in MDK
 *
 * DO NOT MODIFIED THIS CLASS : You must overload this class in MFFrameworkExtendedComponentsAssembly
 *
 **/
@implementation MFTestAssembly


- (void)registerComponentsInPrototypes:(NSMutableDictionary *)prototypes andSingletons:(NSMutableDictionary *)singletons {
    
    [singletons setObject:[MFContextFactory class] forKey:@"MFContextFactory"];
    [singletons setObject:[MFContextFactory class] forKey:@"MFContextFactoryProtocol"];
    [singletons setObject:[MFEmptyAction class] forKey:@"MFEmptyAction"];
    [singletons setObject:[MFCsvLoaderHelper class] forKey:@"csvLoaderHelper"];
    [singletons setObject:[MFSecurityHelper class] forKey:@"MFSecurityHelper"];

    [prototypes setObject:[MFContext class] forKey:@"MFContext"];
    [prototypes setObject:[MFContext class] forKey:@"MFContextProtocol"];
    [prototypes setObject:[MFWaitRunInit class] forKey:@"MFWaitRunInit"];
    [prototypes setObject:[MFKeychainRunInit class] forKey:@"MFKeychainRunInit"];
    [prototypes setObject:[MFUserCsvLoaderRunInit class] forKey:@"MFUserCsvLoaderRunInit"];
    [prototypes setObject:[MFFwkCsvLoaderRunInit class] forKey:@"MFFwkCsvLoaderRunInit"];
    [prototypes setObject:[MFProjectCsvLoaderRunInit class] forKey:@"MFProjectCsvLoaderRunInit"];
    [prototypes setObject:[MFLoggingFormatter class] forKey:@"loggingFormatter"];
    [prototypes setObject:[MFURL class] forKey:@"url"];

    [prototypes setObject:[MFExportDatabaseAction class] forKey:@"MFExportDatabaseAction"];
    [prototypes setObject:[MFImportDatabaseAction class] forKey:@"MFImportDatabaseAction"];
    [prototypes setObject:[MFResetDatabaseAction class] forKey:@"MFResetDatabaseAction"];
    [prototypes setObject:[MFExportLogsAction class] forKey:@"MFExportLogsAction"];
    [prototypes setObject:[MFSyncTimestampService class] forKey:@"MFSyncTimestampService"];
    [prototypes setObject:[MFObjectToSyncService class] forKey:@"MFObjectToSyncService"];
    [prototypes setObject:[MFRestConnectionConfig class] forKey:@"MFRestConnectionConfig"];
    [prototypes setObject:[MFSynchronizationAction class] forKey:@"MFSynchronizationAction"];
    [prototypes setObject:[MFJSONKitService class] forKey:@"MFJsonMapperServiceProtocol"];
    [prototypes setObject:[MFBasicRestAuth class] forKey:@"MFAbstractRestAuth"];
    [prototypes setObject:[MFLocalCredentialService class] forKey:@"MFLocalCredentialService"];
    [prototypes setObject:[MFRestInvoker class] forKey:@"RestInvoker"];
    
    
    
}

@end
