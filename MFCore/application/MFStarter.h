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


#import "MFSettingsValidationManager.h"


FOUNDATION_EXPORT NSString *const STEP_INIT_PROPERTIES;
FOUNDATION_EXPORT NSString *const STEP_INIT_CLASSES;

FOUNDATION_EXPORT NSString *const STARTER_START;
FOUNDATION_EXPORT NSString *const STARTER_END;
FOUNDATION_EXPORT NSString *const STARTER_CLASS_NOT_FOUND;

//------------------------------------

/*!
 * @brief Type de callback appelé lorsque l'appli sait combien elle possède de classe de démarrage
 * @param 1er paramètre le nom de classe ou l'étape lancée
 * @param 2eme paramètre l'état du lancement (START, STOP)
 */
typedef void (^MFStarterProgressCallBack)(NSString *, NSString *);

/*!
 * @brief Type de callback appelé lorsque l'appli lance ou stop une tâche de démarrage
 * @param 1er paramètre le nom d'état
 */
typedef void (^MFStarterInitCallBack)(NSInteger);

/*!
 * @brief Type de callback appelé lorsque l'appli termine le démarrage
 */
typedef void (^MFStarterEndCallBack)();

//------------------------------------

/*!
 * @class MFStarter
 * @brief This class starts all the necessary modules of MDK iOS to make a generated application working.
 */
@interface MFStarter : NSObject

#pragma mark - Properties

/*!
 * @brief Type de callback appelé lorsque l'appli sait combien elle possède de classe de démarrage
 */
@property (nonatomic, copy) MFStarterProgressCallBack starterProgressCallbackBlock;

/*!
 * @brief Type de callback appelé lorsque l'appli lance ou stop une tâche de démarrage
 */
@property (nonatomic, copy) MFStarterInitCallBack starterInitCallbackBlock;

/*!
 * @brief Type de callback appelé lorsque l'appli termine le démarrage
 */
@property (nonatomic, copy) MFStarterEndCallBack starterEndCallbackBlock;

/*!
 * @brief indique si l'application est démarrée
 */
@property (nonatomic, readonly, getter=isStarted) BOOL started;

/*!
 * @brief indique si l'application est démarrée
 */
@property (nonatomic, readonly, getter=isStartRunning) BOOL startRunning;

/*!
 * @brief indique si l'application a connu un échec au démarrage
 */
@property (nonatomic, getter=isAppFailure) BOOL appFailure;

/*!
 * @brief indique si les propriétés sont chargées
 */
@property (nonatomic, readonly, getter=isPropertiesLoaded) BOOL propertiesLoaded;

/*!
 * @brief indique si l'application est démarrée pour la première fois sur ce terminal
 */
@property (nonatomic, getter=isFirstLaunching) BOOL firstLaunching;

/*!
 * @brief store the rules to validate the settings
 */
@property (strong, nonatomic) MFSettingsValidationManager *settingsValidationManager;


#pragma mark - Methods

/*!
 * @brief donne l'unique instance du starter
 */
+(instancetype) getInstance;

/*!
 * @brief demarre l'application, en premier les classes de démarrage framework puis les classes de démarrage projet
 */
- (void) start;

/*!
 * @brief initialise le starter en précisant les deux blocs callback
 * @param initCallBack : Type de callback appelé lorsque l'appli sait combien elle possède de classe de démarrage
 * @param progressCallBack : Type de callback appelé lorsque l'appli lance ou stop une tâche de démarrage
 * @param endCallBack : call back de fin
 */
- (void) setInitCallBack:(MFStarterInitCallBack) initCallBack withProgressCallBack:(MFStarterProgressCallBack) progressCallBack withEndCallBack:(MFStarterEndCallBack) endCallBack;

/*!
 * @brief Save that this launch is the first launch of the application
 */
- (void) saveFirstLaunching;

/*!
 * @brief Register in the application if this launch is the first launch or not.
 */
- (void) setupFirstLaunching;

@end
