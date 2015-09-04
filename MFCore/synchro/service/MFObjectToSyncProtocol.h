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


#import <Foundation/Foundation.h>
#import "MFContextProtocol.h"

/*!
 * @brief protocol définissant les méthodes nécessaires au service de gestion des objets à synchroniser
 */
@protocol MFObjectToSyncProtocol <NSObject>

/*!
 * @brief renvoie un dictionnaire contenant les objets devant être synchronisés ayant pour clé la classe de l'objet
 * @return dictionnaire des objets à synchroniser
 */
-(NSDictionary *) getObjectsToSyncWithContext:(id<MFContextProtocol>) context;

/*!
 * @brief méthode permettant de vérifier qu'un objet de type et d'identifiant donné est dans la liste des objets à synchroniser
 * @param objectType type de l'objet (le nom de sa classe)
 * @param identifier identifiant unique de l'objet en base
 * @param context
 * @return vrai si l'objet existe dans la liste des objets à synchroniser, faux sinon
 */
-(BOOL) isSynchronizedObject:(NSString *) objectType withIdentifier:(NSNumber *) identifier withContext:(id<MFContextProtocol>) context;

/*!
 * @brief supprime une liste d'objets passée en paramètre de la liste des objets à synchroniserr
 * @param objects liste des objets à supprimer
 * @param context
 */
-(void) deleteObjectToSynchronize:(NSArray *) objects withContext:(id<MFContextProtocol>) context;

/*!
 * @brief supprime un objet de la liste des objets à synchroniser d'après son type et son identifiant
 * @param objectType type de l'objet (le nom de sa classe)
 * @param identifier identifiant unique de l'objet en base
 * @param context
 */
-(void) deleteObjectToSynchronizeByType:(NSString *) objectType andIdentifier:(NSNumber *) identifier withContext:(id<MFContextProtocol>) context;

@end
