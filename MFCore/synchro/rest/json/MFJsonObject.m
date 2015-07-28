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
//  MFJsonObject.m
//  MFCore
//
//
//

#import "MFJsonObject.h"

const struct MFJSonObjectTypes_Struct JSonObjectTypes = {
    .CLASS = 0,
    .ARRAY = 1,
    .PROPERTY = 2,
    .ROW = 3
};

@implementation MFJsonObject

-(id) init
{
    if (self = [super init]) {
        self.path = [NSString string];
        self.name = [NSString string];
        self.inName = true;
        self.nameCompleted = false;
        self.type = -1;
        self.content = [NSString string];
        self.contentCompleted = false;
        self.depth = 0;
    }
    return self;
}

-(BOOL) isComplete
{
    return self.nameCompleted && self.type != -1 && self.contentCompleted;
}

-(BOOL) isNew
{
    return !self.nameCompleted && self.type != -1 && !self.contentCompleted;
}

-(BOOL) isInName
{
    return !self.nameCompleted && [self.name length] > 0;
}

-(BOOL) isInContent
{
    return !self.contentCompleted && [self.content length] > 0;
}


@end
