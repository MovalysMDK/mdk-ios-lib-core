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


/*! type de configuration Propriété */
#define CONF_PROPERTY @"property_"
/*! type de configuration visuelle */
#define CONF_VISUAL @"visual_"
/*! type de configuration entitée */
#define CONF_ENTITY @"entity_"

/*!
 * @brief représente une configuration abstraite
 * Une configuration est caractérisée par son nom et son type, ces deux éléments sont utilisés dans le calcul de la clé utilisé par le handler
 */
@interface MFAbstractConfiguration : NSObject

/*!
 * @brief le nom de la configuration
 */
@property(nonatomic) NSString *name;

/*!
 * @brief le type de la propriété : CONF_PROPERTY, CONF_VISUAL ou CONF_ENTITY
 */
@property(nonatomic) NSString *type;

/*!
 * @brief permet de calculer la clé de registre
 * @return la clé du registre : name + "_" + type
 */
- (NSString *) getKey;
@end
