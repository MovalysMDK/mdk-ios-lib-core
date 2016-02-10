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
//  MFProperty+Forms.m
//  MFCore
//
//

#import "MFCoreFormDescriptor.h"

#import "MFProperty+Forms.h"

@implementation MFProperty (Forms)

-(MFFormDescriptor*) getFormDescriptorValue {
    if ([self.value isKindOfClass:[MFFormDescriptor class]]) {
        return (MFFormDescriptor*)self.value;
    }
    else {
        return nil;
    }
}

-(MFSectionDescriptor *) getSectionDescriptorValue {
    if ([self.value isKindOfClass:[MFSectionDescriptor class]]) {
        return (MFSectionDescriptor*)self.value;
    }
    else {
        return nil;
    }
}

-(MFWorkspaceDescriptor *) getWorkspaceDescriptorValue {
    if ([self.value isKindOfClass:[MFWorkspaceDescriptor class]]) {
        return (MFWorkspaceDescriptor*)self.value;
    }
    else {
        return nil;
    }
}

@end
