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
//  MFActionProgressMessageDispatcher.h
//  MFCore
//
//

#import "MFCoreContext.h"

/*!
 *  @brief cette permet de dispatcher un message pendant l'exécution d'une action, cette classe est lié à une action en cours
 */
@interface MFActionProgressMessageDispatcher : NSObject

/*!
 * @brief l'objet ayant lancé l'action en cours
 */
@property (weak, nonatomic) id caller;

/*!
 * @brief le nom de l'action en cours
 */
@property (strong, nonatomic) NSString *actionName;

/*!
 * @brief dispatch un message
 * @param step l'état d'avancement de l'action
 * @param un paramètre passé à chaque état
 * @param context le context à utiliser
 */
- (void) dispatchProgressMessage : (NSString *) step withParam: (id) object andContext:(id<MFContextProtocol>) context;

@end
