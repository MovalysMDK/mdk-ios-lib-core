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
