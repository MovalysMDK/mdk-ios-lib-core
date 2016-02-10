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
//  MFSecurityUtils.h
//  field-text
//
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

/*!
 * @brief Utils class to use with security module
 */
@interface MFSecurityUtils : NSObject

#pragma mark - Static methods

/*!
 * @brief Returns the key to store salt in Keychain
 * @return The key to store salt in Keychain
 */
+(NSString *) MF_KEYCHAIN_SALT_KEY;

/*!
 * @brief Returns the key to store password in Keychain
 * @return The key to store password in Keychain
 */
+(NSString *) MF_KEYCHAIN_PASSWORD_ITEM_KEY;

/*!
 * @brief Returns a random generated salt value
 * @return A random generated salt value
 */
+(NSString *) generateSalt;

@end


/*!
 * @brief Movalys Keychain class.
 * It's used to store and retrieve and encrypted user password in secure ios keychain.
 * It also should be used to store any "secure" values with given accessors.
 */
@interface MFKeychain : NSObject

#pragma mark - Static methods

/*!
 * @brief Allows to store the user password in Keychain.
 * This value is encrypted with a generated salt value created on the first launch of
 * the application before to be stored.
 * @param password The given clear password value to encrypt and store in the secure keychain
 */
+(void) storePasswordInKeychain:(NSString *)password;

/*!
 * @brief This method retrieves the user password after decryption
 * @return key The user decrypted password retrieved from iOS secure Keychain
 */
+(NSString *) retrievePasswordFromKeychain;

/*!
 * @brief Allows to store a value in secure keychain
 * @param value A value to store in the keychain
 * @param key The key used to store and retrieve the value in/from the keychain
 */
+(void) storeValueInKeychain:(NSString *)value forKey:(NSString *)key;

/*!
 * @brief This method retrieves a value from the iOS secure Keychain depending on the given key
 * @param key The key used to retieve a value from the iOS secure Keychain
 * @return The retrieved value from the iOS secure Keychain for the given key
 */
+(NSString *) retrieveValueFromKeychainForKey:(NSString *)key;

@end
