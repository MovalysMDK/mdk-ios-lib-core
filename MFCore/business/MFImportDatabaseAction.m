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
//  MFImportDatabaseAction.m
//  MFCore
//
//

#import "MFCoreBean.h"
#import "MFCoreConfig.h"
#import "MFCoreLog.h"

#import "MFImportDatabaseAction.h"

@implementation MFImportDatabaseAction
/**
 * @brief does the copy of sqlite database to the Documents directory share in Itunes. Use a file named NewZZZZ where ZZZZ is the name of database in the configuration properties list .
 */
-(id) doAction:(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher *) dispatch {
    
    MFCoreLogVerbose(@" MFImportDatabaseAction doAction %@ ", parameterIn ) ;
    MFConfigurationHandler *confHandler = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    NSString *databaseName = [confHandler getStringProperty:MFPROP_DATABASE_NAME];

    NSString *fileFullPath = [self sourcePathFileName:databaseName];
    
    NSString *destPath = [self destinationPathWithFileName:databaseName];
    /*
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:destPath]) {
        
        MFCoreDataHelper *coreDataHelper = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER];
        //coreDataHelper.sqliteStore
        if ( [fileManager removeItemAtPath:destPath error:&error]) {
            MFCoreLogVerbose(@" Delete KO  '%@' , '%@' , '%@'" , destPath , error.localizedDescription , error.localizedFailureReason ) ;
        }else {
            MFCoreLogVerbose(@" Delete OK  '%@' " , destPath );
        }
    }
    if ( [fileManager copyItemAtPath:fileFullPath toPath:destPath error:&error] == YES) {
        MFCoreLogVerbose(@" Export OK dans '%@'  " , destPath ) ;
    } else {
        MFCoreLogVerbose(@" Export KO from '%@' to '%@' , '%@' , '%@'" , fileFullPath ,destPath , error.localizedDescription , error.localizedFailureReason ) ;
    }
     
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed: databaseName]; 
    */
    NSError* error ;
    NSArray* persistenceStores =[[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] persistentStores];
    for ( NSPersistentStore *store in persistenceStores ){
        [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] removePersistentStore:store error:&error];
        if (error) {
            MFCoreLogInfo(@"error removing persistent store %@ %@", error , [error userInfo]);
        }
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:destPath] == YES) {
        if ( [fileManager removeItemAtPath:destPath error:&error] == YES) {
            MFCoreLogVerbose(@" Delete OK  '%@' " , destPath   ) ;
        }else {
            MFCoreLogInfo(@" Delete KO  '%@' '%@' , '%@'" , destPath , error.localizedDescription , error.localizedFailureReason);
        }
    }
    
    if ( [fileManager copyItemAtPath:fileFullPath toPath:destPath error:&error] == YES) {
        MFCoreLogVerbose(@" Copy OK in '%@'  " , destPath ) ;
    } else {
        NSString *errorText = [NSString stringWithFormat:@" Copy KO from '%@' to '%@' , '%@' , '%@'" , fileFullPath ,destPath , error.localizedDescription , error.localizedFailureReason ] ;
        NSError *error2 = [[NSError alloc] initWithDomain:@"com.sopraconsulting.movalys.importDatabase"
                                           code:2
                                       userInfo:@{NSLocalizedDescriptionKey : errorText}];
        [context addErrors:@[error2]];
    }
    
    // On recree le persistent store pour retrouver les données
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] MR_addAutoMigratingSqliteStoreNamed:databaseName];
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] MR_addInMemoryStore];
    

    /*
    // then update
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent: @"NewAppDatabase.sqlite"];
    
    // add clean store file back by adding a new persistent store with the same store URL
    if (![[NSPersistentStoreCoordinator defaultStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:nil
                                                               error:&error]) {
        MFCoreLogError(@"failed to add db file, error %@, %@", error, [error userInfo]);
    }*/
    
    return nil ;
}
-(NSString *) sourcePathFileName:(NSString *) databaseName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0] ;
    MFCoreLogVerbose(@" %@ documentsDirectory " , documentsDirectory ) ;
    
    //MFConfigurationHandler *confHandler = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];

    NSString *srcPath = [documentsDirectory stringByAppendingPathComponent:[@"New" stringByAppendingString:databaseName]];
    
    MFCoreLogVerbose(@" %@ srcPath " , srcPath ) ;
    
    return srcPath ;
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
