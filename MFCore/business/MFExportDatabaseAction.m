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

#import "MFExportDatabaseAction.h"

@interface MFExportDatabaseAction ()

@property (nonatomic, strong) MFConfigurationHandler *registry;

@end

@implementation MFExportDatabaseAction

/**
 * @brief does the copy of sqlite database to the Documents directory share in Itunes
 * Delete the sqlite persistent store to write on fill (vacuum) and recreate a new persistent store
 */
-(id) doAction:(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher *) dispatch {
    
    MFCoreLogVerbose(@" MFExportDatabaseAction.h doAction parameterIn '%@' ", parameterIn ) ;
    NSError *error;
    // on supprime le persistent store pour que le fichier sqlite ne soit plus ouvert et qu il soit complet
    
    NSArray *persistentStores = [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] persistentStores] ;
    if ( [persistentStores count] > 0){
        NSPersistentStore  *persistentStore = [persistentStores objectAtIndex:0];
        [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] removePersistentStore:persistentStore error:&error];
        if (error) {
            MFCoreLogInfo(@"error removing persistent store %@ %@", error , [error userInfo]);
        }
    }
    
    NSString *destPath = [self destinationPathWithFileName:[self databaseFileName]];
    
    if ( [[NSFileManager defaultManager] copyItemAtPath:[self databaseFileFullPath] toPath:destPath error:&error] == YES) {
        MFCoreLogVerbose(@" Export OK dans '%@'  " , destPath ) ;
        
    } else {
        NSString *errorText = [NSString stringWithFormat:@" Export KO from '%@' to '%@' , '%@' , '%@'" , [self databaseFileFullPath] ,destPath , error.localizedDescription , error.localizedFailureReason ];
        NSError *error2 = [[NSError alloc] initWithDomain:@"com.sopraconsulting.movalys.exportDatabase"
                                                     code:2
                                                 userInfo:@{NSLocalizedDescriptionKey : errorText}];
        [context addErrors:@[error2]];
    }
    
    // On recree le persistent store pour retrouver les données
    [[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] MR_addAutoMigratingSqliteStoreNamed:[self databaseName]];
    
    return nil ;
}
-(NSString *) sourcePathFileName:databaseName {
    // find the source file to copy
    NSString *fileFullPath =[[NSPersistentStore MR_urlForStoreName:databaseName] path];
    MFCoreLogVerbose(@" %@ fileFullPath " , fileFullPath ) ;
    return fileFullPath ;
}

-(NSString *) destinationPathWithFileName:(NSString *) fileName{
    NSDateFormatter *datetimeFormatter = [[NSDateFormatter alloc] init] ;
    [datetimeFormatter setLocale:[NSLocale currentLocale]];
    [datetimeFormatter setDateFormat:@"yyyy'-'MM'-'dd'-'HH'-'mm'-'ss'-export-'"];
    [datetimeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *nowString = [datetimeFormatter stringFromDate:[[NSDate alloc] init] ] ;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0] ;
    MFCoreLogVerbose(@" %@ documentsDirectory " , documentsDirectory ) ;
    
    NSString *destPath = [documentsDirectory stringByAppendingPathComponent:[nowString stringByAppendingString:fileName]];
    
    MFCoreLogVerbose(@" %@ destPath " , destPath ) ;
    return destPath ;
}

-(NSString *)databaseFileName {
    NSString *databaseName = [self databaseName];
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
