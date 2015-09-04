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


#import <XCTest/XCTest.h>

//MF Imports
#import "MFTestAssembly.h"
#import <MFCore/MFCore.h>

extern void __gcov_flush();

@interface MFCoreTests : XCTestCase

@end

@implementation MFCoreTests

- (void)setUp
{
    [super setUp];
    MFBeanLoader *beanLoaderInstance = [MFBeanLoader getInstance];
    [beanLoaderInstance performSelector:@selector(registerComponentsFromAssembly:) withObject:[MFTestAssembly class]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

+ (void)tearDown {
    [super tearDown];
}



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/**
 * @test Retrieves a singleton from Beans Assembly, and a nil object from an unexisting bean name.
 * Checks if the singleton is not nil, if the unexisting bean returns a nil object, and that
 * the singleton is really a singleton.
 */
-(void) testBeanSingleton {
    MFBeanLoader *beanLoaderInstance = [MFBeanLoader getInstance];
    [beanLoaderInstance performSelector:@selector(registerComponentsFromAssembly:) withObject:[MFTestAssembly class]];

    MFCsvLoaderHelper *singletonTest = [beanLoaderInstance getBeanWithKey:@"csvLoaderHelper"];
    XCTAssertNotNil(singletonTest);
    
    MFCsvLoaderHelper *singletonBadTest = nil;
    @try {
        singletonBadTest = [beanLoaderInstance getBeanWithKey:@"pasDeBean"];
    }
    @catch (NSException *exception) {
        XCTAssertNil(singletonBadTest);
    }
    
    XCTAssertEqualObjects([beanLoaderInstance getBeanWithKey:@"csvLoaderHelper"], singletonTest);
}
#pragma clang diagnostic pop


@end
