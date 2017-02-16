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


#import "MFCore/MFCore.h"
#import "MFActionObjectsDefinitions.h"

//dans les macros le bloc code if false sert à voir si les paramètres de la macro existe
// sinon erreur de compilation

//macro permettant d'enregistrer une méthode en tant que listener d'une action en succès
#define MFRegister_ActionListenerOnSuccess(actionName,methodName1) \
-(void)mf_registerActionListener##actionName##OnSuccess:(NSNumber *) initEventList \
{ \
MFActionListenerBlock block = ^(id p1, id p2, id p3, id p4){ \
dispatch_async(dispatch_get_main_queue(), ^{ \
[self methodName1:p1 withCaller:p2 andResult:p3]; \
}); \
}; \
NSString *name = [[MFActionLauncher getInstance] getEventNameForAction:actionName ofType:MFActionEventTypeSuccess];\
[[MFActionLauncher getInstance] MF_register:self withBlock:block andInitEventList:initEventList onEvent:name]; \
if (false) {NSLog(@"%@",actionName);block(nil, nil, nil, nil);} \
} \

//macro permettant d'enregistrer une méthode en tant que listener d'une action en succès si elle avait été lancé par cette même instance
// (peut être amélioré, car l'action est intercepté mais la méthode est lancée seulement si self == caller )
#define MFRegister_ActionListenerOnMyLaunchedActionSuccess(actionName,methodName1) \
-(void)mf_registerActionListener##actionName##OnSuccess:(NSNumber *) initEventList \
{ \
MFActionListenerBlock block = ^(id p1, id p2, id p3, id p4){ \
dispatch_async(dispatch_get_main_queue(), ^{ \
[self methodName1:p1 withCaller:p2 andResult:p3]; \
}); \
}; \
NSString *name = [[MFActionLauncher getInstance] getEventNameForAction:actionName ofType:MFActionEventTypeSuccess]; \
[[MFActionLauncher getInstance] MF_register:self withBlock:block andInitEventList:initEventList onEvent:name]; \
if (false) {NSLog(@"%@",actionName);block(nil, nil, nil, nil);} \
} \

//macro permettant d'enregistrer une méthode en tant que listener d'une action en échec
#define MFRegister_ActionListenerOnFailed(actionName,methodName1) \
-(void)mf_registerActionListener##actionName##OnFailed:(NSNumber *) initEventList \
{ \
MFActionListenerBlock block = ^(id p1, id p2, id p3, id p4){ \
dispatch_async(dispatch_get_main_queue(), ^{ \
[self methodName1:p1 withCaller:p2 andResult:p3]; \
}); \
}; \
NSString *name = [[MFActionLauncher getInstance] getEventNameForAction:actionName ofType:MFActionEventTypeFail];\
[[MFActionLauncher getInstance] MF_register:self withBlock:block andInitEventList:initEventList onEvent:name]; \
if (false) {NSLog(@"%@",actionName);block(nil, nil, nil, nil);} \
} \

//macro permettant d'enregistrer une méthode en tant que listener d'une action en échec si elle avait été lancé par cette même instance
#define MFRegister_ActionListenerOnMyLaunchedActionFailed(actionName,methodName1) \
-(void)mf_registerActionListener##actionName##OnFailed:(NSNumber *) initEventList \
{ \
MFActionListenerBlock block = ^(id p1, id p2, id p3, id p4){ \
dispatch_async(dispatch_get_main_queue(), ^{ \
[self methodName1:p1 withCaller:p2 andResult:p3]; \
}); \
}; \
NSString *name = [[MFActionLauncher getInstance] getEventNameForAction:actionName ofType:MFActionEventTypeFail];\
[[MFActionLauncher getInstance] MF_register:self withBlock:block andInitEventList:initEventList onEvent:name]; \
if (false) {NSLog(@"%@",actionName);block(nil, nil, nil, nil);} \
} \

