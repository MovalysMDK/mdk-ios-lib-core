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
//  MFSynchroProperty.h
//  MFCore
//
//

#import <Foundation/Foundation.h>

/*! definit un mode "mock" sur la synchro */
FOUNDATION_EXPORT NSString *const sync_mock_mode;

/*! code statut renvoyé lors de la synchro en mode "mock" */
FOUNDATION_EXPORT NSString *const sync_mock_testid;

/*! temps max entre chaque synchronisation */
FOUNDATION_EXPORT NSString *const synchronization_max_time_without_sync;

/*! gestion en case sensitive du login au serveur */
FOUNDATION_EXPORT NSString *const case_sensitive_login;
