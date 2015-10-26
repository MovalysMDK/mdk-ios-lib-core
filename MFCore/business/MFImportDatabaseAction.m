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


#import "MFCoreBean.h"
#import "MFCoreConfig.h"
#import "MFCoreLog.h"

#import "MFImportDatabaseAction.h"

@interface MFImportDatabaseAction ()

@property (nonatomic, strong) MFConfigurationHandler *registry;

@end


@implementation MFImportDatabaseAction
/**
 * @brief does the copy of sqlite database to the Documents directory share in Itunes. Use a file named NewZZZZ where ZZZZ is the name of database in the configuration properties list .
 */
-(id) doAction:(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher *) dispatch {
    
    MFCoreLogVerbose(@" MFImportDatabaseAction doAction %@ ", parameterIn ) ;
    NSString *destPath = [self destinationPathWithFileName:[self databaseName]];
    
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
    
    if ( [fileManager copyItemAtPath:[self databaseFileFullPath] toPath:destPath error:&error] == YES) {
        MFCoreLogVerbose(@" Copy OK in '%@'  " , destPath ) ;
    } else {
        NSString *errorText = [NSString stringWithFormat:@" Copy KO from '%@' to '%@' , '%@' , '%@'" , [self databaseFileFullPath] ,destPath , error.localizedDescription , error.localizedFailureReason ] ;
        NSError *error2 = [[NSError alloc] initWithDomain:@"com.sopraconsulting.movalys.importDatabase"
                                           code:2
                                       userInfo:@{NSLocalizedDescriptionKey : errorText}];
        [context addErrors:@[error2]];
    }
    
    // On recree le persistent store pour retrouver les données
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] MR_addAutoMigratingSqliteStoreNamed:[self databaseName]];
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] MR_addInMemoryStore];
    
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

-(NSString *)databaseFileName {
    NSString *fileName = [[self databaseFileFullPath] substringFromIndex:[[self databaseFileFullPath] rangeOfString:@"/" options:NSBackwardsSearch].location +1];
    MFCoreLogVerbose(@"  short file Name '%@'" , fileName ) ;
    return fileName;
}

-(NSString *) databaseName {
    if(!self.registry) {
        self.registry = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    }
    NSString *databaseName = [self.registry getStringProperty:MFPROP_DATABASE_NAME];
    return databaseName;
}

-(NSString *)databaseFileFullPath {
    NSString *fileFullPath = [self sourcePathFileName:[self databaseName]];
    return fileFullPath;
}


@end
