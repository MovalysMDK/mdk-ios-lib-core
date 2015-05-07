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
//  MFActionLauncher.m
//  MFCore
//
//

#import <objc/runtime.h>

#import "MFCoreBean.h"
#import "MFCoreCoredata.h"
#import "MFCoreFoundationExt.h"

#import "MFActionLauncher.h"
#import "MFActionNotFound.h"
#import "MFActionQualifier.h"
#import "MFActionProgressMessageDispatcher.h"
#import "MFActionProtocol.h"
#import "MFActionPreTreatmentProtocol.h"
#import "MFActionPostTreatmentProtocol.h"

const void *extANCKey = &extANCKey;
NSString *const mf_registerActionListener = @"mf_registerActionListener";

//---------------------------------------------------------

/**
 * @brief permet de définir les attributs privés du notification center
 */
@interface MFActionNotificationCenter_Private : NSObject

/**
 * @brief le compteur d'actions lancées nécessitant un sablier
 */
@property (strong, nonatomic) NSNumber *launchedAction;

/**
 * @brief la queue d'exécution des actions
 */
@property (nonatomic, readonly) dispatch_queue_t actionQueue;

/**
 * @brief la queue d'execution des notifications
 */
@property (nonatomic, readonly) dispatch_queue_t notifQueue;

/**
 * @brief le cache de définition des classes
 */
@property (strong, nonatomic, readonly) NSMutableDictionary *classCache;

/**
 * @brief contient les objets "listener" par évênement
 */
@property (strong, nonatomic, readonly) NSMutableDictionary *registredElementsByEvent;

@end

//---------------------------------------------------------

@implementation MFActionNotificationCenter_Private

