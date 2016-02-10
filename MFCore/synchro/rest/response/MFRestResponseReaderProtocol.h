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
//  MFRestResponseReader.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFAbstractStreamProcessor.h"

@protocol MFRestResponseReaderProtocol <NSObject>

@property (nonatomic, retain) Class responseClass;

/*!
 * @brief initialise l'instance avec la classe de la réponse à constituer
 * @param responseClass classe de la réponse qui doit être construite
 * @return instance de la classe créée
 */
-(id) initForClass:(Class) responseClass;

/*!
 * @brief initialise l'objet réponse
 */
-(void) initializeResponse;

/*!
 * @brief lit le flux passé en paramètre sous forme de chaine de caractère et reconstitue la réponse à partir de ce dernier
 * @param resp chaine contenant la réponse serveur 
 * @param context
 */
-(void) readResponse:(NSString *) resp withContext:(MFContext *) context;

/*!
 * @brief renvoie la réponse qui a été constituée par l'instance
 */
-(id) getResponse;

@end
