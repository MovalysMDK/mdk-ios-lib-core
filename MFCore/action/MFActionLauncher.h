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
//  MFActionLauncher.h
//  MFCore
//
//

#import "MFCoreContext.h"

#import "MFActionQualifierProtocol.h"


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
NSString *name = [[MFActionLauncher getInstance] getSuccessEventNameForAction:actionName];\
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
NSString *name = [[MFActionLauncher getInstance] getSuccessEventNameForAction:actionName]; \
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
NSString *name = [[MFActionLauncher getInstance] getFailedEventNameForAction:actionName];\
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
NSString *name = [[MFActionLauncher getInstance] getFailedEventNameForAction:actionName];\
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
NSString *name = [[MFActionLauncher getInstance] getProgressEventNameForAction:actionName]; \
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
NSString *name = [[MFApplication getInstance] getProgressEventNameForAction:actionName]; \
[[MFActionLauncher getInstance] MF_register:self withBlock:block andInitEventList:initEventList onEvent:name]; \
if (false) {NSLog(@"%@",actionName);block(nil, nil, nil, nil);} \
} \




/*!
 * @brief Définit un bloc permettant de lancer l'enregistrement d'une action en tant que listener
 * Les paramètres dépendent des macros, (à voir dans les 3 macros précédentes)
 */
typedef void (^MFActionListenerBlock)(id, id, id, id);


/*!
 * @brief Définit un bloc permettant de définir une règle de chaînage entre 2 actions, soit b le bloc, po1 le paramètre de sortie
 * de la première action, pi2 le paramètre d'entrée de la seconde action
 * po1 = b(po2)
 * @param le premier paramètre est un dictionnaire dans lequel le développeur peut mettre ce qu'il souhaite, ce dictionnaire est transmis
 * de transformer en transformer pour un même chaînage
 * @param le second paramètre est le résultat de l'action précédente
 * @return le pramètre d'entrée de la seconde action
 */
typedef id (^ActionInOutTransformer)(NSMutableDictionary *dictionnary, id precResult);



@interface MFActionLauncher : NSObject

/*!
 * @brief donne l'unique instance du starter
 */
+(instancetype)getInstance;


/*!
 * @brief gère l'arrêt d'une action, si le compteur est égale à 0 alors le sablier est enlevé
 */
-(void) stopAction;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn;

/*!
 * @brief permet de lancer une action sans afficher le sablier. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 */
- (void) launchActionWithoutWaitingView:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param context le context à utiliser
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones. Par défaut le paramètre d'entrée de l'action n+1 est égale au paramètre de sortie de l'action n
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param chainActions tableau contenant le nom des actions à chaîner
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param chainActions tableau contenant le nom des actions à chaîner
 * @param transformers un tableau de transformer permettant de calculer le paramètre d'entré d'une action en fonction du paramètre de sortie de l'action prédédente
 * @param parameters un dictionnaire à disposition de l'utilisateur
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) transformers andParameters:(NSMutableDictionary*) parameters;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param context le context à utiliser
 * @param chainActions tableau contenant le nom des actions à chaîner
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param context le context à utiliser
 * @param chainActions tableau contenant le nom des actions à chaîner
 * @param transformers un tableau de transformer permettant de calculer le paramètre d'entré d'une action en fonction du paramètre de sortie de l'action prédédente
 * @param parameters un dictionnaire à disposition de l'utilisateur
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) transformers andParameters:(NSMutableDictionary*) parameters;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param qualifier le qualifier à utiliser
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andQualifier:(id<MFActionQualifierProtocol>) qualifier;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param context le context à utiliser
 * @param qualifier le qualifier à utiliser
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andQualifier:(id<MFActionQualifierProtocol>) qualifier;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones. Par défaut le paramètre d'entrée de l'action n+1 est égale au paramètre de sortie de l'action n
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param chainActions tableau contenant le nom des actions à chaîner
 * @param qualifier le qualifier à utiliser
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions andQualifier:(id<MFActionQualifierProtocol>) qualifier;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param chainActions tableau contenant le nom des actions à chaîner
 * @param transformers un tableau de transformer permettant de calculer le paramètre d'entré d'une action en fonction du paramètre de sortie de l'action prédédente
 * @param parameters un dictionnaire à disposition de l'utilisateur
 * @param qualifier le qualifier à utiliser
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) transformers andParameters:(NSMutableDictionary*) parameters andQualifier:(id<MFActionQualifierProtocol>) qualifier;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param context le context à utiliser
 * @param chainActions tableau contenant le nom des actions à chaîner
 * @param qualifier le qualifier à utiliser
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions andQualifier:(id<MFActionQualifierProtocol>) qualifier;

/*!
 * @brief permet de lancer une action. Les actions sont lancées de manières asynchrones.
 * @param actionName le nom de l'action à lancer déclaré comme étant un bean
 * @param caller l'objet ayant lancé la première action
 * @param parameterIn le paramètre d'entrée de la première action
 * @param context le context à utiliser
 * @param chainActions tableau contenant le nom des actions à chaîner
 * @param transformers un tableau de transformer permettant de calculer le paramètre d'entré d'une action en fonction du paramètre de sortie de l'action prédédente
 * @param parameters un dictionnaire à disposition de l'utilisateur
 * @param qualifier le qualifier à utiliser
 * @param indiquer si le sablier doit être affiché ou non
 */
-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn andContext:(id<MFContextProtocol>) context andChainActions:(NSArray*) chainActions andInOutTransformers:(NSArray*) chainTransformers andParameters:(NSMutableDictionary*) parameters andQualifier:(id<MFActionQualifierProtocol>)qualifier withWaitingView:(BOOL)showWaitingView;

/*!
 * @brief Permet de faire apparaître le sablier
 */
-(void) showWaitingView;

/*!
 * @brief Permet de faire disparaître le sablier
 */
-(void) dismissWaitingView;

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
 * @brief analyse un objet en cherchant les méthodes "listener"
 */
- (void) objectToAnalyseByInstance:(id) elementToAnalyse;

/*!
 * @brief donne le nom d'un évènement de type success
 * @param le nom d'une action
 * @result le nom de l'évênement associé
 */
- (NSString *) getSuccessEventNameForAction:(NSString *) actionName;

/*!
 * @brief donne le nom d'un évènement de type failed
 * @param le nom d'une action
 * @result le nom de l'évênement associé
 */
- (NSString *) getFailedEventNameForAction:(NSString *) actionName;

/*!
 * @brief donne le nom d'un évènement de type progress
 * @param le nom d'une action
 * @result le nom de l'évênement associé
 */
- (NSString *) getProgressEventNameForAction:(NSString *) actionName;

/*!
 * @brief notify la progression d'une action
 * @param actionName le nom de l'action
 * @param l'étape de l'action
 * @param un paramètre quelconqie
 * @param caller l'objet qui a lancé la première action
 * @param context le context à utiliser
 */
-(void) notifyListenerOnProgressOfAction:(NSString *) actionName withStep: (NSString *) step withObject: (id) result andCaller: (id) caller andContext:(id<MFContextProtocol>) context;

@end
