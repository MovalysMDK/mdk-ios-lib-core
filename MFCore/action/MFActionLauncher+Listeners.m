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
#import "MFActionLauncher+Listeners.h"
#import <objc/runtime.h>


NSString *const mf_registerActionListener = @"mf_registerActionListener";
const void *extANCKey = &extANCKey;

@implementation MFActionLauncher (Listeners)


#pragma mark - Category retained properties
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


#pragma mark - Register / Unregister Actions events

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


#pragma mark - Notifying actions events

//par defaut s'execute dans la queue action
- (void) notifyListenerOnSuccessOfAction:(NSString *) actionName withResult: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context {
    NSSet* listeners = [[self extendANC].registredElementsByEvent objectForKey:[self getEventNameForAction:actionName ofType:MFActionEventTypeSuccess]];
    for(MFActionEventDefinition* eventDef in listeners) {
        dispatch_async([self extendANC].notifQueue, ^{
            if (eventDef && eventDef.callBack && eventDef.objectWithCallBack) {
                eventDef.callBack(context, caller, result, nil);
            }
            
        });
    }
}

- (void) notifyListenerOnFailedOfAction:(NSString *) actionName withResult: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context {
    NSSet* listeners = [[self extendANC].registredElementsByEvent objectForKey:[self getEventNameForAction:actionName ofType:MFActionEventTypeFail]];
    for(MFActionEventDefinition* eventDef in listeners) {
        dispatch_async([self extendANC].notifQueue, ^{
            if (eventDef && eventDef.callBack && eventDef.objectWithCallBack) {
                eventDef.callBack(context, caller, result, nil);
            }
        });
    }
}

-(void) notifyListenerOnProgressOfAction:(NSString *) actionName withStep: (NSString *) step withObject: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context {
    NSSet* listeners = [[self extendANC].registredElementsByEvent objectForKey:[self getEventNameForAction:actionName ofType:MFActionEventTypeProgress]];
    for(MFActionEventDefinition* eventDef in listeners) {
        dispatch_async([self extendANC].notifQueue, ^{
            if (eventDef && eventDef.callBack && eventDef.objectWithCallBack) {
                eventDef.callBack(context, caller, result, nil);
            }
        });
    }
}



#pragma mark - Class Introspection

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


#pragma mark - Context

- (NSString *) getEventNameForAction:(NSString *) actionName ofType:(MFActionEventType) eventType{
    NSString *name = @"";
    name = [name stringByAppendingString:actionName];
    
    NSString *appendix = nil;
    switch (eventType) {
        case MFActionEventTypeFail:
            appendix = @"OnFailed";
            break;
        case MFActionEventTypeSuccess:
            appendix = @"OnSuccess";
            break;
        case MFActionEventTypeProgress:
            appendix = @"OnProgress";
            break;
        default:
            break;
    }
    name = [name stringByAppendingString:appendix];
    return name;
}


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
