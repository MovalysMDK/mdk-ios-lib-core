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
//  MFAbstractRestResponse.m
//  MFCore
//
//

#import "MFAbstractRestResponse.h"
#import "MFEntityAcks.h"
#import "MFAck.h"

@implementation MFAbstractRestResponse

@synthesize idMessage = _idMessage;
@synthesize resource = _resource;
@synthesize information = _information;
@synthesize acks = _acks;
@synthesize hasAcks = _hasAcks;
@synthesize isTerminated = _isTerminated;

-(id) init
{
    if (self = [super init]) {
        self.information = [[MFSynchronisationResponseTreatmentInformation alloc] init];
        self.acks = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void) addInsertOrUpdateAck:(NSString *) key withId:(NSNumber *) ackToAddId andVersion:(NSNumber *) version
{
    self.hasAcks = YES;
    
    MFEntityAcks *entityAck = [self.acks valueForKey:key];
    MFAck *ackToAdd = [[MFAck alloc] initWithId:ackToAddId andVersion:version];
    
    if (!entityAck) {
        entityAck = [[MFEntityAcks alloc] init];
        [entityAck setEntity:key];
        [self.acks setObject:entityAck forKey:key];
    }
    
    [[entityAck insertOrUpdate] addObject:ackToAdd];
}

-(void) addDeleteAck:(NSString *) key withId:(NSNumber *) ackToAddId
{
    self.hasAcks = YES;
    
    MFEntityAcks *entityAck = [self.acks valueForKey:key];
    MFAck *ackToAdd = [[MFAck alloc] initWithId:ackToAddId andVersion:0];
    
    if (!entityAck) {
        entityAck = [[MFEntityAcks alloc] init];
        [entityAck setEntity:key];
        [self.acks setObject:entityAck forKey:key];
    }
    
    [[entityAck delete] addObject:ackToAdd];
}

-(BOOL) isTerminated
{
    return self.isTerminated;
}

@end
