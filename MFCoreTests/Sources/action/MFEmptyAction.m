//
//  MFEmptyAction.m
//  MFCore
//
//  Created by Lagarde Quentin on 02/06/2015.
//  Copyright (c) 2015 Sopra. All rights reserved.
//

#import "MFEmptyAction.h"

NSString *const MFAction_MFEmptyAction = @"MFEmptyAction";

@implementation MFEmptyAction


-(id)doAction:(id)parameterIn withContext:(id<MFContextProtocol>)context withQualifier:(id<MFActionQualifierProtocol>)qualifier withDispatcher:(MFActionProgressMessageDispatcher *)dispatch {
    return @"EMPTY ACTION";
}

@end
