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

/*!
 * @class MFEntityAcks
 * @brief <# Une brève description de ce que fait la classe #>
 * @discussion <# Si nécessaire, ajouter des détails sur la classe #>
 */
@interface MFEntityAcks : NSObject

@property (nonatomic, retain) NSString *entity;
@property (nonatomic, retain) NSMutableArray *insertOrUpdate;
@property (nonatomic, retain) NSMutableArray *delete;

@end
