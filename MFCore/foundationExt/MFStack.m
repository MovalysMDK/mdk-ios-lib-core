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
//  MFStack.m
//  MFCore
//
//

#import "MFStack.h"

/**
 * Project's iSpares implementation
 *
 * Description: Stack's implementation
 *
 **/
@implementation MFStack

@synthesize count;

/**
 * Initialize object
 *
 **/
- (id)init {
    
    self = [super init];
    
    if (self) {
        _array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/**
 * method used to push an object into the stack
 * 
 * @param object - the object to push
 *
 * @return nothing
 **/
- (void)push:(id)object {
    [_array addObject:object];
}

/**
 * Description: function used to pop out the top object from the stack and return it
 *
 * @return the top object of the stack
 **/
- (id)pop {
    
    id obj = nil;
    
    if(_array.count > 0) {
        obj = [_array lastObject];
        [_array removeLastObject];
    }
    
    return obj;
}

/**
 * Function used to retrieve the top object from the stack without popping it out and return it
 *
 * @return the top object of the stack
 **/
-(id)top {
    id obj = nil;
    
    if(_array.count > 0) {
        obj = [_array lastObject];
    }
    
    return obj;
}

/**
 * Method used to clear the stack
 **/
- (void)clear {
    [_array removeAllObjects];
}

/**
 * Method used to count stack elements
 *
 * @return number of elements in stack
 **/
-(int)count {
    return (int)_array.count;
    
}

@end
