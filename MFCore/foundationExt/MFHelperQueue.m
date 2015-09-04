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


#import "MFHelperQueue.h"

static void *const ConstMainQueue = (void *)&ConstMainQueue;

@implementation MFHelperQueue

+(void) configureMainQueue {
    //Configuration de la queue principale
    void *nonNullValue = ConstMainQueue; // Whatever, just not null
    dispatch_queue_set_specific(dispatch_get_main_queue(), ConstMainQueue, nonNullValue, NULL);
}


+(BOOL) isInMainQueue {
    // ce code est deprecated : return (dispatch_get_main_queue() == dispatch_get_current_queue());
    return (dispatch_get_specific(ConstMainQueue) != NULL);
}

+(void) execInMainQueue:(void (^)())bloc {
    //Si deja dans le bon thread : synchrone
    //Sinon asynchrone
    if ( [self isInMainQueue] ) {
        bloc();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            bloc();
        });
    }
}

+(void) execSyncInMainQueue:(void (^)())bloc {
    if ( [self isInMainQueue] ) {
        bloc();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            bloc();
        });
    }
}

@end
