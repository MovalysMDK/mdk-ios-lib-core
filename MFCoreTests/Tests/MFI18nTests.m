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
