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
//  MParameter.m
//  MFCore
//
//

#import "MParameter.h"
#import "MFBeanLoader.h"
#import "MFBeansKeys.h"
#import "MFCoreDataHelper.h"

const struct MParameterProperties_Struct MParameterProperties = {
    .EntityName = @"MParameter",
    .identifier = @"identifier",
    .name = @"name",
    .value = @"value"
};

@implementation MParameter

@dynamic identifier;
@dynamic name;
@dynamic value;

- (void) willSave
{
    if ([self.identifier intValue] == -1) {
        self.identifier =
        [(MFCoreDataHelper *)[[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER] nextIdForEntity:MParameterProperties.EntityName];
    }
}


- (void) awakeFromInsert
{
}


@end
