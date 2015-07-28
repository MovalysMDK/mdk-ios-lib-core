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
//  MFObjectToSync.m
//  MFCore
//
//

#import "MObjectToSynchronize.h"
#import "MFBeanLoader.h"
#import "MFBeansKeys.h"
#import "MFCoreDataHelper.h"

const struct MObjectToSynchronizeProperties_Struct MObjectToSynchronizeProperties = {
    .EntityName = @"MObjectToSynchronize",
    .identifier = @"identifier",
    .objectId = @"objectId",
    .objectName = @"objectName"
};

@implementation MObjectToSynchronize

@dynamic identifier;
@dynamic objectId;
@dynamic objectName;

- (void) willSave
{
    if ([self.identifier intValue] == -1) {
        self.identifier =
        [(MFCoreDataHelper *)[[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER] nextIdForEntity:MObjectToSynchronizeProperties.EntityName];
    }
}

- (void) awakeFromInsert
{
}

@end

@implementation MObjectToSynchronize (PropertyHelper)
//renvoie le nom sérialisé de la propriété
+(NSString *) serializedPropertyName:(NSString *) propertyName
{
    NSUInteger idx = [[MObjectToSynchronize propertiesList] indexOfObject:propertyName];
    
    return (idx == NSNotFound ? @"" : [[MObjectToSynchronize serializedPropertiesList] objectAtIndex:idx]);
}
//renvoie le nom de la propriété depuis un attribut sérialisé
+(NSString *) propertyNameFromSerialization:(NSString *) serializedName
{
    NSUInteger idx = [[MObjectToSynchronize serializedPropertiesList] indexOfObject:serializedName];
    
    return (idx == NSNotFound ? @"" : [[MObjectToSynchronize propertiesList] objectAtIndex:idx]);
}
//renvoie un tableau contenant la liste des propriétés "locales"
+(NSArray *) propertiesList
{
    return [NSArray arrayWithObjects:
            @"identifier",
            @"objectId",
            @"objectName", nil];
}
//renvoie un tableau contenant la liste des propriétés sérialisées
+(NSArray *) serializedPropertiesList
{
    return [NSArray arrayWithObjects:
            @"id",
            @"objectId",
            @"objectName", nil];
}
//renvoie un tableau contenant la liste des types des propriétés
+(NSArray *) propertiesTypesList
{
    return [NSArray arrayWithObjects:
            @"NSNumber",
            @"NSString",
            @"NSString", nil];
}
@end
