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
//  CoreDataRunInit.m
//  MFCore
//
//

#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "MFCoreBean.h"
#import "MFCoreConfig.h"

#import "MFCoreDataRunInit.h"
#import "MFCoreDataHelper.h"
#import "MFApplication+CoreData.h"

@interface MFCoreDataRunInit()

/**
 * @brief An instance of MFConfigurationHandler
 */
@property (nonatomic, strong) MFConfigurationHandler *configurationHandler;

/**
 * @brief An instance of MFCoreDataHelper
 */
@property (nonatomic, strong) MFCoreDataHelper *coreDataHelper;

@end

@implementation MFCoreDataRunInit


#pragma mark - Initialization
- (void) startUsingContext:(id<MFContextProtocol>)mfContext firstLaunch:(BOOL)firstLaunch {
    
    //Initialisation de CoreData avec MagicalRecord
    MFCoreLogInfo(@"init magical record");
    _configurationHandler = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    NSString *databaseName = [_configurationHandler getStringProperty: MFPROP_DATABASE_NAME];
    NSString *movalysDefaultModelName = [_configurationHandler getStringProperty: MFPROP_MOVALYS_MODEL_NAME];
    
    MFCoreLogInfo(@"  database name: %@", databaseName);
    [MFCoreDataRunInit setupPersistentStoresWithDbName:databaseName andMovalysDefaultModelName:movalysDefaultModelName];
    
    MFCoreLogInfo(@"count persistent stores: %lu", (unsigned long)[[[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] persistentStores] count]);
    
    NSPersistentStore *sqliteStore = [[[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] persistentStores] objectAtIndex:0];
    /*NSPersistentStore *memoryStore = [[[NSPersistentStoreCoordinator MR_defaultStoreCoordinator] persistentStores] objectAtIndex:1];*/
    
    MFCoreDataHelper *coreDataHelper = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER];
    [coreDataHelper registerStore:sqliteStore];
    
    MFCoreLogInfo(@"starter mfContext.entityContext = [NSManagedObjectContext MR_defaultContext]");
    mfContext.entityContext = [[MFApplication getInstance] movalysContext];

    MFCoreLogInfo(@"start %@", mfContext.entityContext);
    [self initSequencesUsingContext: mfContext withMovalysModelName:[movalysDefaultModelName stringByAppendingString:@".momd"]];
    
    
    MFCoreLogInfo(@"init magical record done");
    
    //    [((MFAppDelegate *)[[UIApplication sharedApplication] delegate]) initializeMenuController];
}


- (void) initSequencesUsingContext:(id<MFContextProtocol>) mfContext withMovalysModelName:(NSString *)modelName {
    
    MFCoreLogInfo(@"starter init sequences");
    
    // Get default context
    NSManagedObjectContext *context = mfContext.entityContext;
    
    // Find last ids for each entity
    NSManagedObjectModel *myManagedObjectModel = [NSManagedObjectModel MR_managedObjectModelNamed:modelName];
    MFCoreLogInfo(@"count entities: %lu", (unsigned long)[[myManagedObjectModel entities] count]);
    
    // create dictionnary
    NSMutableDictionary *entityIds = [_coreDataHelper entityIds];
    
    // min function on identifier property
    NSExpression *identifierKeyPathExpression = [NSExpression expressionForKeyPath:@"identifier"];
    NSExpression *minIdExpression = [NSExpression expressionForFunction:@"min:"
                                                              arguments: @[identifierKeyPathExpression]];
    
    // create expression description with the min function, result is decimal
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"minId"];
    [expressionDescription setExpression:minIdExpression];
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    // create the request on entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch: @[expressionDescription]];
    
    NSError *error = nil;
    NSNumber *minId = nil;
    NSArray *result = nil;
    
    for (NSEntityDescription *entity in [myManagedObjectModel entities])
    {
        [request setEntity:entity];
        
        // execute request
        result = [context executeFetchRequest:request error:&error];
        if (result == nil ) {
            [NSException raise:@"Failure initializing sequence: result is nil" format:@"sequence for entity: %@", entity.name];
        }
        else {
            if ( [result count] == 1 ) {
                minId = [[result objectAtIndex:0] valueForKey:@"minId"];
                if ( [minId intValue] >= 0 ) {
                    minId = @-1;
                }
                MFCoreLogInfo(@"  init sequence for entity %@ to %@", entity.name, minId);
                [entityIds setObject:minId forKey:entity.name];
            }
        }
    }
}

