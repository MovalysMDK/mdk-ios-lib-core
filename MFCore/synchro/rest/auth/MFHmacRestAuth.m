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


#import <CommonCrypto/CommonHMAC.h>
#import "MFHmacRestAuth.h"

@implementation MFHmacRestAuth

-(NSDictionary *) getAuthHeadersWithLogin:(NSString *) login withPassword:(NSString *) password withUrl:(NSString *) url withEntrypoint:(NSString *) entryPoint
{
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    
    NSString *auth = [NSString stringWithFormat:@"%@:%@", login, [self computeTokenWithLogin:login withPassword:password withUrl:url
                                                                              withEntrypoint:entryPoint]];
    
    [headers setObject:auth forKey:HEADER_TOKEN];
    
    return headers;
}

-(NSString *) computeTokenWithLogin:(NSString *) login withPassword:(NSString *) password withUrl:(NSString *) url withEntrypoint:(NSString *) entryPoint
{
    return [self encodeData:[url substringFromIndex:[entryPoint length]] withKey:[NSString stringWithFormat:@"%@__##__%@", login, password]];
}

-(NSString *) encodeData:(NSString*) data withKey:(NSString *) key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    return [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
