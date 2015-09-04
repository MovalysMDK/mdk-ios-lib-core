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


#import "MFAbstractStreamProcessor.h"
#import "MFAbstractDomEntityRequestBuilder.h"

@implementation MFAbstractStreamProcessor

@synthesize partSize = _partSize;
@synthesize ProcessorClass = _ProcessorClass;
@synthesize ResponseClass = _ResponseClass;

-(id) initWithProcessorClass:(Class) processorClass withResponseClass:(Class) responseClass
{
    if (self = [super init]) {
        self.ProcessorClass = processorClass;
        self.ResponseClass = responseClass;
    }
    
    return self;
}

-(void) processResponsePart:(MFAbstractRestResponse<MFSyncRestResponseProtocol> *) response withObjects:(NSArray *) objects withContext:(id<MFContextProtocol>) context
{

}

-(void) processSingleObject:(MFAbstractRestResponse<MFSyncRestResponseProtocol> *) response withObjects:(NSDictionary *) objects withContext:(MFContext *) context
{
    
}

-(void) onStartLoop
{
    
}

-(void) onEndLoop
{
    
}

-(void) initialize{
    
}

-(id) getMessage
{
    return nil;
}

@end
