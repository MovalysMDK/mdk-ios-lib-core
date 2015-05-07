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
//  MFCsvLoaderHelper.m
//  MFCore
//
//

#import "MFCsvLoaderHelper.h"

@implementation MFCsvLoaderHelper


static NSString *const CONST_DATE_TIME_FORMAT = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss";
static NSUInteger const CONST_DATE_TIME_FORMAT_LENGTH = 19 ;

static NSString *const CONST_DATE_FORMAT = @"yyyy'-'MM'-'dd";
static NSUInteger const CONST_DATE_FORMAT_LENGTH = 10;

static NSString *const CONST_DECIMAL_SEPARATOR = @".";
static NSString *const CONST_GROUPING_SEPARATOR = @"";
/**
  * Initialize the formatter used to convert data from CSV
  * Decimal separator "." . International Date formats with '/' like @"yyyy'/'MM'/'dd"
  */
-(id) init
{
    if (self = [super init]) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setLocale:[NSLocale currentLocale]];
        [_numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        [_numberFormatter setDecimalSeparator:CONST_DECIMAL_SEPARATOR];
        [_numberFormatter setGroupingSeparator:CONST_GROUPING_SEPARATOR];
        [_numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_numberFormatter setMaximumFractionDigits:0];
        [_numberFormatter setAllowsFloats:NO];
        
        _floatFormatter = [[NSNumberFormatter alloc] init];
        [_floatFormatter setLocale:[NSLocale currentLocale]];
        [_floatFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_floatFormatter setDecimalSeparator:CONST_DECIMAL_SEPARATOR];
        [_floatFormatter setGroupingSeparator:CONST_GROUPING_SEPARATOR];
        [_floatFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_floatFormatter setAllowsFloats:YES];
        
        _datetimeFormatter = [[NSDateFormatter alloc] init];
        [_datetimeFormatter setLocale:[NSLocale currentLocale]];
        [_datetimeFormatter setDateFormat:CONST_DATE_TIME_FORMAT];
        [_datetimeFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [_datetimeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDateFormat:CONST_DATE_FORMAT];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return self ;
}

-(NSNumber *) convertCsvStringToInteger:(NSString *) p_stringValue {
    return [_numberFormatter numberFromString:p_stringValue];
}
-(NSDate *) convertCsvStringToDate:(NSString *) p_stringValue {
    
    if ( [p_stringValue length] == CONST_DATE_TIME_FORMAT_LENGTH){
        return [_datetimeFormatter dateFromString:p_stringValue];
    } else if ([p_stringValue length] == CONST_DATE_FORMAT_LENGTH ){
        return [_dateFormatter dateFromString:p_stringValue];
    }
    return nil ;
}
-(NSNumber *) convertCsvStringToFloat:(NSString *) p_stringValue {
    return [_floatFormatter numberFromString:p_stringValue];
}
-(NSNumber *) convertCsvStringToDouble:(NSString *) p_stringValue {
    return [_floatFormatter numberFromString:p_stringValue];
}
-(NSNumber *) convertCsvStringToBoolean:(NSString *) p_stringValue {
    if ( [p_stringValue isEqualToString:@"yes"] || [p_stringValue isEqualToString:@"YES"]
        || [p_stringValue isEqualToString:@"true"] || [p_stringValue isEqualToString:@"TRUE"] ){
        return [[NSNumber alloc] initWithBool:YES] ;
    }    
    return [[NSNumber alloc] initWithBool:NO];
}

@end
