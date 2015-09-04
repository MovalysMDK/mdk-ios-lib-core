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


#import "MFCoreLog.h"
#import "MFCoreBean.h"
#import "MFCoreConfig.h"
#import "MFCoreInit.h"
#import "MFCoreApplication.h"

#import "MFResetDatabaseAction.h"

@implementation MFResetDatabaseAction

/**
 * @brief reset the sqlite database and all the persistent store
 */
-(id) doAction:(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher *) dispatch {
    
    MFCoreLogVerbose(@" MFResetDatabaseAction doAction  parameterIn '%@' ", parameterIn ) ;
    
    NSError *error ;
    [MagicalRecord cleanUp];
    
    MFConfigurationHandler *confHandler = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    NSString *databaseName = [confHandler getStringProperty:MFPROP_DATABASE_NAME];
    
    NSString *destPath = [self destinationPathWithFileName:databaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:destPath] == YES) {
        if ( [fileManager removeItemAtPath:destPath error:&error] == YES) {
            MFCoreLogVerbose(@" Delete OK  '%@' " , destPath   ) ;
        }else {
            NSString *errorText = [NSString stringWithFormat:@" Delete KO  '%@' '%@' , '%@'" , destPath , error.localizedDescription , error.localizedFailureReason] ;
            NSError *error2 = [[NSError alloc] initWithDomain:@"com.sopraconsulting.movalys.resetDatabase"
                                                    code:2
                                                    userInfo:@{NSLocalizedDescriptionKey : errorText}];
            [context addErrors:@[error2]];
        }
    }    

    // on recrée la base de données 
    [[MFStarter getInstance] setFirstLaunching:YES];
    id<MFRunInitProtocol> subStarter = nil;
    subStarter = [[MFBeanLoader getInstance] getBeanWithKey:@"MFCoreDataRunInit"];
    
    BOOL isFirstLaunch = [[MFStarter getInstance] isFirstLaunching];
    [subStarter startUsingContext: context firstLaunch:isFirstLaunch];

    // on lance le chargement avec les données initiales
    subStarter = [[MFBeanLoader getInstance] getBeanWithKey:@"MFFwkCsvLoaderRunInit"];
    [subStarter startUsingContext:context firstLaunch:isFirstLaunch];
    subStarter = [[MFBeanLoader getInstance] getBeanWithKey:@"MFProjectCsvLoaderRunInit"];
    [subStarter startUsingContext: context firstLaunch:isFirstLaunch];
    subStarter = [[MFBeanLoader getInstance] getBeanWithKey:@"MFUserCsvLoaderRunInit"];
    [subStarter startUsingContext: context firstLaunch:isFirstLaunch];
    [[MFStarter getInstance] setFirstLaunching:NO ];
    
    return nil ;
}

-(NSString *) destinationPathWithFileName:(NSString *) databaseName {
    
    NSString *destPath =[[NSPersistentStore MR_urlForStoreName:databaseName] path];    
    MFCoreLogVerbose(@" %@ destPath " , destPath ) ;    
    return destPath ;
}

- (BOOL)isReadOnly {
    return NO;
}

@end
