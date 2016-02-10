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
//  MFJsonReadHelper.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFJsonObject.h"

/*!
 * @brief classe de lecture du flux json
 */
@interface MFJsonReader : NSObject

@property (nonatomic, retain) MFJsonObject *object;

/*!
 * @brief indique à l'instance le flux partiel qui va être traité
 */
-(BOOL) processMessagePart:(NSString *) p_message;

/*!
 * @brief parcourt le flux à la recherche d'un objet json, et indique si le résultat est positif
 */
-(BOOL) hasNext;

/*!
 * @brief renvoie le chemin courant atteint dans le flux
 */
-(NSString *) getCurrentPath;

@end
