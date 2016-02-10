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
//  MFReaderForm.m
//  MFCore
//
//

#import "MFCoreBean.h"
#import "MFCoreFormDescriptor.h"

#import "MFReaderForm.h"
#import "MFReaderFactory.h"
#import "MFReaderProtocol.h"

@interface MFReaderForm()

@property (nonatomic, strong) NSString *fileName;

@end

@implementation MFReaderForm


-(MFFormDescriptor *) readFromDictionary:(NSDictionary *) dictionary
{
    MFFormDescriptor *formDescriptor = nil;
    if(dictionary == nil)
    {
        return formDescriptor;
    }
    formDescriptor = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_FORM_DESCRIPTOR];
    formDescriptor.fileName = self.fileName;
    [self fillDescriptorData:formDescriptor withDataFromDictionary: dictionary];
    return formDescriptor;
}

-(MFFormDescriptor *) readFromDictionary:(NSDictionary *) dictionary withFileName:(NSString *)fileName {
    self.fileName = fileName;
    return [self readFromDictionary:dictionary];
}

@end
