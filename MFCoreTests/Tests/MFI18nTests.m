//
//  MFI18nTests.m
//  MFCore
//
//  Created by Lagarde Quentin on 03/09/2015.
//  Copyright (c) 2015 Sopra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <MFCore/MFCoreI18n.h>



@interface MFI18nTests : XCTestCase

@end

@implementation MFI18nTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 * @test Checks a Localizable-framework string is retrieved
 */
-(void) testFrameworkString {
    XCTAssertEqualObjects(@"GHI", TestLocalizedStringFromKey(@"chaine_test_2", [self class]));
}

/**
 * @test Checks a Localizable-project string is retrieved
 */
-(void) testProjectString {
    XCTAssertEqualObjects(@"JKL", TestLocalizedStringFromKey(@"chaine_test_3", [self class]));
}

/**
 * @test Checks a Localizable-project string is retrieved, for a 
 * string declared both in Localizable-framework AND in Localizable-project
 */
-(void) testOverloadedString {
    XCTAssertEqualObjects(@"DEF", TestLocalizedStringFromKey(@"chaine_test_1", [self class]));
}

/**
 * @test Checks an unexisting Localizable string returns the key value
 */
-(void) testUnexistingString {
    XCTAssertEqualObjects(@"chaine_test_4", TestLocalizedStringFromKey(@"chaine_test_4", [self class]));
}
@end
