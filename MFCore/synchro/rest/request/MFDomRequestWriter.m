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
//  MFAbstractDomRequestWriter.m
//  MFCore
//
//

#import "MFDomRequestWriter.h"
#import "MFDomRequestBuilderProtocol.h"
#import "MFAbstractDomEntityRequestBuilder.h"
#import "MFJsonMapperServiceProtocol.h"
#import "MFCoreLogging.h"
#import "MFApplication.h"

@implementation MFDomRequestWriter

-(id) initWithRequestClass:(Class<MFRestRequestProtocol>) RestRequestClass
{
    if ((self = [super init])) {
        self.RestRequestClass = RestRequestClass;
        self.entityRequestBuilders = [[NSMutableDictionary alloc] init];
        self.requestBuilders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void) prepare:(BOOL) firstGoToServer withObjects:(NSDictionary *) objectsToSynchronize timeStamps:(NSDictionary *) timeStamps synchedList:(NSMutableArray *) synchedList inParameter:(MFSynchronizationActionParameterIN *) inParameter context:(MFContext *) context
{
    NSObject<MFRestRequestProtocol> *restRequest = [[self.RestRequestClass alloc] init];
    
    for (NSObject<MFDomRequestBuilderProtocol> *builder in self.requestBuilders) {
        [builder buildRequest:restRequest onFirstGoToServer:firstGoToServer withParamsIn:inParameter withSyncTimestamp:timeStamps];
    }
    
    for (NSString *objToSyncClass in objectsToSynchronize) {
        MFAbstractDomEntityRequestBuilder *entityBuilder = [self.entityRequestBuilders objectForKey:objToSyncClass];
        if (entityBuilder)
            [entityBuilder buildRequestFromObject:[objectsToSynchronize objectForKey:objToSyncClass] withRequest:restRequest withSynchedList:synchedList withContext:context];
        else
            MFCoreLogInfo(@"EntityRequestBuilder non trouvé pour la classe %@",objToSyncClass);
    }
    
    self.restRequest = restRequest;
}

-(NSString *) getHttpEntity
{
    NSObject<MFJsonMapperServiceProtocol> *jsonMapper = [[MFApplication getInstance] getBeanWithKey:@"MFJsonMapperServiceProtocol"];
        
    NSString *json = [jsonMapper toJson:self.restRequest withEntityBuilders:self.entityRequestBuilders];
        
    return json;
}

@end
