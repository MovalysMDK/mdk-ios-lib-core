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


#import "MFCoreContext.h"
#import "MFDataLoaderProtocol.h"

@class MFContextProtocol ;

FOUNDATION_EXPORT NSString *const MFAbstractDataLoader_MFilterParametersDepth2;
FOUNDATION_EXPORT NSString *const MFAbstractDataLoader_MFilterParametersDepth3;
FOUNDATION_EXPORT NSString *const MFAbstractDataLoader_MParametersTag;


/*!
 * @class MFAbstractDataLoader
 * @brief The abstract data laoder
 * @discussion This class does any common treatment to all dataloader used by genarted
 * applications with MDK iOS
 */
@interface MFAbstractDataLoader : NSObject<MFDataLoaderProtocol>


#pragma mark - Properties
/*!
 * @brief identifiers of the data to load
 */
@property (strong, nonatomic,getter=getDataIdentifiers) NSArray *dataIdentifiers ;

/*!
 * @brief loading parameters of the loading
 */
@property (strong, nonatomic,getter=getLoadingOptions) NSDictionary *loadingOptions;


#pragma mark - Methods

/*!
 * @brief reload dataloader
 * @param context context
 */
-(void) reload:(id<MFContextProtocol>)context ;

/*!
 * @brief reload dataloader
 */
-(void) reload:(id<MFContextProtocol>)context withNotification:(BOOL) p_isSendingNotification ;

/*!
 * @brief Notifies that the reload has ended
 */
-(void) notifyOfReloadEnd:(id<MFContextProtocol>) p_context ;

/*!
 * @brief Returns the filters for the 2nd level of depth of the returned data
 */
-(NSArray *) getFilterParametersForDepth2;

/*!
 * @brief Returns the filters for the 3rd level of depth of the returned data
 */
-(NSArray *) getFilterParametersForDepth3;

/*!
 * @brief Set the entity managed by this dataloader
 * @param entity The entity to manage
 */
-(void) setEntity:(id)entity;

/*!
 * @brief Returns the entity managed by this dataloader
 * @return The entity manged by this dataloader
 */
-(id) getEntity;




@end
