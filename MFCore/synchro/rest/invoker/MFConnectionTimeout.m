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


#import "MFConnectionTimeout.h"

@implementation MFConnectionTimeout {
    NSTimer *timer;
    double startConnectionTime, startDataTime;
    id<MFContextProtocol> context;
    BOOL isConnectionTimeout, isDataTimeout;
}

-(id) initWithConnectionTimeout:(int) connection withDataTimeout:(int) data withDelegate:(id<TimeoutsCheckerDelegate>)delegate withContext:(id<MFContextProtocol>) ctx
{
    if (self = [super init]) {
        self.connectionTimeout = connection;
        self.dataTimeout = data;
        self.delegate = delegate;
        
        context = ctx;
        startConnectionTime = [[NSDate date] timeIntervalSince1970] * 1000;
        startDataTime = startConnectionTime;
        
        isConnectionTimeout = YES;
        isDataTimeout = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                     target: self
                                                   selector:@selector(timeoutTick)
                                                   userInfo: nil repeats:YES];
        });
    }
    
    return self;
}

-(void) resetConnectionTimeout
{
    startConnectionTime = [[NSDate date] timeIntervalSince1970] * 1000;
}

-(void) stopConnectionTimeout
{
    isConnectionTimeout = NO;
}

-(void) resetDataTimeout
{
    startDataTime = [[NSDate date] timeIntervalSince1970] * 1000;
}

-(void) stopDataTimeout
{
    isDataTimeout = NO;
}

-(void) invalidate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [timer invalidate];
        timer = nil;
    });
}

-(void) timeoutTick
{
    double current = [[NSDate date] timeIntervalSince1970] * 1000;
    if (isConnectionTimeout && current > startConnectionTime + self.connectionTimeout)
        [self.delegate onConnectionTimeoutReached:self withContext:context];
    if (isDataTimeout && current > startDataTime + self.dataTimeout)
        [self.delegate onDataTimeoutReached:self withContext:context];
    
    [self.delegate timeoutCheckerTick:self withContext:context];
}

@end
