//
//  MFContextTests.m
//  MFCore
//
//  Created by Lagarde Quentin on 02/09/2015.
//  Copyright (c) 2015 Sopra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <MFCore/MFCore.h>

@interface MFContextTests : XCTestCase

@property (nonatomic, strong) MFContext *context;

@end

@implementation MFContextTests

- (void)setUp {
    [super setUp];
    self.context = [[MFContext alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

}

- (void)testCreateContext {
    XCTAssertNotNil(self.context);
    XCTAssertNil(self.context.entityContext);
}

- (void)testMessages {
    MFMessage *newMessage = [[MFMessage alloc] initWithLocalizedDescription:@"localizedDescription" andCode:23 andLevel:1];
    [self.context addMessages:@[newMessage]];
    XCTAssertFalse([self.context hasError]);
    XCTAssertTrue([self.context messages].count > 0);
    XCTAssertFalse([self.context errors].count > 0);
}

- (void)testErrors {
    MFError *newError = [[MFError alloc] initWithCode:234 localizedDescriptionKey:@"localizedDescriptionKey" localizedFailureReasonErrorKey:@"failureReasonKey"];
    [self.context addErrors:@[newError]];
    XCTAssertTrue([self.context hasError]);
    XCTAssertFalse([self.context messages].count > 0);
    XCTAssertTrue([self.context errors].count > 0);
}

@end
