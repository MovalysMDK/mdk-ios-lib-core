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


@interface MFHelperQueue : NSObject

/*!
 * @brief Configure main queue, must be called one before using other methods
 *
 */
+(void) configureMainQueue;

/*!
 * @brief indique si on est dans le queue principale
 * @return true si on est dans la queue principale
 */
+ (BOOL) isInMainQueue;

/*!
 * @brief execute bloc in main queue asynchronously
 */
+(void) execInMainQueue:(void (^)())bloc;

/*!
 * @brief execute bloc in main queue synchronously
 */
+(void) execSyncInMainQueue:(void (^)())bloc;

@end
