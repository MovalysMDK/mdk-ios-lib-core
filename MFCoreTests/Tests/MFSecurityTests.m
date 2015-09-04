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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <MFCore/MFCoreSecurity.h>

@interface MFSecurityTests : XCTestCase

@end

@implementation MFSecurityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 * ATTENTION : A faire :
 * En ligne de commande, les tests ci-dessous ne fonctionnent pas.
 */

//-(void) testStorePassword {
//    NSString *originalPassword = @"password";
//    [MFKeychain storePasswordInKeychain:originalPassword];
//    NSString *retrievedPassword = [MFKeychain retrievePasswordFromKeychain];
//    XCTAssertEqualObjects(originalPassword, retrievedPassword);
//}
//
//-(void) testStoreOtherNonSecuredValues {
//    NSDictionary *datas = @{@"UN":@"un", @"DEUX":@"two", @"TROIS":@"3"};
//    for(NSString *key in [datas allKeys]) {
//        [MFKeychain storeValueInKeychain:datas[key] forKey:key];
//    }
//    XCTAssertEqualObjects(datas[datas.allKeys[0]],[MFKeychain retrieveValueFromKeychainForKey:datas.allKeys[0]]);
//    XCTAssertEqualObjects(datas[datas.allKeys[1]],[MFKeychain retrieveValueFromKeychainForKey:datas.allKeys[1]]);
//    XCTAssertEqualObjects(datas[datas.allKeys[2]],[MFKeychain retrieveValueFromKeychainForKey:datas.allKeys[2]]);
//
//    
//}

@end
