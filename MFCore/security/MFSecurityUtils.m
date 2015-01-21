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
//  MFSecurityUtils.m
//  field-text
//
//
#import "MFCoreBean.h"

#import "MFSecurityUtils.h"
#import "MFSecurityHelperProtocol.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import "KeychainItemWrapper.h"

@implementation MFSecurityUtils


#pragma mark - Declared Methods

+(NSString *) MF_KEYCHAIN_SALT_KEY {
    return @"MF_KEYCHAIN_SALT_KEY";
}

+(NSString *) MF_KEYCHAIN_PASSWORD_ITEM_KEY {
    return @"MF_KEYCHAIN_PASSWORD_ITEM_KEY";
}

+(NSString *) generateSalt {
    NSString *symbols = [[self securityHelper] saltSymbols];
    int saltlength = [[self securityHelper] saltSize];
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:saltlength];
    for (int i=0; i<saltlength; i++) {
        [randomString appendFormat: @"%C", [symbols characterAtIndex: arc4random_uniform((UInt32)[symbols length]) % [symbols length]]];
    }
    return randomString;
}

/*!
 * @brief Returns the security helper from the bean factory
 * @return An id<MFSecurityHelperProtocol> that allows to custom security configuration
 */
+(id<MFSecurityHelperProtocol>)securityHelper {
    return [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_SECURITY_HELPER];
}

+(NSString *) saltValue {
    KeychainItemWrapper *keyChainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:MFSecurityUtils.MF_KEYCHAIN_SALT_KEY accessGroup:nil withKey:MFSecurityUtils.MF_KEYCHAIN_SALT_KEY];
    return [keyChainItemWrapper objectForKey:MFSecurityUtils.MF_KEYCHAIN_SALT_KEY];
}


+(NSString *) retrieveEncryptionSelector {
    NSString *selector = nil;
    switch([[MFSecurityUtils securityHelper] encryption]) {
        case MFSecurityEncryptionAES:
            selector = @"aesEncrypt:key:";
            break;
    }
    return selector;
}

+(NSString *) retrieveDecryptionSelector {
    NSString *selector = nil;
    switch([[MFSecurityUtils securityHelper] encryption]) {
        case MFSecurityEncryptionAES:
            selector = @"aesDecryptWithBase64:key:";
            break;
    }
    return selector;
}

@end



@implementation MFKeychain

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
+(void) storePasswordInKeychain:(NSString *)password {
    NSString *encryptionSelector = [MFSecurityUtils retrieveEncryptionSelector];
    CocoaSecurityResult *result = [[CocoaSecurity class] performSelector:NSSelectorFromString(encryptionSelector) withObject:password withObject:[MFSecurityUtils saltValue]];
    
    KeychainItemWrapper *keyChainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:MFSecurityUtils.MF_KEYCHAIN_PASSWORD_ITEM_KEY accessGroup:nil withKey:MFSecurityUtils.MF_KEYCHAIN_PASSWORD_ITEM_KEY];
    [keyChainItemWrapper setObject:result.base64 forKey:(__bridge id)kSecValueData];
}
#pragma clang diagnostic pop


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
+(NSString *) retrievePasswordFromKeychain {
    KeychainItemWrapper *passwordKeyChainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:MFSecurityUtils.MF_KEYCHAIN_PASSWORD_ITEM_KEY accessGroup:nil withKey:MFSecurityUtils.MF_KEYCHAIN_PASSWORD_ITEM_KEY];
    NSString *currentEncryptedfPassword = [passwordKeyChainItemWrapper objectForKey:(__bridge id)kSecValueData];
    
    
    NSString *decryptionSelector = [MFSecurityUtils retrieveDecryptionSelector];
    CocoaSecurityResult *result = [[CocoaSecurity class] performSelector:NSSelectorFromString(decryptionSelector) withObject:currentEncryptedfPassword withObject:[MFSecurityUtils saltValue]];
    
     
    return result.utf8String;
}
#pragma clang diagnostic pop



+(void) storeValueInKeychain:(NSString *)value forKey:(NSString *)key {
    KeychainItemWrapper *keyChainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil withKey:key];
    [keyChainItemWrapper setObject:value forKey:(__bridge id)kSecValueData];
}

+ (NSString *)retrieveValueFromKeychainForKey:(NSString *)key {
    KeychainItemWrapper *keyChainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil withKey:key];
    return [keyChainItemWrapper objectForKey:(__bridge id)kSecValueData];
}



@end
