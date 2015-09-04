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


#import "MFApplication.h"
#import "MFBeanLoader.h"
#import "MFDomResponseReader.h"
#import "MFRestResponseProtocol.h"
#import "MFStreamResponseProcessorProtocol.h"
#import "MFJsonMapperServiceProtocol.h"

@implementation MFDomResponseReader
@synthesize responseClass = _responseClass;


-(id) initWithProcessorClass:(Class) processorClass withResponseClass:(Class) responseClass
{
    if (self = [super init]) {
        self.ProcessorClass = processorClass;
    }
    
    return self;
}

-(id) initForClass:(Class <MFRestResponseProtocol>)responseClass
{
    if ((self = [super init])) {
        self.responseClass = responseClass;
        self.modelsDictionary = [[NSMutableDictionary alloc] init];
        self.mapStreamResponseProcessors = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) addStreamResponseProcessor:(MFAbstractStreamProcessor *) processor forPath:(NSString *) path
{
    [self.mapStreamResponseProcessors setObject:processor forKey:path];
}

-(void) initializeResponse
{
    self.localresponse = [self createResponse];
}

-(id) getResponse
{
    return self.localresponse;
}

-(void) readResponse:(NSString *) resp withContext:(id<MFContextProtocol>) context
{
    for (NSString *key in self.mapStreamResponseProcessors) {
        [(id <MFStreamResponseProcessorProtocol>)[self.mapStreamResponseProcessors objectForKey:key] initialize];
    }
    
    id <MFJsonMapperServiceProtocol> jsonMapper = [[MFBeanLoader getInstance] getBeanWithKey:@"MFJsonMapperServiceProtocol"];
    id parsedResponse = [jsonMapper fromJson:resp];
    
    [self processJson:parsedResponse withPath:@"root" withContext:context];
}

-(void) processJson:(NSDictionary *) dict withPath:(NSString *) path withContext:(id<MFContextProtocol>) context
{
    for (NSString *dictProperty in dict) {
        id property = [self.localresponse valueForKey:dictProperty];
        [self processProperty:[dict valueForKey:dictProperty] withPath:[NSString stringWithFormat:@"%@.%@", path, dictProperty] withObject:&property withContext:context];
    }
}

-(void) processProperty:(id) property  withPath:(NSString *) path withObject:(id *) object withContext:(id<MFContextProtocol>) context
{
    MFAbstractStreamProcessor *streamProcessor = [self.mapStreamResponseProcessors objectForKey:path];
    
    if (streamProcessor) {
        // c'est une entrée gérée par un StreamResponseProcessor
        [self processEntitiesList:property withStreamProcessor:streamProcessor withPath:path withObject:object withContext:context];
    } else if ([property isKindOfClass:[NSArray class]]) {
        *object = [self processArray:property withPath:path withObject:object withContext:context];
    } else if ([property isKindOfClass:[NSDictionary class]]) {
        [self processDictionary:(NSDictionary *)property withPath:path withObject:object withContext:context];
    } else if ([property isKindOfClass:[NSNumber class]]) {
        *object = (NSNumber *) property;
    } else if ([property isKindOfClass:[NSString class]]) {
        *object = (NSString *) property;
    }
}

-(void) processEntitiesList:(NSArray *) entities withStreamProcessor:(MFAbstractStreamProcessor *) streamProcessor withPath:(NSString *) path withObject:(id *) currentObject withContext:(id<MFContextProtocol>) context
{
    [streamProcessor onStartLoop];
    
    NSMutableArray *processedEntities = [[NSMutableArray alloc] init];
    
    for (NSDictionary *entityDict in entities) {
        NSMutableDictionary *entity = [[NSMutableDictionary alloc] init];
        [self processDictionary:entityDict withPath:path withObject:&entity withContext:context];
        if (entity) [processedEntities addObject:entity];
        
        if ([processedEntities count] % [streamProcessor partSize] == 0) {
            [streamProcessor processResponsePart:self.localresponse withObjects:processedEntities withContext:context];
            processedEntities = [[NSMutableArray alloc] init];
        }
    }
    
    if ([processedEntities count] != 0) {
        [streamProcessor processResponsePart:self.localresponse withObjects:processedEntities withContext:context];
    }
    
    [streamProcessor onEndLoop];
}

-(void) processDictionary:(NSDictionary *) dict  withPath:(NSString *) path withObject:(id *) currentObject withContext:(id<MFContextProtocol>) context
{
    for (NSString *dictProperty in dict) {
        id row = [dict valueForKey:dictProperty];
        [self processProperty:[dict objectForKey:dictProperty] withPath:[NSString stringWithFormat:@"%@.%@", path, dictProperty] withObject:&row withContext:context];
        [*currentObject setValue:row forKey:dictProperty];
    }
}

-(NSArray *) processArray:(NSArray *) array withPath:(NSString *) path withObject:(id*) currentObject withContext:(id<MFContextProtocol>) context
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (id row in array) {
        if ([row isKindOfClass:[NSArray class]]) {
            NSArray *array = [self processArray:row withPath:path withObject:currentObject withContext:context];
            [result addObject:array];
        } else if ([row isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [self processDictionary:row withPath:path withObject:&dict withContext:context];
            [result addObject:dict];
        } else if ([row isKindOfClass:[NSNumber class]]) {
            [result addObject:(NSNumber *) row];
        } else if ([row isKindOfClass:[NSString class]]) {
            [result addObject:(NSString *) row];
        }
    }
    
    return result;
}

-(id) createResponse
{
    return [[self.responseClass alloc] init];
}

-(id) getMessage {
    return @" all is ok ";
}
@end
