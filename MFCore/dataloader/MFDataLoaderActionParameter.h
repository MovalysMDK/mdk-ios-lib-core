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
//  MFDataLoaderParameter.h
//  MFCore
//
//

#import "MFDataLoaderActionParameterProtocol.h"

@interface MFDataLoaderActionParameter : NSObject<MFDataLoaderActionParameterProtocol>
/*!
 * @brief loading parameters of the loading
 */
@property (strong, nonatomic,getter=getLoadingOptions) NSDictionary *loadingOptions;

/*!
 * @brief loaded datas after the loading
 */
@property (strong, nonatomic,getter=getLoadedData) NSArray *loadedData ;

/*!
 * @brief identifiers of the data to load
 */
@property (strong, nonatomic,getter=getDataIdentifiers) NSArray *dataIdentifiers ;

/*!
 * @brief identifiers of the data to load
 */
@property (strong, nonatomic,getter=getDataLoaderClassName) NSString *dataLoaderClassName ;

@end
