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
//  MFDomEntityRequestBuilderProtocol.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFRestRequestProtocol.h"
#import "MFContext.h"

/*!
 * @brief classe abstraite définissant un constructeur de requête lié à une entité
 */
@interface MFAbstractDomEntityRequestBuilder : NSObject

/*!
 * @brief initialise l'instance avec la classe de l'entité qu'elle doit traiter
 */
-(id) initForClass:(Class) EntityClass;

/*!
 * @brief renvoie la classe de l'entité traitée par l'instance
 */
-(Class) getRootClass;

/*!
 * @brief met à jour la requête passée en paramètre pour les objets devant être synchronisés, correspondant à l'entité liée
 * @param objectToSync tableau des objets à synchroniser connus du client
 * @param restRequest requête à modifier par l'instance
 * @param synchedList liste des objets synchronisés à enrichir
 * @param context
 */
-(void) buildRequestFromObject:(NSArray *) objectToSync withRequest:(NSObject<MFRestRequestProtocol> *) restRequest withSynchedList:(NSMutableArray *) synchedList withContext:(MFContext *) context;

@end
