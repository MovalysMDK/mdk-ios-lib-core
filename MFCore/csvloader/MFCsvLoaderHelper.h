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


@interface MFCsvLoaderHelper : NSObject

@property(nonatomic,strong,readonly) NSDateFormatter *datetimeFormatter ;

@property(nonatomic,strong,readonly) NSDateFormatter *dateFormatter ;

@property(nonatomic,strong,readonly) NSNumberFormatter *numberFormatter ;

@property(nonatomic,strong,readonly) NSNumberFormatter *floatFormatter ;

/*!
 * @brief initialize singleton instance
 * @return singleton instance
 */
-(id)init ;

-(NSNumber *) convertCsvStringToInteger:(NSString *) p_stringValue ;

-(NSDate *)   convertCsvStringToDate:(NSString *) p_stringValue ;

-(NSNumber *) convertCsvStringToDouble:(NSString *) p_stringValue ;

-(NSNumber *) convertCsvStringToFloat:(NSString *) p_stringValue ;

-(NSNumber *) convertCsvStringToBoolean:(NSString *) p_stringValue ;

@end
