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
