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


#import <objc/runtime.h>

#import "MFActionObjectsDefinitions.h"
#import "MFCoreBean.h"
#import "MFCoreCoredata.h"
#import "MFCoreFoundationExt.h"
#import "MFActionLauncher+Listeners.h"
#import "MFActionLauncher+WaitingView.h"
#import "MFActionLauncher.h"
#import "MFActionNotFound.h"
#import "MFActionQualifier.h"
#import "MFActionProgressMessageDispatcher.h"
#import "MFActionProtocol.h"
#import "MFActionPreTreatmentProtocol.h"
#import "MFActionPostTreatmentProtocol.h"

@interface MFActionNotificationCenter

@property(strong, nonatomic) MFActionNotificationCenter_Private *extendANC;

@end



@implementation MFActionLauncher

#pragma mark - Singleton

+(instancetype)getInstance{
    //Faire un singleton
    static MFActionLauncher *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}





#pragma mark - Launch actions

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andChainActions:nil];
}

- (void) launchActionWithoutWaitingView:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:[self createMFContext:actionName] andChainActions:nil andInOutTransformers:nil andParameters:nil andQualifier:nil withWaitingView:NO];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:context andChainActions:nil];
}


-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andChainActions:chainActions andInOutTransformers:nil andParameters:nil];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller  withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) transformers andParameters:(NSMutableDictionary*) parameters{
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:[self createMFContext:actionName] andChainActions:chainActions andInOutTransformers:transformers andParameters:parameters];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions  {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:context andChainActions:chainActions andInOutTransformers:nil andParameters:nil];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andQualifier:(id<MFActionQualifierProtocol>) qualifier {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andChainActions:nil andQualifier:qualifier];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andQualifier:(id<MFActionQualifierProtocol>) qualifier {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:context andChainActions:nil andQualifier:qualifier];
}


-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions andQualifier:(id<MFActionQualifierProtocol>) qualifier {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andChainActions:chainActions andInOutTransformers:nil andParameters:nil andQualifier:qualifier];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller  withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) transformers andParameters:(NSMutableDictionary*) parameters andQualifier:(id<MFActionQualifierProtocol>) qualifier{
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:[self createMFContext:actionName] andChainActions:chainActions andInOutTransformers:transformers andParameters:parameters andQualifier:qualifier withWaitingView:YES];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions andQualifier:(id<MFActionQualifierProtocol>) qualifier {
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:context andChainActions:chainActions andInOutTransformers:nil andParameters:nil andQualifier:qualifier withWaitingView:YES];
}

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) chainTransformers andParameters:(NSMutableDictionary*) parameters{
    [self launchAction:actionName withCaller:caller withInParameter:parameterIn andContext:context andChainActions:chainActions andInOutTransformers:chainTransformers andParameters:parameters andQualifier:nil withWaitingView:YES];
}



