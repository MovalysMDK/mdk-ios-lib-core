//
//  MFCoreDataTests.m
//  MFCore
//
//  Created by Lagarde Quentin on 03/09/2015.
//  Copyright (c) 2015 Sopra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "Entity.h"
#import "LinkEntity.h"
#import "MFContextFactory.h"
#import "MFContext.h"
#import "MFBeanLoader.h"

#import "MFCoreDataHelper.h"

@interface MFCoreDataTests : XCTestCase

@end

@implementation MFCoreDataTests

/**
 * ATTENTION : A faire :
 * Normalement il doit être possible de tester CoreData dans XCTest, mais à vérifier que c'est
 * éagelement le cas, dans le cas d'un Cocoa Touch Framework.
 * Regarder peut-être du coté de OCMock.
 */

- (void)setUp {
    [super setUp];

    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    MFContext *context = [self createFromFactory];
//    LinkEntity *entity = [LinkEntity MR_createEntity];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [MagicalRecord cleanUp];

}


-(MFContext *) createFromFactory {
    return [[[MFContextFactory alloc] init] createMFContextWithCoreDataContext:[NSManagedObjectContext MR_defaultContext]];
}


@end
