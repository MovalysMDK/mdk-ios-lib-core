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
//  MFAbstractDomRequestWriter.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFRestRequestWriterProtocol.h"
#import "MFRestRequestProtocol.h"

/*!
 * @brief classe générant la requête à envoyer au serveur. 
 * Cette classe se base su une liste de classes héritant de MFAbstractDomEntityRequestBuiler et MFDomRequestBuilderProtocol 
 * pour construire cette requête
 */
@interface MFDomRequestWriter : NSObject<MFRestRequestWriterProtocol>

@property Class RestRequestClass;
@property (nonatomic, retain) NSObject<MFRestRequestProtocol> *restRequest;
@property (nonatomic, retain) NSMutableDictionary *entityRequestBuilders;
@property (nonatomic, retain) NSMutableArray *requestBuilders;

/*!
 * @brief initialise une instance de la classe avec la classe de la requête à construire
 * @param RestRequestClass classe de la requête à construire
 */
-(id) initWithRequestClass:(Class<MFRestRequestProtocol>) RestRequestClass;

@end