-(id) init {
    if (self = [super init]) {
        self.launchedAction = [NSNumber numberWithInt:0];
        _actionQueue = dispatch_queue_create("actionQueue",  DISPATCH_QUEUE_CONCURRENT);
        _notifQueue = dispatch_queue_create("notifQueue",  DISPATCH_QUEUE_CONCURRENT);
        _classCache = [[NSMutableDictionary alloc] init];
        _registredElementsByEvent= [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end

//---------------------------------------------------------

/**
 * @brief permet de stocker des informations sur une méthode
 */
@interface MFActionMethodDefinition : NSObject

/**
 * @brief la méthode donc on stocke des informations
 */
@property (nonatomic) SEL selector;

@end

//---------------------------------------------------------

@implementation MFActionMethodDefinition

@end

//---------------------------------------------------------

/**
 * @brief permet de sotcker des informations sur un évênement
 */
@interface MFActionEventDefinition : NSObject

/**
 * @brief l'objet demandant le callback
 */
@property (weak, nonatomic) id objectWithCallBack;

/**
 * @brief le callback a appeler
 */
@property (copy) MFActionListenerBlock callBack;

@end

//---------------------------------------------------------

/**
 * @brief permet de stocker des informations sur une classe
 */
@interface MFActionClassDefinition : NSObject

/**
 * @brief contient l'ensemble des informations de méthodes (listener) qui nous intéresse
 */
@property (strong, nonatomic, readonly) NSMutableArray *methods;

/**
 * @brief l'ensemble des évênements supportés par une classe
 */
@property (strong, nonatomic, readonly) NSMutableArray *events;

@end

//---------------------------------------------------------

@implementation MFActionClassDefinition

-(id) init {
    if (self = [super init]) {
        _methods = [[NSMutableArray alloc ]init];
        _events = [[NSMutableArray alloc ]init];
    }
    return self;
}

@end

//---------------------------------------------------------

@implementation MFActionEventDefinition

- (BOOL)isEqual:(id)other {
    if ([other isMemberOfClass:[self class]]) {
        BOOL returnValue = NO;
        if([other objectWithCallBack] == [self objectWithCallBack]) {
            returnValue = YES;
        }
        return returnValue;
    }
    return NO;
}

@end

//---------------------------------------------------------

@interface MFActionNotificationCenter

@property(strong, nonatomic) MFActionNotificationCenter_Private *extendANC;

@end

//---------------------------------------------------------

@implementation MFActionLauncher

+(instancetype)getInstance{
    //Faire un singleton
    static MFActionLauncher *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

/**
 * @brief permet de récuperer les attributs supplémentaires de la catégorie
 */
-(MFActionNotificationCenter_Private *)extendANC {
    MFActionNotificationCenter_Private* ext = objc_getAssociatedObject(self, &extANCKey);
    if (ext==nil) {
        ext = [[MFActionNotificationCenter_Private alloc] init];
        [self setExtendANC:ext];
    }
    return ext;
}

/**
 * @brief affecte les attributs supplémentaire de la catégorie
 */
- (void) setExtendANC:(MFActionNotificationCenter_Private *) n {
    objc_setAssociatedObject(self, &extANCKey, n,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


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


- (id<MFContextProtocol>) createMFContext:(NSString *)actionName {
    
    id<MFContextFactoryProtocol> contextFactory = [[MFBeanLoader getInstance] getBeanWithType:@protocol(MFContextFactoryProtocol)];
    
    id<MFContextProtocol> mfContext = [contextFactory createMFContextWithChildCoreDataContext];
    
    //MFCoreLogInfo(@"FOR action: %@, createMFContext: %@", actionName, mfContext.entityContext );
    //MFCoreLogInfo(@"    parentContext: %@", mfContext.entityContext.parentContext );
    
    return mfContext;
}


-(void) showWaitingView {
    //overload in ui project
}

-(void) dismissWaitingView {
    // overload in ui project
}

- (void) MF_register:(id) elementToRegister withBlock:(MFActionListenerBlock) block andInitEventList:(NSNumber*) initEventList onEvent:(NSString *) eventName {
    if ((BOOL) initEventList){
        MFActionClassDefinition* def = [[self extendANC].classCache objectForKey:NSStringFromClass([elementToRegister class])];
        [def.events addObject:eventName];
    }
    NSMutableSet* objectsLists = [[self extendANC].registredElementsByEvent objectForKey:eventName];
    if (objectsLists == nil) {
        objectsLists = [[NSMutableSet alloc] init];
        [[self extendANC].registredElementsByEvent setObject:objectsLists forKey:eventName];
    }
    MFActionEventDefinition* eventDef = [[MFActionEventDefinition alloc] init];
    eventDef.objectWithCallBack = elementToRegister;
    eventDef.callBack = (MFActionListenerBlock) block;
    [objectsLists addObject:eventDef];
    [[self extendANC].registredElementsByEvent setObject:objectsLists forKey:eventName];
    
}

- (void) MF_register:(id) elementToRegister {
    [self objectToAnalyseByInstance:elementToRegister];
}

- (void) MF_unregister:(id) elementToUnRegister {
    MFActionClassDefinition* def = [[self extendANC].classCache objectForKey:NSStringFromClass([elementToUnRegister class])];
    NSMutableSet* objectsLists = nil;
    for(NSString *eventName in def.events) {
        objectsLists = [[self extendANC].registredElementsByEvent objectForKey:eventName];
        NSMutableArray* objectsToDelete = [NSMutableArray array];
        for(id object in objectsLists) {
            if([object isKindOfClass:[MFActionEventDefinition class]]) {
                MFActionEventDefinition* eventDef = object;
                [objectsToDelete addObject:eventDef];
                eventDef.callBack = nil;
                eventDef.objectWithCallBack = nil;
                eventDef = nil;
            }
        }
        
        [objectsLists minusSet:[NSSet setWithArray:objectsToDelete]];
        [[self extendANC].registredElementsByEvent setObject:objectsLists forKey:eventName];
        
    }
    
    [objectsLists removeObject:elementToUnRegister];
    elementToUnRegister = nil;
    
}

//par defaut s'execute dans la queue action
- (void) notifyListenerOnSuccessOfAction:(NSString *) actionName withResult: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context {
    NSSet* listeners = [[self extendANC].registredElementsByEvent objectForKey:[self getSuccessEventNameForAction:actionName]];
    for(MFActionEventDefinition* eventDef in listeners) {
        dispatch_async([self extendANC].notifQueue, ^{
            if (eventDef && eventDef.callBack && eventDef.objectWithCallBack) {
                eventDef.callBack(context, caller, result, nil);
            }
            
        });
    }
}

- (void) notifyListenerOnFailedOfAction:(NSString *) actionName withResult: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context {
    NSSet* listeners = [[self extendANC].registredElementsByEvent objectForKey:[self getFailedEventNameForAction:actionName]];
    for(MFActionEventDefinition* eventDef in listeners) {
        dispatch_async([self extendANC].notifQueue, ^{
            eventDef.callBack(context, caller, result, nil);
        });
    }
}

-(void) notifyListenerOnProgressOfAction:(NSString *) actionName withStep: (NSString *) step withObject: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context {
    NSSet* listeners = [[self extendANC].registredElementsByEvent objectForKey:[self getProgressEventNameForAction:actionName]];
    for(MFActionEventDefinition* eventDef in listeners) {
        dispatch_async([self extendANC].notifQueue, ^{
            eventDef.callBack(context, step, caller, result);
        });
    }
}

- (void) objectToAnalyseByInstance:(id) elementToAnalyse {
    // Vérification si la classe à déjà été traité dans un cache
    Class classToAnalyse = [elementToAnalyse class];
    NSString *className = NSStringFromClass([elementToAnalyse class]);
    MFActionClassDefinition* def = [[self extendANC].classCache objectForKey:className];
    if (def == nil) {
        def = [[MFActionClassDefinition alloc] init];
        [[self extendANC].classCache setObject:def forKey:className];
        
        // Analyse de la classe pour trouver les méthodes d'enregistrement
        while(classToAnalyse!=nil) {
            if ([className hasPrefix:@"MF"] || !(
                                                 [className hasPrefix:@"NS"] || [className hasPrefix:@"DD"]
                                                 || [className hasPrefix:@"JR"] || [className hasPrefix:@"JSON"]
                                                 || [className hasPrefix:@"AF"] || [className hasPrefix:@"Magical"]
                                                 || [className hasPrefix:@"RAC"]
                                                 || [className hasPrefix:@"Typhoon"])) {
                [self objectToAnalyseByInstance:elementToAnalyse andByClass:classToAnalyse inDefinition:def];
                classToAnalyse = [classToAnalyse superclass];
                className = NSStringFromClass([classToAnalyse class]);
            }
            else {
                classToAnalyse = nil;
            }
        }
    }
    else {
        //on boucle sur les méthodes de la définition et on les invoques
        for(MFActionMethodDefinition* mDef in def.methods) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [elementToAnalyse performSelector:mDef.selector withObject:[NSNumber numberWithBool:YES]];
#pragma clang diagnostic pop
        }
    }
}

-(void)objectToAnalyseByInstance:(id) elementToAnalyse andByClass:(Class) classToAnalyse inDefinition:(MFActionClassDefinition*) def{
    unsigned int numMethods = 0;
    Method *methods = class_copyMethodList(classToAnalyse, &numMethods);
    SEL selector = nil;
    NSString *mName = nil;
    MFActionMethodDefinition* mDef = nil;
    for(int i=0;i<numMethods;++i){
        selector = method_getName(methods[i]);
        mName = NSStringFromSelector(selector);
        if ([mName hasPrefix:mf_registerActionListener]) {
            selector = method_getName(methods[i]);
            mDef = [[MFActionMethodDefinition alloc] init];
            mDef.selector = selector;
            [def.methods addObject:mDef];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [elementToAnalyse performSelector:selector withObject:[NSNumber numberWithBool:YES]];
#pragma clang diagnostic pop
        }
    }
    free(methods);
}

- (NSString *) getSuccessEventNameForAction:(NSString *) actionName {
    NSString *name = @"";
    name = [name stringByAppendingString:actionName];
    name = [name stringByAppendingString:@"OnSuccess"];
    return name;
}

- (NSString *) getFailedEventNameForAction:(NSString *) actionName {
    NSString *name = @"";
    name = [name stringByAppendingString:actionName];
    name = [name stringByAppendingString:@"OnFailed"];
    return name;
}

- (NSString *) getProgressEventNameForAction:(NSString *) actionName {
    NSString *name = @"";
    name = [name stringByAppendingString:actionName];
    name = [name stringByAppendingString:@"OnProgress"];
    return name;
}

@end
