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
#import "MFContext.h"

typedef enum : NSInteger {
	Identified_OK,
	Identified_KO,
	Identified_KOCauseDate
} IdentifyResult;

@protocol MFLocalCredentialServiceProtocol <NSObject>

/*!
 * @brief permet de lancer une authentification locale et retourne le résultat
 */
- (IdentifyResult) doIdentifyWithLogin:(NSString *) login withContext:(MFContext *) context;

/*!
 * @brief stocke en base les identifiants de connexion
 */
- (void) storeCredentialsWithLogin:(NSString *) login withResource:(long) resource withContext:(MFContext *) context;

/*!
 * @brief supprime les identifiants de connexion de la base
 */
- (void) deleteLocalCredentialsWithContext:(MFContext *) context;

@end
