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
//  MFSynchronisationResponseTreatmentInformation.h
//
//

/*!
 * Contient les informations de traitement de résultat.
 * Cette classe sera donnée au classe listener de la synchronisation
 *
 */

#import <Foundation/Foundation.h>

@interface MFSynchronisationResponseTreatmentInformation : NSObject

/*! ensemble des types de données impactées par la synchro */
@property (nonatomic, retain) NSMutableArray *impactedClasses;

/*!
 * @brief vérifie si une classe est impactée par la synchro
 */
-(BOOL) containsOne:(Class) pClass;

/*!
 * @brief remet à 0 le tableau des classes impactées
 */
-(void) clear;

/*!
 * @brief ajoute les classes de l'objet passé en paramètre à celles traitées pas l'objet
 */
-(void) complete:(MFSynchronisationResponseTreatmentInformation *) information;

@end