+ (void) setupPersistentStoresWithDbName:(NSString *)dbName andMovalysDefaultModelName:(NSString *)movalysDefaultModelName
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    if (!persistentStoreCoordinator) {
        
        NSArray *modelURLs = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd" inDirectory:@""];
        NSMutableArray *userModels = [NSMutableArray array];
        for(NSURL *modelURL in modelURLs) {
            NSString *modelName = [modelURL lastPathComponent] ;
            NSManagedObjectModel *model = [NSManagedObjectModel MR_managedObjectModelNamed:modelName];
            BOOL isMovalysModel = [movalysDefaultModelName isEqualToString:[modelName componentsSeparatedByString:@"."][0]];
            
            if(isMovalysModel) {
                [MFCoreDataRunInit setupPersistentStoreForMovalysWithDbName:dbName andMovalysDefaultModelName:movalysDefaultModelName withModel:model];
            }
            else {
                [userModels addObject:model];
            }
            
        }
        dbName = [@"user" stringByAppendingString:dbName];
        NSManagedObjectModel *userMergedModel = [NSManagedObjectModel modelByMergingModels:userModels];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:userMergedModel];
        NSError *error = nil;
        NSDictionary *dict = [MFCoreDataRunInit MF_autoMigrationOptions];
        
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask, YES) lastObject];
        NSURL *storeUrl = [NSURL fileURLWithPath:[docsDirectory stringByAppendingPathComponent:dbName]];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:dict error:&error])
        {
            [NSException raise:@"Failure setting sqlite persistent store" format:@"error: %@", error];
        }
        
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
        if([[MFCoreDataRunInit class] respondsToSelector:@selector(encrypt:)]) {
            [[MFCoreDataRunInit class] performSelector:@selector(encrypt:) withObject:storeUrl];
        }
#pragma clang diagnostic pop
        
        [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:persistentStoreCoordinator];
        [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:persistentStoreCoordinator];
    }
}

+(void) setupPersistentStoreForMovalysWithDbName:(NSString *)dbName andMovalysDefaultModelName:(NSString *)movalysDefaultModelName withModel:(NSManagedObjectModel *)model {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSError *error = nil;
    NSDictionary *dict = [MFCoreDataRunInit MF_autoMigrationOptions];
    
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                   NSUserDomainMask, YES) lastObject];
    NSURL *storeUrl = [NSURL fileURLWithPath:[docsDirectory
                                              stringByAppendingPathComponent:dbName]];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"Database" URL:storeUrl options:dict error:&error])
    {
        [NSException raise:@"Failure setting sqlite persistent store" format:@"error: %@", error];
    }
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:@"Transient" URL:[NSURL URLWithString:@"memory://store"] options:dict error:&error])
    {
        [NSException raise:@"Failure setting memory store" format:@"error: %@", error];
    }
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    if([[MFCoreDataRunInit class] respondsToSelector:@selector(encrypt:)]) {
        [[MFCoreDataRunInit class] performSelector:@selector(encrypt:) withObject:storeUrl];
    }
#pragma clang diagnostic pop
    [[MFApplication getInstance] setMovalysStoreCoordinator:persistentStoreCoordinator withAssociatedContext:[NSManagedObjectContext MR_contextWithStoreCoordinator:persistentStoreCoordinator]];
}



#pragma mark - Auto-migrating
+ (NSDictionary *) MF_autoMigrationOptions
{
    // Adding the journalling mode recommended by apple
    NSMutableDictionary *sqliteOptions = [NSMutableDictionary dictionary];
    [sqliteOptions setObject:@"WAL" forKey:@"journal_mode"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             sqliteOptions, NSSQLitePragmasOption,
                             [NSNumber numberWithBool:YES], NSSQLiteManualVacuumOption,
                             nil];
    return options;
}

@end
