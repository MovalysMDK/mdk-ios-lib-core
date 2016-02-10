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
//  MFReaderWorkspace.m
//  MFCore
//
//

#import "MFReaderWorkspace.h"
#import "MFCoreBean.h"

@interface MFReaderWorkspace()

@property (nonatomic, strong) NSString *fileName;

@end

@implementation MFReaderWorkspace

-(id) initWithParentDescriptor:(id<MFDescriptorCommonProtocol>) parentDescriptor
{
    self = [super initWithParentDescriptor:parentDescriptor];
    if(self) {
    }
    return self;
}

-(MFWorkspaceDescriptor *) readFromDictionary:(NSDictionary *) dictionary
{
    MFWorkspaceDescriptor *workspaceDescriptor = nil;
    if(dictionary == nil)
    {
        return workspaceDescriptor;
    }
    workspaceDescriptor = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_WORKSPACE_DESCRIPTOR];
    workspaceDescriptor.fileName = self.fileName;
    
    [self fillDescriptorData:workspaceDescriptor withDataFromDictionary: dictionary];
    return workspaceDescriptor;
}

-(MFWorkspaceDescriptor *) readFromDictionary:(NSDictionary *) dictionary withFileName:(NSString *)fileName {
    self.fileName = fileName;
    return [self readFromDictionary:dictionary];
}

@end
