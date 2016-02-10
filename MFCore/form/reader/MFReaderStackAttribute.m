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
//  MFReaderStackAttribute.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreBean.h"
#import "MFCoreFoundationExt.h"

#import "MFReaderStackAttribute.h"

@implementation MFReaderStackAttribute

static MFStack* instance = nil;


+(MFStack *) getStack
{
    if(!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[MFStack alloc] init];
        });
    }
    return instance;
}

+(void) beginReadAttribute:(NSString *) name
{
    MFCoreLogVerbose(@"Push attribute name on the stack : %@", name);
    [[MFReaderStackAttribute getStack] push:name];
}

+(NSString *) getCurrentReadAttribute
{
    NSString *name = [[MFReaderStackAttribute getStack] top];
    MFCoreLogVerbose(@"Current attribute name on the stack : %@", name);
    return name;
}

+(void) endReadAttribute:(NSString *) name
{
    MFCoreLogVerbose(@"Pop attribute name from the stack : %@", name);
    NSString *currentAttributeInStack = [[MFReaderStackAttribute getStack] pop];
    if([currentAttributeInStack compare:name] != NSOrderedSame)
    {
        NSString *message = [NSString stringWithFormat:@"We pop attribute '%@' which is different than expected attribute '%@'", currentAttributeInStack, name];
        MFCoreLogError(@"%@", message);
        @throw [NSException exceptionWithName:@"UnexpectedAttribute" reason:message userInfo:nil];
    }
}

+(NSString *) retrievePreviousKeyFromStack
{
    NSString *currentKey = [MFReaderStackAttribute getCurrentReadAttribute];
    [MFReaderStackAttribute endReadAttribute:currentKey];
    NSString *previousKey = [MFReaderStackAttribute getCurrentReadAttribute];
    MFCoreLogVerbose(@"Previous key is : %@", previousKey);
    [MFReaderStackAttribute beginReadAttribute:currentKey];
    return previousKey;
}


@end