//macro permettant d'enregistrer une méthode en tant que listener d'une action en progression
#define MFRegister_ActionListenerOnProgress(actionName,methodName1) \
-(void)mf_registerActionListener##actionName##OnProgress:(NSNumber *) initEventList \
{ \
MFActionListenerBlock block = ^(id p1, id p2, id p3, id p4){ \
dispatch_async(dispatch_get_main_queue(), ^{ \
[self methodName1:p1 withStep:p2 andCaller:p3 andResult:p4]; \
}); \
}; \
NSString *name = [[MFActionLauncher getInstance] getEventNameForAction:actionName ofType:MFActionEventTypeProgress]; \
[[MFActionLauncher getInstance] MF_register:self withBlock:block andInitEventList:initEventList onEvent:name]; \
if (false) {NSLog(@"%@",actionName);block(nil, nil, nil, nil);} \
} \

//macro permettant d'enregistrer une méthode en tant que listener d'une action en progression si elle avait été lancé par cette même instance
#define MFRegister_ActionListenerOnMyLaunchedActionProgress(actionName,methodName1) \
-(void)mf_registerActionListener##actionName##OnProgress:(NSNumber *) initEventList \
{ \
MFActionListenerBlock block = ^(id p1, id p2, id p3, id p4){ \
dispatch_async(dispatch_get_main_queue(), ^{ \
[self methodName1:p1 withStep:p2 andCaller:p3 andResult:p4]; \
}); \
}; \
NSString *name = [[MFApplication getInstance] getEventNameForAction:actionName ofType:MFActionEventTypeProgress]; \
[[MFActionLauncher getInstance] MF_register:self withBlock:block andInitEventList:initEventList onEvent:name]; \
if (false) {NSLog(@"%@",actionName);block(nil, nil, nil, nil);} \
} \



/*!
 * @class MFActionNotificationCenter_Private
 * @brief The Action Notification Center
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



/*!
 * @category Listeners
 * @brief This category does nothing else declaring Macro for actions listeners
 */
@interface MFActionLauncher (Listeners)

/**
 * @brief Gets the private Action Notification Center
 * @return The private Action Notification Center
 */
-(MFActionNotificationCenter_Private *)extendANC;

/**
 * @brief Sets the private Action Notification Center
 * @param The private Action Notification Center
 */
- (void) setExtendANC:(MFActionNotificationCenter_Private *)extendANC ;

/*!
 * @brief enregistre un objet en tant qu'écouteur
 * @param elementToRegister l'élément à enregistrer
 * @param block le code à executer pour l'enregistrmeent
 * @param initEventList indique si l'enregistrement est partiel ou complet (ie un enregistrement est partiel si il a déjà été executé une fois de manière complète)
 */
- (void) MF_register:(id) elementToRegister withBlock:(MFActionListenerBlock) block andInitEventList:(NSNumber*) initEventList onEvent:(NSString *) eventName;

/*!
 * @brief désenregistre un objet en tant qu'écouteur
 */
- (void) MF_unregister:(id) elementToUnRegister;

/*!
 * @brief enregistre en tant que listener d'action un objet
 */
- (void) MF_register:(id) elementToRegister;

/*!
 * @brief notify la progression d'une action
 * @param actionName le nom de l'action
 * @param step l'étape de l'action
 * @param result un paramètre quelconque
 * @param caller l'objet qui a lancé la première action
 * @param context le context à utiliser
 */
-(void) notifyListenerOnProgressOfAction:(NSString *) actionName withStep: (NSString *) step withObject: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context;

/*!
 * @brief notify l'échec d'une action
 * @param actionName le nom de l'action
 * @param result un paramètre quelconque
 * @param caller l'objet qui a lancé la première action
 * @param context le context à utiliser
 */
- (void) notifyListenerOnFailedOfAction:(NSString *) actionName withResult: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context;

/*!
 * @brief notify le succès d'une action
 * @param actionName le nom de l'action
 * @param result un paramètre quelconque
 * @param caller l'objet qui a lancé la première action
 * @param context le context à utiliser
 */
- (void) notifyListenerOnSuccessOfAction:(NSString *) actionName withResult: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context;


/*!
 * @brief analyse un objet en cherchant les méthodes "listener"
 */
- (void) objectToAnalyseByInstance:(id) elementToAnalyse;

/*!
 * @brief donne le nom d'un évènement de type success
 * @param le nom d'une action
 * @param eventType Le type de l'évènement
 * @result le nom de l'évênement associé
 */
- (NSString *) getEventNameForAction:(NSString *) actionName ofType:(MFActionEventType) eventType;

@end


