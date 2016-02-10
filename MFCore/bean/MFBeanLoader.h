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
//  BeanLoader.h
//  MFCore
//
//

@interface MFBeanLoader : NSObject

/*!
 * @brief donne l'unique instance du starter
 */
+(MFBeanLoader *)getInstance;

/*!
 * @brief retourne un bean d'après la clé key
 * @param key : La clé du bean que l'on souhaite récupérer
 * @return un bean si le composant existe ou une exception si le composant n'est pas paramétré
 */
- (id) getBeanWithKey:(NSString *)key;

/*!
 * @brief retourne un bean d'après la clé key
 * @param key : La clé du bean que l'on souhaite récupérer
 * @return un bean si le composant existe ou 'nil' si le composant n'est pas paramétré
 */
- (id) getOptionalBeanWithKey:(NSString *)key;

/*!
 * @brief retourne un bean d'après un type de Classe ou Protocole
 * @param classOrProtocol : La classe ou le protocole dont oon souhaite récupérer un bean
 * @return un bean si le composant existe ou une exception si le composant n'est pas paramétré */
- (id) getBeanWithType:(id)classOrProtocol;

/*!
 * @brief retourne tous les beans d'après un type de Classe ou Protocole
 * @param classOrProtocol : La classe ou le protocole dont on souhaite récupérer un bean
 */
- (NSArray*) getAllBeansWithType:(id)classOrProtocol;

@end
