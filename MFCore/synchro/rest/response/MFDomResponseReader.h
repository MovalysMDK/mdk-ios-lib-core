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
//  MFDomResponseReader.h
//  MFCore
//
//

#import <Foundation/Foundation.h>
#import "MFRestResponseReaderProtocol.h"

@interface MFDomResponseReader : NSObject<MFRestResponseReaderProtocol>

#pragma mark - Properties

@property (nonatomic, retain) Class ProcessorClass;
//@property (nonatomic, retain) Class ResponseClass;
@property (nonatomic, retain) NSMutableDictionary *modelsDictionary;
@property (nonatomic, retain) NSMutableDictionary *mapStreamResponseProcessors;
@property (nonatomic, retain) id localresponse;

#pragma mark - Methods

-(id) initWithProcessorClass:(Class) processorClass withResponseClass:(Class) responseClass;

-(id) getMessage;

-(void) processJson:(NSDictionary *) dict withPath:(NSString *) path withContext:(id<MFContextProtocol>) context ;

@end
