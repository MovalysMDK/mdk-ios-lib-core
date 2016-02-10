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
//  MFSubStarter.h
//  MFCore
//
//

#import "MFCoreContext.h"

/*!
 * @brief Permet de définir une classe devant être lancée au démarrage de l'application
 * On distingue les classes de démarrage framework : déclaré dans la plist "Framework", avec le nom "StarterFwk"
 * et les classes de démarrage projet : déclaré dans la plist "Project" avec le nom "StarterProject"
 */
@protocol MFRunInitProtocol <NSObject>

/*!
 * @brief lance le traitement
 */
- (void) startUsingContext:(id<MFContextProtocol>)mfContext firstLaunch:(BOOL) firstLaunch;

@end
