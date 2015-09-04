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


#import <MFCore/MFCore.h>

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
 * @category Listeners
 * @brief This category does nothing else declaring Macro for actions listeners
 */
@interface MFActionLauncher (Listeners)

@end
