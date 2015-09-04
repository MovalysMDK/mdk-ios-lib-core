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
#import <MFCore/MFCore.h>

@interface MFPropertyTests : XCTestCase

@property (nonatomic, strong) MFProperty *property;

@end

@implementation MFPropertyTests

- (void)setUp {
    [super setUp];
    self.property = [[MFProperty alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.property.value = nil;
}

/**
 * @test Test a number MFProperty
 */
- (void)testNumber {
    NSNumber *number = @3;
    self.property.value = number;
    XCTAssertEqualObjects([self.property getNumberValue], @3);
    XCTAssertNil([self.property getDictionaryValue]);
    XCTAssertNil([self.property getArray]);
    XCTAssertNil([self.property getStringValue]);
    XCTAssertTrue([self.property getBOOLValue]);
}

/**
 * @test Test a dictionary MFProperty
 */
- (void)testDictionary {
    NSDictionary *dict = @{@3:@"3", @"deux":@2};
    self.property.value = dict;
    XCTAssertEqualObjects([self.property getDictionaryValue], dict);
    XCTAssertNil([self.property getNumberValue]);
    XCTAssertNil([self.property getArray]);
    XCTAssertNil([self.property getStringValue]);
    XCTAssertTrue([self.property getBOOLValue]);
}

/**
 * @test Test an array MFProperty
 */
- (void)testArray {
    NSArray *array = @[@1, @"deux", @(3.0)];
    self.property.value = array;
    XCTAssertEqualObjects([self.property getArray], array);
    XCTAssertNil([self.property getDictionaryValue]);
    XCTAssertNil([self.property getNumberValue]);
    XCTAssertNil([self.property getStringValue]);
    XCTAssertTrue([self.property getBOOLValue]);
}

/**
 * @test Test a string MFProperty
 */
- (void)testString {
    NSString *string= @"2";
    self.property.value = string;
    XCTAssertEqualObjects([self.property getStringValue], string);
    XCTAssertNil([self.property getDictionaryValue]);
    XCTAssertNil([self.property getArray]);
    XCTAssertNil([self.property getNumberValue]);
    XCTAssertTrue([self.property getBOOLValue]);
}

/**
 * @test Test a BOOL MFProperty
 */
- (void)testBool {
    self.property.value = @(YES);
    XCTAssertEqualObjects([self.property getNumberValue], @1);
    XCTAssertNil([self.property getDictionaryValue]);
    XCTAssertNil([self.property getArray]);
    XCTAssertNil([self.property getStringValue]);
    XCTAssertTrue([self.property getBOOLValue]);
    
    
    self.property.value = @(NO);
    XCTAssertEqualObjects([self.property getNumberValue], @0);
    XCTAssertNil([self.property getDictionaryValue]);
    XCTAssertNil([self.property getArray]);
    XCTAssertNil([self.property getStringValue]);
    XCTAssertFalse([self.property getBOOLValue]);
    
}


@end
