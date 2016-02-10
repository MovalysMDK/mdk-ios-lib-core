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
//  ActionProtocol.h
//  MFCore
//
//

#import "MFCoreContext.h"

#import "MFActionQualifierProtocol.h"
#import "MFActionProgressMessageDispatcher.h"

/*!
 * @brief caractérise une action
 */
@protocol MFActionProtocol <NSObject>

/*!
 * @brief donne le qualifier associé à l'action, si l'action n'a pas de qualifier, le qualfier par défaut est utilisé
 * @return le qualifier à utiliser
 */
@optional - (id<MFActionQualifierProtocol>) getBasicActionQualifier;

/*!
 * @brief l'action métier
 * @param parameterIn le paramètre d'entrée
 * @param context le context à utiliser
 * @param qualifier le qualifier utilisé pour le lancement, peut être différent de getBasicActionQualifier
 * @param dispatch le dispatcher à utiliser pour envoyer des messages
 */
@required - (id) doAction :(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch;

/*!
 * @brief appelé en cas de succès
 * @param parameterOut le paramètre de sortie du doAction
 * @param context le context à utiliser
 * @param qualifier le qualifier utilisé pour le lancement, peut être différent de getBasicActionQualifier
 * @param dispatch le dispatcher à utiliser pour envoyer des messages
 * @return le paramètre de sortie
 */
@optional - (id) doOnSuccess:(id) parameterOut withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch;

/*!
 * @brief appelé en cas d'échec
 * @param parameterOut le paramètre de sortie du doAction
 * @param context le context à utiliser
 * @param qualifier le qualifier utilisé pour le lancement, peut être différent de getBasicActionQualifier
 * @param dispatch le dispatcher à utiliser pour envoyer des messages
 * @return le paramètre de sortie
 */
@optional - (id) doOnFailed:(id) parameterOut withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch;


/*!
 * @brief True if action doesnot write anything to coredata
 * @return true if action doesnot write anything to coredata
 */
@optional - (BOOL) isReadOnly ;

@end
