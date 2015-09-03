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
//  MFExportLogsAction.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreContext.h"
#import "MFCoreAction.h"

#import "MFExportLogsAction.h"

@implementation MFExportLogsAction

-(NSString *) prefixOfExportFiles{
    return @"yyyy'-'MM'-'dd'-'HH'-'mm'-'ss'-'" ;
}
/**
  * @brief does the copy of the log file to the Documents directory share in Itunes
  * Return the date time prefix of the new files
 */
-(id) doAction:(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch {
    MFCoreLogVerbose(@" MFExportLogsAction doAction parameterIn '%@' ", parameterIn ) ;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0] ;
    MFCoreLogVerbose(@" %@ documentsDirectory " , documentsDirectory ) ;
    
    NSDateFormatter *datetimeFormatter = [[NSDateFormatter alloc] init] ;
    [datetimeFormatter setLocale:[NSLocale currentLocale]];
    [datetimeFormatter setDateFormat:[@"'/'" stringByAppendingString:[self prefixOfExportFiles]]];
    [datetimeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *nowString = [datetimeFormatter stringFromDate:[[NSDate alloc] init] ] ;
    documentsDirectory = [documentsDirectory stringByAppendingString:nowString];
    
    DDFileLogger *logger = [MFLoggingHelper getFileLogger];
    for ( DDLogFileInfo *logFileInfo in [logger.logFileManager sortedLogFileInfos] ){
        NSString *destPath = [documentsDirectory stringByAppendingString:logFileInfo.fileName] ;
        
        if ( [[NSFileManager defaultManager] copyItemAtPath:logFileInfo.filePath toPath:destPath error:&error] == YES) {
            MFCoreLogVerbose(@" Export Logs OK dans '%@'  " , destPath ) ;
        } else {
            NSString *errorText = [NSString stringWithFormat:@" Export Logs KO from '%@' to '%@' , '%@' , '%@'" , logFileInfo.filePath ,destPath , error.localizedDescription , error.localizedFailureReason ];
            NSError *error2 = [[NSError alloc] initWithDomain:@"com.sopragroup.movalys.exportLogs"
                                                     code:2
                                                     userInfo:@{NSLocalizedDescriptionKey : errorText}];
            [context addErrors:@[error2]];
        }
    }    
    return nowString ;
}

@end
