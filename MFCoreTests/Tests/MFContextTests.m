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
#import <CoreData/CoreData.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "LinkEntity.h"


@interface MFContextTests : XCTestCase

@property (nonatomic, strong) MFContext *context;

@end

@implementation MFContextTests

- (void)setUp {
    [super setUp];
    self.context = [[MFContext alloc] init];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    [MagicalRecord setDefaultModelFromClass:[self class]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];

}

/**
 * @test Checks if the created context is not nil
 */
- (void)testCreateContext {
    XCTAssertNotNil(self.context);
    XCTAssertNil(self.context.entityContext);
}

/**
 * @test Add a message in the context and checks it's not considered as an error
 */
- (void)testMessages {
    MFMessage *newMessage = [[MFMessage alloc] initWithLocalizedDescription:@"localizedDescription" andCode:23 andLevel:1];
    [self.context addMessages:@[newMessage]];
    XCTAssertFalse([self.context hasError]);
    XCTAssertTrue([self.context messages].count > 0);
    XCTAssertFalse([self.context errors].count > 0);
}

/**
 * @test Add an error to the context and checks that it's considered as an error
 */
- (void)testErrors {
    MFError *newError = [[MFError alloc] initWithCode:234 localizedDescriptionKey:@"localizedDescriptionKey" localizedFailureReasonErrorKey:@"failureReasonKey"];
    [self.context addErrors:@[newError]];
    XCTAssertTrue([self.context hasError]);
    XCTAssertFalse([self.context messages].count > 0);
    XCTAssertTrue([self.context errors].count > 0);
}

/**
 * @test Creates a simple context from the MFContextFactory
 */
-(void) testCreateFromFactory {
    self.context = nil;
    XCTAssertNil(self.context);

    self.context = [self createFromFactory];
    XCTAssertNotNil(self.context);
    XCTAssertNil(self.context.entityContext);
    
}

/**
 * @test Creates a context with child Core Data context from the MFContextFactory
 */
-(void) testCreateMFContextWithChildCoreDataContextWithParent {
    self.context = nil;
    XCTAssertNil(self.context);
    
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    self.context = [[[MFContextFactory alloc] init] createMFContextWithChildCoreDataContextWithParent:defaultContext];
    XCTAssertNotNil(self.context);
    XCTAssertNotNil(self.context.entityContext);
    XCTAssertEqualObjects(defaultContext, self.context.entityContext.parentContext);
    
}

-(MFContext *) createFromFactory {
    return [[[MFContextFactory alloc] init] createMFContext];
}

@end
