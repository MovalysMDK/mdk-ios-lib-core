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
//  MFLocalizedString.h
//  MFCore
//
//

FOUNDATION_EXPORT NSString *const CONST_FRAMEWORK_LOCALIZED_STRING;
FOUNDATION_EXPORT NSString *const CONST_PROJECT_LOCALIZED_STRING;

/*!
 * Cette macro permet d'appeller MFLocalizedString de la même manière que NSLocalizedString
 */
#define MFLocalizedStringFromKey(key)                   \
[MFLocalizedString localizableStringFromKey:key]        \



@interface MFLocalizedString : NSObject

/*!
 * @brief Cette méthode permet de recherche un chaîne de caractère dans les différentes tables
 * (Framework et Project) des Localizable-string.
 * @param key La clé de la chaîne à rechercher
 * @return La chaîne de caractère trouvée, ou la clé elle-même si aucune chaîne n'a été trouvée 
 */
+(NSString *)localizableStringFromKey:(NSString *)key;
@end
