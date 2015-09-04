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


#import "MFCoreContext.h"
#import "MFActionQualifierProtocol.h"



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

typedef NS_ENUM(NSInteger, MFActionEventType) {
    MFActionEventTypeSuccess,
    MFActionEventTypeFail,
    MFActionEventTypeProgress
};

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
