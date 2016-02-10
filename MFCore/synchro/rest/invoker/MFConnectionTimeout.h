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
//  ConnectionTimeoutsChecker.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFContext.h"

@class MFConnectionTimeout;

/*!
 * @brief protocol de définition du delegate sur la gestion des timeouts
 */
@protocol TimeoutsCheckerDelegate

/*!
 * @brief appelé quand un timeout est atteint à la connexion
 */
-(void) onConnectionTimeoutReached:(MFConnectionTimeout *) timeoutChecker withContext:(MFContext *) ctx;

/*!
 * @brief appelé quand un timeout est atteint lors de la réception de données
 */
-(void) onDataTimeoutReached:(MFConnectionTimeout *) timeoutChecker withContext:(MFContext *) ctx;

@optional

/*!
 * @brief méthode optionnel du delegate, appelé à chaque seconde écoulée sur un timer
 */
-(void) timeoutCheckerTick:(MFConnectionTimeout *) timeoutChecker withContext:(MFContext *) ctx;

@end

/*!
 * @brief classe chargée de vérifier les dépassements sur les délais d'attente des réponses serveur
 */
@interface MFConnectionTimeout : NSObject

/*!
 * @brief timeout à la connexion
 */
@property (nonatomic) int connectionTimeout;

/*!
 * @brief timeout à la réception de données
 */
@property (nonatomic) int dataTimeout;

/*!
 * @brief delegate sur la classe permettant d'avoir un retour sur les timeout
 */
@property (nonatomic, retain) id<TimeoutsCheckerDelegate> delegate;

/*!
 * @brief initialise une instance de la classe
 * @param connection durée du timeout à la connexion
 * @param data durée du timeout à la réception de données
 * @param delegate de l'instance
 * @param context
 */
-(id) initWithConnectionTimeout:(int) connection withDataTimeout:(int) data withDelegate:(id<TimeoutsCheckerDelegate>) delegate withContext:(MFContext *) ctx;

/*!
 * @brief réinitialise le timeout de connection
 */
-(void) resetConnectionTimeout;

/*!
 * @brief arrête le timeout de connection
 */
-(void) stopConnectionTimeout;

/*!
 * @brief réinitialise le timeout de réception de données
 */
-(void) resetDataTimeout;

/*!
 * @brief arrête le timeout de réception de données
 */
-(void) stopDataTimeout;

/*!
 * @brief arrête les timers
 */
-(void) invalidate;

@end
