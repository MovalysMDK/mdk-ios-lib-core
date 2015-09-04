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


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern const struct MObjectToSynchronizeProperties_Struct
{
    __unsafe_unretained NSString *EntityName;
    __unsafe_unretained NSString *identifier;
    __unsafe_unretained NSString *objectId;
    __unsafe_unretained NSString *objectName;
} MObjectToSynchronizeProperties;

@interface MObjectToSynchronize : NSManagedObject

@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSNumber *objectId;
@property (nonatomic, retain) NSString *objectName;

@end

@interface MObjectToSynchronize (PropertyHelper)
//renvoie le nom sérialisé de la propriété
+(NSString *) serializedPropertyName:(NSString *) propertyName;
//renvoie le nom de la propriété depuis un attribut sérialisé
+(NSString *) propertyNameFromSerialization:(NSString *) serializedName;
//renvoie un tableau contenant la liste des propriétés "locales"
+(NSArray *) propertiesList;
//renvoie un tableau contenant la liste des propriétés sérialisées
+(NSArray *) serializedPropertiesList;
//renvoie un tableau contenant la liste des types des propriétés
+(NSArray *) propertiesTypesList;
@end
