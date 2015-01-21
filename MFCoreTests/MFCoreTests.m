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
//  MFCoreTests.m
//  MFCoreTests
//
//  Created by Laurent Michenaud on 10/10/2014.
//  Copyright (c) 2014 Sopra Consulting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

//MF Imports
#import "MFBuilderForm.h"
#import "MFFormBuilderProtocol.h"
#import "MFLocalizedString.h"
#import "MFCoreSecurity.h"
#import "MFBeanLoader.h"
#import "MFTestAssembly.h"
#import "MFURL.h"
#import "MFCsvLoaderHelper.h"

extern void __gcov_flush();

@interface MFCoreTests : XCTestCase

@end

@implementation MFCoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

+ (void)tearDown {
    __gcov_flush();
    [super tearDown];
}

-(void) testFormBuilder {
    MFBuilderForm *formBuilder = [[MFBuilderForm alloc] init];
    XCTAssertNil([formBuilder buildFromPlistFileName:@"fakeFile"]);
    XCTAssertTrue([formBuilder conformsToProtocol:@protocol(MFFormBuilderProtocol)]);
}

-(void) testLocalizedString {
    XCTAssertEqual(MFLocalizedStringFromKey(@"BasicTest"), @"BasicTest");
}

-(void) testBeanSingleton {
    MFBeanLoader *beanLoaderInstance = [MFBeanLoader getInstance];
    [beanLoaderInstance performSelector:@selector(registerComponentsFromAssembly:) withObject:[MFTestAssembly class]];

    MFCsvLoaderHelper *singletonTest = [beanLoaderInstance getBeanWithKey:@"csvLoaderHelper"];
    XCTAssertNotNil(singletonTest);
    }

-(void) testURL {
    
    XCTAssertEqual(MFLocalizedStringFromKey(@"BasicTest"), @"BasicTest");
}

//Impossible sur un simulateur...
//-(void) testSecurity {
//    MFBeanLoader *beanLoaderInstance = [MFBeanLoader getInstance];
//    [beanLoaderInstance performSelector:@selector(registerComponentsFromAssembly:) withObject:[MFTestAssembly class]];
//    [MFKeychain storePasswordInKeychain:@"MyPasswordForTest"];
//    XCTAssertEqualObjects([MFKeychain retrievePasswordFromKeychain], @"MyPasswordForTest");
//    
//    NSDictionary *testDictionary = @{@"Nom" : @"DUPONT", @"Prenom" : @"Eric"};
//    [MFKeychain storeValueInKeychain:[testDictionary description] forKey:@"tester"];
//    
//    XCTAssertEqualObjects([testDictionary description] , [MFKeychain retrieveValueFromKeychainForKey:@"tester"]);
//}





@end
