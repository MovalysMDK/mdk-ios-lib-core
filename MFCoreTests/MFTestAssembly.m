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
#import "MFLoadFormRunInit.h"
#import "MFLoadVisualConfigurationRunInit.h"
#import "MFExportDatabaseAction.h"
#import "MFImportDatabaseAction.h"
#import "MFResetDatabaseAction.h"
#import "MFExportLogsAction.h"
#import "MFReaderSection.h"
#import "MFLoggingFormatter.h"
#import "MFReaderColumn.h"
#import "MFReaderForm.h"
#import "MFReaderWorkspace.h"
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
    [singletons setObject:[MFConfigurationHandler class] forKey:@"configurationHandler"];
    [singletons setObject:[MFCsvLoaderHelper class] forKey:@"csvLoaderHelper"];
    [singletons setObject:[MFSecurityHelper class] forKey:@"MFSecurityHelper"];
    
    [prototypes setObject:[MFContext class] forKey:@"MFContext"];
    [prototypes setObject:[MFContext class] forKey:@"MFContextProtocol"];
    [prototypes setObject:[MFWaitRunInit class] forKey:@"MFWaitRunInit"];
    [prototypes setObject:[MFKeychainRunInit class] forKey:@"MFKeychainRunInit"];
    [prototypes setObject:[MFUserCsvLoaderRunInit class] forKey:@"MFUserCsvLoaderRunInit"];
    [prototypes setObject:[MFFwkCsvLoaderRunInit class] forKey:@"MFFwkCsvLoaderRunInit"];
    [prototypes setObject:[MFProjectCsvLoaderRunInit class] forKey:@"MFProjectCsvLoaderRunInit"];
    [prototypes setObject:[MFLoadFormRunInit class] forKey:@"MFLoadFormRunInit"];
    [prototypes setObject:[MFLoadVisualConfigurationRunInit class] forKey:@"MFLoadVisualConfigurationRunInit"];
    [prototypes setObject:[MFFieldDescriptor class] forKey:@"fieldDescriptor"];
    [prototypes setObject:[MFSectionDescriptor class] forKey:@"sectionDescriptor"];
    [prototypes setObject:[MFFormDescriptor class] forKey:@"formDescriptor"];
    [prototypes setObject:[MFGroupDescriptor class] forKey:@"groupDescriptor"];
    [prototypes setObject:[MFWorkspaceDescriptor class] forKey:@"workspaceDescriptor"];
    [prototypes setObject:[MFColumnDescriptor class] forKey:@"columnDescriptor"];
    [prototypes setObject:[MFReaderForm class] forKey:@"formReader"];
    [prototypes setObject:[MFReaderSection class] forKey:@"sectionReader"];
    [prototypes setObject:[MFReaderWorkspace class] forKey:@"workspaceReader"];
    [prototypes setObject:[MFReaderColumn class] forKey:@"columnReader"];
    [prototypes setObject:[MFLoggingFormatter class] forKey:@"loggingFormatter"];
    [prototypes setObject:[MFURL class] forKey:@"url"];
    [prototypes setObject:[MFProperty class] forKey:@"property"];

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
