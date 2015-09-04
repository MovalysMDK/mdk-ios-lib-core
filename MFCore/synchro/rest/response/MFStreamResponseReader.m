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


#import "MFStreamResponseReader.h"
#import "MFRestResponseProtocol.h"
#import "MFStreamResponseProcessorProtocol.h"

@implementation MFStreamResponseReader

@synthesize responseClass = _responseClass;

NSMutableDictionary *processedEntities;

#pragma mark MFRestResponseReaderProtocol
-(id) initForClass:(Class <MFRestResponseProtocol>)responseClass
{
    if ((self = [super init])) {
        self.responseClass = responseClass;
        self.modelsDictionary = [[NSMutableDictionary alloc] init];
        self.mapStreamResponseProcessors = [[NSMutableDictionary alloc] init];
        self.jsonReader = [[MFJsonReader alloc] init];
        processedEntities = [NSMutableDictionary dictionary];
        
        for (NSString *key in self.mapStreamResponseProcessors) {
            [(id <MFStreamResponseProcessorProtocol>)[self.mapStreamResponseProcessors objectForKey:key] initialize];
        }
    }
    return self;
}

-(void) initializeResponse
{
    self.response = [self createResponse];
}

-(id) getResponse
{
    return self.response;
}

-(void) readResponse:(NSString *) resp withContext:(MFContext *) context
{
    if ([self.jsonReader processMessagePart:resp]) {
        while ([self.jsonReader hasNext]) {
            [self processObject:self.jsonReader.object withPath:self.jsonReader.object.path withObject:[self getCurrentObject:self.jsonReader.object] withContext:context];
        }
        
        [self processRemainingEntitiesWithContext:context];
    }
}

#pragma mark MFStreamResponseReader
-(void) addStreamResponseProcessor:(MFAbstractStreamProcessor *) processor forPath:(NSString *) path
{
    [self.mapStreamResponseProcessors setObject:processor forKey:path];
}

#pragma mark méthodes privées
/**
 * @brief traite un objet json dans la partie de la réponse indiquée
 * @param property : objet json à traiter
 * @param path : chemin en cours dans le flux json
 * @param object : attribut de la réponse correspondant qui doit être impacté
 * @param context
 */
-(void) processObject:(MFJsonObject *) property withPath:(NSString *) path withObject:(id) object withContext:(MFContext *) context
{
    MFAbstractStreamProcessor *streamProcessor = [self.mapStreamResponseProcessors objectForKey:path];
    
    if (streamProcessor && [property type] == JSonObjectTypes.ROW) {
        [self processEntitiesList:(NSDictionary *)property.content withStreamProcessor:streamProcessor withPath:path withObject:object withContext:context];
    } else if ([object isKindOfClass:[NSArray class]]) {
        if (!object) object = [NSMutableArray array];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        [self processDictionary:(NSDictionary *)property withPath:path withObject:object withContext:context];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([property isKindOfClass:[MFJsonObject class]]) {
            object = (NSNumber *) property.content;
        } else {
            object = (NSNumber *) property;
        }
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([property isKindOfClass:[MFJsonObject class]]) {
            object = (NSString *) property.content;
        } else {
            object = (NSString *) property;
        }
    } else {
        object = [[[object class] alloc] init];
    }
}

-(void) processEntitiesList:(NSDictionary *) entity withStreamProcessor:(MFAbstractStreamProcessor *) streamProcessor withPath:(NSString *) path withObject:(id) currentObject withContext:(MFContext *) context
{
    [self processDictionary:entity withPath:path withObject:entity withContext:context];
    
    if (entity) {
        if ([processedEntities objectForKey:path] != nil) {
            [[processedEntities valueForKey:path] addObject:entity];
        } else {
            [processedEntities setObject:[NSMutableArray arrayWithObject:entity] forKey:path];
        }
    }

    if ([[processedEntities valueForKey:path] count] % [streamProcessor partSize] == 0) {
        [streamProcessor processResponsePart:self.response withObjects:[processedEntities valueForKey:path] withContext:context];
        [processedEntities removeObjectForKey:path];
    }
}

-(void) processRemainingEntitiesWithContext:(MFContext *) context
{
    MFAbstractStreamProcessor *streamProcessor;
    
    for (NSString *path in [processedEntities allKeys]) {
        streamProcessor = [self.mapStreamResponseProcessors objectForKey:path];
        [streamProcessor processResponsePart:self.response withObjects:[processedEntities valueForKey:path] withContext:context];
        [processedEntities removeObjectForKey:path];
    }
}

-(void) processDictionary:(NSDictionary *) dict withPath:(NSString *) path withObject:(id) object withContext:(MFContext *) context
{
    for (NSString *dictProperty in dict) {
        id row = [dict valueForKey:dictProperty];
        [self processObject:[dict objectForKey:dictProperty] withPath:[NSString stringWithFormat:@"%@.%@", path, dictProperty] withObject:row withContext:context];
    }
}

-(NSMutableArray *) processArrayWithPath:(NSString *) path withObject:(id) object withContext:(MFContext *) context
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    id row;

    while ([self.jsonReader hasNext]) {
        [self processObject:[self.jsonReader object] withPath:[self.jsonReader getCurrentPath] withObject:row withContext:context];
        [result addObject:row];
    }

    return result;
}

-(id) getCurrentObject:(MFJsonObject *) object
{
    id currentObj = self.response;
    NSString *setter;

    for (NSString *node in [[[self jsonReader] getCurrentPath] componentsSeparatedByString:@"."]) {
        setter = [NSString stringWithFormat:@"set%@%@:", [[node substringToIndex:1] capitalizedString], [node substringFromIndex:1]];
        if ([currentObj respondsToSelector:NSSelectorFromString(setter)]) {
            currentObj = [currentObj valueForKey:node];
        }
    }
    
    if (object.type == JSonObjectTypes.PROPERTY) {
        setter = [NSString stringWithFormat:@"set%@%@:", [[object.name substringToIndex:1] capitalizedString], [object.name substringFromIndex:1]];
        if ([currentObj respondsToSelector:NSSelectorFromString(setter)]) {
            currentObj = [currentObj valueForKey:object.name];
        }
    }
    
    return currentObj;
}

-(id) createResponse
{
    return [[self.responseClass alloc] init];
}

@end
