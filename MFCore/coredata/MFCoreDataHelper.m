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
//  MFCoreDataHelper.m
//  MFCore
//
//

#import "MFCoreContext.h"

#import "MFCoreDataHelper.h"
#import "MFFetchOptions.h"

@implementation MFCoreDataHelper

-(id) init
{
    self = [super init];
    if (self)
    {
        _entityIds = [[NSMutableDictionary alloc] init];
    }
    return self ;
}

-(NSNumber *) nextIdForEntity:(NSString *) entityName {
    NSNumber *newValue = nil;
    // Increments of sequences of ids must be thread-safe.
    @synchronized(self.entityIds)
    {
        NSNumber *oldValue = [self.entityIds objectForKey:entityName];
        newValue = [NSNumber numberWithInt:[oldValue intValue] -1];
        [self.entityIds setObject:newValue forKey:entityName];
    }
    return newValue ;
}

-(NSError*)saveContext:(id<MFContextProtocol>) mfContext {
    NSManagedObjectContext *entityContext = [mfContext entityContext];
    
    //Save n'ecrit pas dans le fichier .sqlite
     if ( [entityContext hasChanges]) {
         
         [self saveWithOptions:MRSaveParentContexts | MRSaveSynchronously entityContext:entityContext completion: ^(BOOL success, NSError *error) {
             //ce block ne s'execute pas dans la queue d'origine ce qui pose des problèmes entre autre au demmarrage de l'application
             //lorsqu'il y a une erreur, il vaut mieux ne pas envoyer d'exception;
             if (!success) {
                 self.lastSaveContextError = error;
             }
         }];
    }
    return self.lastSaveContextError;
}

- (void) saveWithOptions:(MRSaveContextOptions)mask entityContext:(NSManagedObjectContext *) entityContext
        completion:(MRSaveCompletionHandler)completion

{
    BOOL syncSave           = ((mask & MRSaveSynchronously) == MRSaveSynchronously);
    BOOL saveParentContexts = ((mask & MRSaveParentContexts) == MRSaveParentContexts);
    
    if (![entityContext hasChanges]) {
        MRLog(@"NO CHANGES IN ** %@ ** CONTEXT - NOT SAVING", [entityContext MR_workingName]);
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
        }
        
        return;
    }
    
    MRLog(@"→ Saving %@", [entityContext MR_description]);
    MRLog(@"→ Save Parents? %@", @(saveParentContexts));
    MRLog(@"→ Save Synchronously? %@", @(syncSave));
    
    id saveBlock = ^{
        NSError *error = nil;
        BOOL     saved = NO;
        
        @try
        {
            saved = [entityContext save:&error];
        }
        @catch(NSException *exception)
        {
            MRLog(@"Unable to perform save: %@", (id)[exception userInfo] ? : (id)[exception reason]);
        }
        
        @finally
        {
            if (!saved) {
                [MagicalRecord handleErrors:error];
                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(saved, error);
                    });
                }
            } else {
                // If we're the default context, save to disk too (the user expects it to persist)
                BOOL isDefaultContext = (entityContext == [[entityContext class] MR_defaultContext]);
                BOOL shouldSaveParentContext = ((YES == saveParentContexts) || isDefaultContext);
                
                if (shouldSaveParentContext && [entityContext parentContext]) {
                    [self saveWithOptions:mask entityContext:[entityContext parentContext] completion:completion];
                }
                // If we should not save the parent context, or there is not a parent context to save (root context), call the completion block
                else {
                    MRLog(@"→ Finished saving: %@", [entityContext MR_description]);
                    
                    if (completion) {
                        
                        runOnMainQueueWithoutDeadlocking( ^{
                            completion(saved, error);
                        });
                    }
                }
            }
        }
    };
    
    if (YES == syncSave) {
        [entityContext performBlockAndWait:saveBlock];
    } else {
        [entityContext performBlock:saveBlock];
    }
}

-(void) rollbackContext:(id<MFContextProtocol>)mfContext {
    [mfContext.entityContext rollback];
}

-(void) registerStore:(NSPersistentStore *)sqliteStore
{
    _sqliteStore = sqliteStore;
}


- (void)logChanges:(id<MFContextProtocol>)mfContext withDetails:(BOOL)details {
    MFCoreLogInfo(@"** Context changes :");
    
    MFCoreLogInfo(@"inserted objects: %lu", (unsigned long)[[[mfContext entityContext] insertedObjects] count]);
    MFCoreLogInfo(@"deleted objects: %lu", (unsigned long)[[[mfContext entityContext] deletedObjects] count]);
    MFCoreLogInfo(@"updated objects: %lu", (unsigned long)[[[mfContext entityContext] updatedObjects] count]);
    
    if ( details ) {
    
        for( NSManagedObject *entity in [[mfContext entityContext] insertedObjects]) {
            MFCoreLogInfo(@"new object: %@", entity);
        }
    
        for( NSManagedObject *entity in [[mfContext entityContext] deletedObjects]) {
            MFCoreLogInfo(@"deleted object: %@", entity);
        }
    
        for( NSManagedObject *entity in [[mfContext entityContext] updatedObjects]) {
            MFCoreLogInfo(@"updated object: %@", entity);
        }
    }
    MFCoreLogInfo(@"****");
}

void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end
