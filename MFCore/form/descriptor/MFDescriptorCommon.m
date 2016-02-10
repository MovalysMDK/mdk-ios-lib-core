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
//  MFDescriptorCommon.m
//  MFCore
//
//

#import "MFCoreFoundationExt.h"

#import "MFDescriptorCommon.h"

@interface MFDescriptorCommon ()

/*!
 CSS class provided by framework.
 */
@property(nonatomic, strong) NSString *privateClassCSS;

@end

@implementation MFDescriptorCommon
@synthesize parent = _parent;
@synthesize name = _name;
@synthesize uitype = _uitype;
@synthesize configurationName = _configurationName;
@synthesize visible = _visible;
@synthesize noLabel = _noLabel;
@synthesize  fileName = _fileName;


-(NSString *) classCSS
{
    // If descriptor doesn't have private CSS class, it returns the descriptor's name.
    if([NSString isNilOrEmpty:self.privateClassCSS])
    {
        return self.name;
    }
    return self.privateClassCSS;
}

-(void) setClassCSS:(NSString *) className
{
    self.privateClassCSS = className;
}

-(BOOL) hasRealClassCSS
{
    return ![NSString isNilOrEmpty:self.privateClassCSS];
}

/*!
 * Copy the current instance.
 * Don't implement this function here.
 * Implement it in a subclass.
 *
 * @param zone - area of memory from which to allocate for the new instance
 * @return Copy of this instance.
 */
- (id)copyWithZone:(NSZone *)zone
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}
 
@end
