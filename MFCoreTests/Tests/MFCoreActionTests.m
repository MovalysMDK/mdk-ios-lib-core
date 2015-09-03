//
//  MFCoreActionTests.m
//  MFCore
//
//  Created by Lagarde Quentin on 02/06/2015.
//  Copyright (c) 2015 Sopra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <MFCore/MFCore.h>
#import "MFEmptyAction.h"
#import "MFTestAssembly.h"

@interface MFCoreActionTests : XCTestCase

@end

@implementation MFCoreActionTests

- (void)setUp {
    [super setUp];
    MFBeanLoader *beanLoaderInstance = [MFBeanLoader getInstance];
    [beanLoaderInstance performSelector:@selector(registerComponentsFromAssembly:) withObject:[MFTestAssembly class]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testSimpleExample {
//    [[MFActionLauncher getInstance] launchAction:MFAction_MFEmptyAction withCaller:self withInParameter:nil];
//}

MFRegister_ActionListenerOnSuccess(MFAction_MFEmptyAction, testSimpleExampleActionSuccess)
-(void)testSimpleExampleActionSuccess:(id<MFContextProtocol>)context withCaller:(id)caller andResult:(id)result
{
    XCTAssertEqual(result, @"EMPTY ACTION");
}


@end
