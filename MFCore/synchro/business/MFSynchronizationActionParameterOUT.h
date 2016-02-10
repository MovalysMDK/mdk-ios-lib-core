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
//  MFSynchronizationActionParameterOUT.h
//
//

#import <Foundation/Foundation.h>
#import "MFSynchronisationResponseTreatmentInformation.h"

/*!
 * @brief paramètres de sortie d'un action de synchronisation
 */
@interface MFSynchronizationActionParameterOUT : NSObject

/*! no object to synchronized */
@property (nonatomic, assign) BOOL resetObjectToSynchronise;

/*! authentification local */
@property (nonatomic, assign) BOOL localAuthentication;

/*! empty database synchronization failure */
@property (nonatomic, assign) BOOL emptyDBSynchronizationFailure;

/*! no connection to the server failure */
@property (nonatomic, assign) BOOL noConnectionSynchronizationFailure;

/*! interruption of the synchronization failure */
@property (nonatomic, assign) BOOL brokenSynchronizationFailure;

/*! error in the synchronization failure */
@property (nonatomic, assign) BOOL errorInSynchronizationFailure;

/*! error in the synchronization failure */
@property (nonatomic, assign) BOOL authenticationFailure;

/*! user waited too long before synchronizing */
@property (nonatomic, assign) BOOL waitedTooLongBeforeSync;

/*! user waited too long before synchronizing */
@property (nonatomic, assign) BOOL incompatibleServerMobileTimeFailure;

@property (nonatomic, retain) MFSynchronisationResponseTreatmentInformation *informations;

@property (nonatomic, retain) id nextScreen;

-(id) init;

@end