#pragma mark - Launch Action method

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) chainTransformers andParameters:(NSMutableDictionary*) parameters andQualifier:(id<MFActionQualifierProtocol>)qualifier withWaitingView:(BOOL)showWaitingView {
    id<MFActionProtocol> action = [[MFBeanLoader getInstance] getBeanWithKey:actionName];
    if (action == nil) {
        @throw [[MFActionNotFound alloc]initWithName:@"Action Not Found" reason:actionName userInfo:nil];
    }
    else {
        id<MFActionQualifierProtocol> lqualifier = qualifier;
        if (lqualifier==nil && [action respondsToSelector:@selector(getBasicActionQualifier)]) {
            lqualifier = [action getBasicActionQualifier];
        }
        if (lqualifier == nil) {
            lqualifier = [[MFActionQualifier alloc] init];
        }
        
        
        //Blocage de l'écran : affichage du sablier, à bien faire en dehors du dispatch_async
        if (lqualifier.blocking) {
            [self startAction:showWaitingView];
        }
        //Gestion de l'empilement des actions
        dispatch_async([self extendANC].actionQueue, ^{
            MFActionProgressMessageDispatcher *dispatch = [[MFActionProgressMessageDispatcher alloc] init];
            dispatch.caller = caller;
            dispatch.actionName = actionName;
            
            // Lancement du pre traitement
            MFActionTreatmentResult preTreatmentResult = actionPreTreatmentContinue;
            id<MFActionPreTreatmentProtocol> preTreatment = [[MFBeanLoader getInstance] getOptionalBeanWithKey:@"MFActionPreTreatmentProtocol"];
            if(preTreatment != nil) {
                preTreatmentResult = [preTreatment doTreatmentForAction:actionName withCaller:caller];
                switch (preTreatmentResult) {
                    case actionPreTreatmentWarning:
                        [preTreatment onWarning:[NSString stringWithFormat:@"Des avertissements se sont produits lors de l'action %@",actionName]];
                        break;
                    case actionPreTreatmentError:
                        [preTreatment onError:[NSString stringWithFormat:@"Des erreurs se sont produites lors de l'action %@",actionName]];
                        break;
                    case actionPreTreatmentContinue:
                        //Nothing to do
                        break;
                }
            }
            else {
                MFCoreLogInfo(@"No pretreatment for action %@", actionName);
            }
            
            
            // Lancement de l'action si aucune erreur n'est intervenue lors du pré-traitement
            if(preTreatmentResult != actionPreTreatmentError)
            {
                id res = [action doAction:parameterIn withContext:context withQualifier:lqualifier withDispatcher:dispatch];
                
                // Traitement du résultat
                if ([context hasError]) {
                    if ([action respondsToSelector:@selector(doOnFailed:withContext:withQualifier:withDispatcher:)]) {
                        [action doOnFailed:res withContext:context withQualifier:lqualifier withDispatcher:dispatch];
                    }
                    [self notifyListenerOnFailedOfAction:actionName withResult:res andCaller:caller andContext:context];
                }
                else {
                    if ([action respondsToSelector:@selector(doOnSuccess:withContext:withQualifier:withDispatcher:)]) {
                        [action doOnSuccess:res withContext:context withQualifier:lqualifier withDispatcher:dispatch];
                    }
                    [self notifyListenerOnSuccessOfAction:actionName withResult:res andCaller:caller andContext:context];
                }
                
                // Lancement du post-traitement
                id<MFActionPostTreatmentProtocol> postTreatment = [[MFBeanLoader getInstance] getOptionalBeanWithKey:@"MFActionPostTreatmentProtocol"];
                if(postTreatment != nil) {
                    [postTreatment doTreatmentForAction:actionName withCaller:caller];
                }
                else {
                    MFCoreLogInfo(@"No post-treatment for action %@", actionName);
                }
                
                MFCoreDataHelper *cdh = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER];
                // Traitement du résultat
                if ([context hasError]) {
                    //rollback
                    [cdh rollbackContext:context];
                }
                else {
                    if ([action respondsToSelector:@selector(isReadOnly)] &&
                        ![action isReadOnly]) {
                        //commit
                        NSError* error = [cdh saveContext:context];
                        if (error!=nil) {
                            [NSException raise:@"Failure saving context" format:@"error: %@", error];
                        }
                    }
                    else {
                        // action is readonly, rollback context if some changes have been made.
                        [cdh rollbackContext:context];
                    }
                }
                
                // Chainage des actions
                if (chainActions!=nil && [chainActions count]>0) {
                    
                    // Get the next action
                    NSString *chainAction = [chainActions objectAtIndex:0];
                    id nextIn = res;
                    
                    // Get and apply the next in/out transformer if available
                    if (chainTransformers!=nil) {
                        ActionInOutTransformer transformer = [chainTransformers objectAtIndex:0];
                        nextIn = transformer(parameters, nextIn);
                    }
                    
                    // Build the next chain actions and the next chain transformers
                    NSMutableArray* nextChainActions = [[NSMutableArray alloc] initWithCapacity:[chainActions count]-1];
                    NSMutableArray* nextChainTransformers = nil;
                    if (chainTransformers!=nil) {
                        nextChainTransformers = [[NSMutableArray alloc] initWithCapacity:[chainActions count]-1];
                    }
                    for(int i = 1; i<[chainActions count]; i++) {
                        [nextChainActions addObject:[chainActions objectAtIndex:i]];
                        [nextChainTransformers addObject:[chainTransformers objectAtIndex:i]];
                    }
                    
                    // Call the next action
                    [self launchAction:chainAction withCaller:caller withInParameter:nextIn andContext:context andChainActions:nextChainActions andInOutTransformers:nextChainTransformers andParameters:parameters];
                }
            }
            if (lqualifier.blocking) {
                //Déblocage de l'écran
                [self stopAction];
            }
        });
    }
}


#pragma mark - Start and Stop
-(void) startAction:(BOOL)showWaitingView {
    @synchronized([self extendANC].launchedAction){
        [self extendANC].launchedAction = [NSNumber numberWithInt:[[self extendANC].launchedAction intValue]+1];
        if ([[self extendANC].launchedAction intValue]==1 && showWaitingView) {
            if([MFHelperQueue isInMainQueue]) {
                [self showWaitingView];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showWaitingView];
                });
            }
        }
    }
}

-(void) stopAction {
    @synchronized([self extendANC].launchedAction){
        [self extendANC].launchedAction = [NSNumber numberWithInt:[[self extendANC].launchedAction intValue]-1];
        if ([[self extendANC].launchedAction intValue]==0) {
            if([MFHelperQueue isInMainQueue]) {
                [self dismissWaitingView];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissWaitingView];
                });
            }
        }
    }
}


#pragma mark - Context
- (id<MFContextProtocol>) createMFContext:(NSString *)actionName {
    id<MFContextFactoryProtocol> contextFactory = [[MFBeanLoader getInstance] getBeanWithType:@protocol(MFContextFactoryProtocol)];
    id<MFContextProtocol> mfContext = [contextFactory createMFContextWithChildCoreDataContext];

    
    return mfContext;
}




@end
