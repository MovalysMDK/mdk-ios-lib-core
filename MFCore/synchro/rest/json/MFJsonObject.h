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

#import <Foundation/Foundation.h>

/*!
 * @brief types possible pour les objets json
 */
extern const struct MFJSonObjectTypes_Struct {
    int CLASS;
    int ARRAY;
    int PROPERTY;
    int ROW;
} JSonObjectTypes;

/*!
 * @brief décrit un objet json lu depuis un flux. Est utilisé pour le streaming
 */
@interface MFJsonObject : NSObject

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) BOOL inName;
@property (nonatomic) BOOL nameCompleted;
@property (nonatomic) int type;
@property (nonatomic, retain) NSString *content;
@property (nonatomic) BOOL contentCompleted;
@property (nonatomic) int depth; // pour les lignes de tableaux

-(BOOL) isComplete;
-(BOOL) isNew;

@end
