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


#import "MFmd5.h"
#import "MFAESUtil.h"
#import "NSData+AES256.h"



NSString * const DEFAULTPASSKEY = @"24524MovalysFramework6546384354";

@implementation MFAESUtil

#pragma mark public methods
+(NSString *) encryptText:(NSString *) text WithSeed:(NSString *) seed
{
    NSString *key = [MFAESUtil getRawKeyFromData:[seed dataUsingEncoding:NSUTF8StringEncoding]];
    return [MFAESUtil encryptText:text WithSeed:seed withKey:key];
}

+(NSString *) encryptText:(NSString *) text WithSeed:(NSString *) seed withKey:(NSString *) key
{
    NSData *dataText = [text dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithUTF8String:[[MFAESUtil encryptData:dataText withKey:key] bytes]];
}

+(NSString *) encryptText:(NSString *) text
{
    NSData *dataText = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *key = [MFAESUtil getRawKeyFromData:[DEFAULTPASSKEY dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSString stringWithUTF8String:[[MFAESUtil encryptData:dataText withKey:key] bytes]];
}

+(NSString *) decryptText:(NSString *) text WithSeed:(NSString *) seed
{
    NSData *dataText = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *key = [MFAESUtil getRawKeyFromData:[seed dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSString stringWithUTF8String:[[MFAESUtil decryptData:dataText withKey:key] bytes]];
}

+(NSString *) decryptText:(NSString *) text
{
    NSData *dataText = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *key = [MFAESUtil getRawKeyFromData:[DEFAULTPASSKEY dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [MFAESUtil decryptData:dataText withKey:key];
    NSString *decrypteddata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [NSString stringWithUTF8String:[decrypteddata cStringUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark private methods
+(NSData *) encryptData:(NSData *) data withKey:(NSString *) key
{
    return [data AES256EncryptWithKey:key];
}

+(NSData *) decryptData:(NSData *) data withKey:(NSString *) key
{
    return [data AES256DecryptWithKey:key];
}

+(NSString *) getRawKeyFromData:(NSData *) data
{
    return [data md5];
}

@end
