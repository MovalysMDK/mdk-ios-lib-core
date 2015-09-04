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


@protocol MFSecurityHelperProtocol <NSObject>

#pragma mark - Variables

typedef enum {
    MFSecurityEncryptionAES = 0
} MFSecurityEncryption;


#pragma mark - Methods

/*!
 * @brief Returns the salt length (default 128)
 * @return The salt length (default 128)
 */
@optional
-(int) saltSize;

/*!
 * @brief Returns the symbols to use to generate salt, as as string
 * (default is @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
 * @return The symbols to use to generate salt
 */
@optional
-(NSString *) saltSymbols;

@optional
/*!
 * @brief Returns a MFSecurityEncryption value that indicates the encryption to use.
 * @return A MFSecurityEncryption value that indicates the encryption to use.
 */
-(MFSecurityEncryption) encryption;

@end
