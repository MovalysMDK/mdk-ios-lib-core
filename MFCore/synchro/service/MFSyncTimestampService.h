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
//  MFSyncTimestampService.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFContextProtocol.h"

/*!
 * @brief service de gestion des dates de synchronisation. Les entités correspondantes sont sauvegardées dans la table MParameter 
 * avec une clé préfixée par la chaine "synchro_timestamp_" (définie dans la constante SYNCHRO_TIMESTAMP_PREFIX)
 */
@interface MFSyncTimestampService : NSObject

/*!
 * @brief renvoie la liste des dates de synchronisation présentes en base
 * @param context
 * @return la liste des dates de synchronisation
 */
-(NSDictionary *) getSyncTimestampsWithContext:(id<MFContextProtocol>) context;

/*!
 * @brief sauvegarde en base les dates passées en paramètres
 * @param timeStampsToSave dictionnaire des timestamps à sauvegarder
 * @param context
 */
-(void) saveSyncTimestamps:(NSDictionary *) timeStampsToSave withContext:(id<MFContextProtocol>) context;

@end
