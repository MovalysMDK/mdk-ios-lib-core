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
//  MFLoggingHelper.m
//  MFCore
//
//

#import <CocoaLumberjack/DDLog.h>

#import "MFLoggingHelper.h"
#import "MFLoggingFormatter.h"
#import "MFCoreFoundationExt.h"

@implementation MFLoggingHelper

static unsigned long long const MAXIMUM_FILE_SIZE = 512 * 1024; /**< 512 KB */

static NSTimeInterval const ROLLING_FREQUENCY = 60 * 60 * 24; /**< 24 hour rolling */

static NSUInteger const MAXIMUM_NUMBER_OF_LOG_FILES = 7; /**< We only keep the last 7 log files */

/**
 * File used by the logger.
 */
static DDFileLogger *fileLogger;

+(void) initializeLogging:(int)loglevel
{
    // Use Registered Dynamic Logging to setup Log level for all classes
    // Loop through all registered classes and set default Log Level
    [[DDLog registeredClasses] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [DDLog setLevel:loglevel forClass:obj];
    }];
    
    // Setup 2 MFLoggingFormatter (one for each logger) because they are not thread safe

    MFLoggingFormatter *ttyMFLoggingFormatter = [[MFLoggingFormatter alloc] init];
    MFLoggingFormatter *fileMFLoggingFormatter = [[MFLoggingFormatter alloc] init];
    
    // Xcode Console log
#ifdef DEBUG
    DDTTYLogger *sharedTTYLogger = [DDTTYLogger sharedInstance];
    sharedTTYLogger.logFormatter = ttyMFLoggingFormatter;
    [DDLog addLogger:sharedTTYLogger];
#endif
    
    // File Logs
    // Configure some sensible defaults for an iOS application.
	//
	// Roll the file when it gets to be 512 KB or 24 Hours old (whichever comes first).
	//
	// Also, only keep up to 7 archived log files around at any given time.
	// We don't want to take up too much disk space.
    fileLogger = [[DDFileLogger alloc] init];
    fileLogger.maximumFileSize = MAXIMUM_FILE_SIZE; 
    fileLogger.rollingFrequency = ROLLING_FREQUENCY;
    fileLogger.logFileManager.maximumNumberOfLogFiles = MAXIMUM_NUMBER_OF_LOG_FILES;
    fileLogger.logFormatter = fileMFLoggingFormatter;
    [DDLog addLogger:fileLogger];
}

+(NSData *) retrieveLastLogFileWithPosition:(NSUInteger) position
{
    NSArray *paths = [[MFLoggingHelper getFileLogger].logFileManager sortedLogFilePaths];
    NSInteger index = paths.count - 1 - position;
    NSData *data = nil;
    if(index >= 0)
    {
        NSString *path = [paths objectAtIndex:index];
        MFCoreLogVerbose(@"log file paths : %@", paths);
        NSArray *lines = [MFLoggingHelper readLastlinesFrom:path NumberOfLinesToRead:0];
        data = [[lines componentsJoinedByString:@""] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        MFCoreLogVerbose(@"No log file available at position %lu", (unsigned long)position);
    }
    
    //zip file :
    
    return [data gzipDeflate];
}

/**
 * Extract the n last file's lines.
 * if n == 0 then extract the entire file.
 *
 * @param filePath : file path.
 * @param n Number of lines to read.
 */
+(NSArray *) readLastlinesFrom:(NSString *) filePath NumberOfLinesToRead:(int) n
{
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if(n == 0)
    {
        return @[content];
    }
    else
    {
        NSArray *components = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if(n < components.count)
        {
            return [components objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(components.count - 1 - n, n)]];
        }
        else
        {
            return components;
        }
    }
}

+(void) setFileLogger:(DDFileLogger *) file
{
    fileLogger = file;
}

+(DDFileLogger *) getFileLogger
{
    return fileLogger;
}

+(void)setLogLevel:(NSString *)logLevel {
    if (logLevel == nil) {
        ddLogLevel = mfStartLogLevel;
    }
    else if ([MFLOG_LEVEL_VERBOSE isEqualToString:logLevel]) {
        ddLogLevel = DDLogLevelVerbose;
    }
    else if ([MFLOG_LEVEL_WARNING isEqualToString:logLevel]) {
        ddLogLevel = DDLogLevelWarning;
    }
    else if ([MFLOG_LEVEL_DEBUG isEqualToString:logLevel]) {
        ddLogLevel = DDLogLevelVerbose;
    }
    else if ([MFLOG_LEVEL_INFO isEqualToString:logLevel]) {
        ddLogLevel = DDLogLevelInfo;
    }
    else if ([MFLOG_LEVEL_ERROR isEqualToString:logLevel]) {
        ddLogLevel = DDLogLevelError;
    }
}

@end
