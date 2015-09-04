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


#import "MFAuthHelper.h"
#import "MFAESUtil.h"

#define kSharpSymbol [NSString stringWithFormat:@"\u0266F"]

NSString *const PASSWD_PREFIX = @"pass=";

@implementation MFAuthHelper

+(MFAuthHelper *) getInstance
{
    static MFAuthHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(NSString *) extractPassword:(NSData *) password withLogin:(NSString *) login withPrecision:(long) datePrecision
{
    long date = CFAbsoluteTimeGetCurrent() / pow(10, datePrecision);
    
    NSString *result = [MFAESUtil decryptText:[NSString stringWithUTF8String:[password bytes]]  WithSeed:[self computeSeedWithLogin:login withDate:date]];
    
    if ([result hasPrefix:PASSWD_PREFIX]) result = [result substringFromIndex:[PASSWD_PREFIX length]];
    
    return result;
}

-(NSData *) cryptPassword:(NSString *) password withLogin:(NSString *) login withPrecision:(long) datePrecision
{
    long date = CFAbsoluteTimeGetCurrent() / pow(10, datePrecision);
    
    return [[MFAESUtil encryptText:[NSString stringWithFormat:@"%@%@", PASSWD_PREFIX, password] WithSeed:[self computeSeedWithLogin:login withDate:date]] dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *) computeSeedWithLogin:(NSString *) login withDate:(long) date
{
    return [NSString stringWithFormat:@"//PP|18.20d%@&rt12%li%@%%Pom36%lu", login, date, kSharpSymbol, (unsigned long)([login length] * 987)];
}



@end
