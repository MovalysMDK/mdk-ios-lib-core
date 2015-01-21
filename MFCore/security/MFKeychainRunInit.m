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
//  MFKeychainRunInit.m
//  field-text
//
//

#import "MFKeychainRunInit.h"
#import "KeychainItemWrapper.h"
#import "MFSecurityUtils.h"
#import "MFCoreLog.h"

@interface MFKeychainRunInit ()

@end

@implementation MFKeychainRunInit

#pragma mark - MFRunInitProtocol methods

-(void)startUsingContext:(id<MFContextProtocol>)mfContext firstLaunch:(BOOL)firstLaunch {
    MFCoreLogInfo(@"MFKeyChainRunInit started");
    
    //Get the current salt value
    NSString *saltValue = [MFKeychain retrieveValueFromKeychainForKey:MFSecurityUtils.MF_KEYCHAIN_SALT_KEY];
    
    //If nil, create it and store in keychain
    if(!saltValue) {
        saltValue = [MFSecurityUtils generateSalt];
    }
    [MFKeychain storeValueInKeychain:saltValue forKey:MFSecurityUtils.MF_KEYCHAIN_SALT_KEY];
    saltValue = [MFKeychain retrieveValueFromKeychainForKey:MFSecurityUtils.MF_KEYCHAIN_SALT_KEY];

    MFCoreLogInfo(@"MFKeyChainRunInit ended");
}

@end
