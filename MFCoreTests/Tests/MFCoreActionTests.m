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
#import "MFEmptyAction.h"
#import "MFTestAssembly.h"

@interface MFCoreActionTests : XCTestCase

@end

@implementation MFCoreActionTests


/**
 * A FAIRE : 
 * Le test du retour d'action est exécuté quand il n'a pas lieu d'être.
 * Trouver un moyen de vérifier le retour d'actions. 
 * Plus globalement tester les actions dans cette classe
 */
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

//MFRegister_ActionListenerOnSuccess(MFAction_MFEmptyAction, testSimpleExampleActionSuccess)
//-(void)testSimpleExampleActionSuccess:(id<MFContextProtocol>)context withCaller:(id)caller andResult:(id)result
//{
//    XCTAssertEqual(result, @"EMPTY ACTION");
//}


@end
