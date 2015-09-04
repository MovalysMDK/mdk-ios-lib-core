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
