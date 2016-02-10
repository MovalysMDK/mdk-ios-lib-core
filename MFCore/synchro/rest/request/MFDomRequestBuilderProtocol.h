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
//  MFDomRequestBuilder.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFRestRequestProtocol.h"
#import "MFSynchronizationActionParameterIN.h"

/*!
 * @brief classe en charge de la construction d'une requête à partir de données autres que les entités du modèle
 */
@protocol MFDomRequestBuilderProtocol <NSObject>

/*!
 * @brief construit la requête passée en paramètre
 * @param restRequest requête à enrichir par l'instance
 * @param firstGoToServer s'agit-il de la première requête envoyée sur l'action de synchronisation en cours ?
 * @param paramsIn paramètres d'entrées de l'action
 * @param syncTimestamps dictionnaire contenant les dates de dernières synchronisation
 */
-(void) buildRequest:(NSObject<MFRestRequestProtocol> *) restRequest onFirstGoToServer:(BOOL) firstGoToServer withParamsIn:(MFSynchronizationActionParameterIN *) paramsIn withSyncTimestamp:(NSDictionary *) syncTimestamps;

@end
