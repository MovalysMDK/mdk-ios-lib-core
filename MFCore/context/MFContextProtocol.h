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


#import <CoreData/CoreData.h>
//#import <MagicalRecord/CoreData+MagicalRecord.h>

/*!
 * MOVALYS framework context protocol. 
 * It defines some crosscutting metadatas used by the framework.
 */
@protocol MFContextProtocol <NSObject>

/*
 List of NSError not already managed by the application.
 */
@property (nonatomic, readonly) NSMutableArray *errors;

/*
 List of MFMessageProtocol not already managed by the application.
 */
@property (nonatomic, readonly) NSMutableArray *messages;

/*!
 * @brief entity context (coredata)
 */
@property(nonatomic,strong) NSManagedObjectContext *entityContext ;

/*!
 * Add errors of type "NSError" to this context
 */
-(void) addErrors : (NSArray *) errors;

/*!
 * @brief Indique s'il y a des erreurs dans le traitement en cours
 */
-(BOOL) hasError;

/*
 Add messages of type "MFMessageProtocol" to this context
 */
-(void) addMessages : (NSArray *) messages;

@end
