//
//  MFSecurityTests.m
//  MFCore
//
//  Created by Lagarde Quentin on 03/09/2015.
//  Copyright (c) 2015 Sopra. All rights reserved.
//

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

-(void) testStorePassword {
    NSString *originalPassword = @"password";
    [MFKeychain storePasswordInKeychain:originalPassword];
    NSString *retrievedPassword = [MFKeychain retrievePasswordFromKeychain];
    XCTAssertEqualObjects(originalPassword, retrievedPassword);
}

-(void) testStoreOtherNonSecuredValues {
    NSDictionary *datas = @{@"UN":@"un", @"DEUX":@"two", @"TROIS":@"3"};
    for(NSString *key in [datas allKeys]) {
        [MFKeychain storeValueInKeychain:datas[key] forKey:key];
    }
    XCTAssertEqualObjects(datas[datas.allKeys[0]],[MFKeychain retrieveValueFromKeychainForKey:datas.allKeys[0]]);
    XCTAssertEqualObjects(datas[datas.allKeys[1]],[MFKeychain retrieveValueFromKeychainForKey:datas.allKeys[1]]);
    XCTAssertEqualObjects(datas[datas.allKeys[2]],[MFKeychain retrieveValueFromKeychainForKey:datas.allKeys[2]]);

    
}

@end
