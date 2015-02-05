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
//  MFLoggingHelper.h
//  MFCore
//
//

#import <CocoaLumberjack/DDFileLogger.h>

#import "MFCoreLogging.h"

@interface MFLoggingHelper : NSObject

/*!
 * Initialize the logging system.
 */
+(void) initializeLogging:(int)loglevel;

/*!
 * Return the n-th last file.
 * If position == 0 then return the last file.
 * If position == 1 then return the second last file.
 * ...
 *
 * @param position : number of files to return.
 * @return content of the file
 */
+(NSData *) retrieveLastLogFileWithPosition:(NSUInteger) position;
/*!
 * Modify the file logger
 * @param new file logger of the application
 */
+(void) setFileLogger:(DDFileLogger *) file ;
/*!
 * Return the file logger
 * @return file logger of the application
 */
+(DDFileLogger *) getFileLogger ;

+(void) setLogLevel:(NSString *)logLevel;

@end
