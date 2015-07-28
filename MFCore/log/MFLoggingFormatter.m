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
//  MFLoggingFormatter.m
//  Step2
//
//

#import "MFLoggingFormatter.h"

@interface MFLoggingFormatter () {
    int loggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end

@implementation MFLoggingFormatter

-(id)init {
    
    if((self = [super init])) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [threadUnsafeDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    }
    
    return self;
}

-(NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *logLevel;
    
    switch (logMessage->_flag) {
        case DDLogFlagError : logLevel = @"ERROR"; break;
        case DDLogFlagWarning  : logLevel = @"WARN"; break;
        case DDLogFlagInfo  : logLevel = @"INFO"; break;
        case DDLogFlagDebug  : logLevel = @"DEBUG"; break;
        case DDLogFlagVerbose  : logLevel = @"VERBOSE"; break;
        default             : logLevel = @"VERBOSE"; break;
    }
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"%@ - %@: %@", dateAndTime, logLevel, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger
{
    loggerCount++;
    NSAssert(loggerCount <= 1, @"This logger isn't thread-safe because it uses an NSDateFormatter");
}
- (void)willRemoveFromLogger:(id <DDLogger>)logger
{
    loggerCount--;
}

@end
