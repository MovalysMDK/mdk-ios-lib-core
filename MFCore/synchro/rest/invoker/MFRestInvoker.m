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


#import "JSONKit.h"
#import "MFRestInvoker.h"
#import "MFRestInvocationConfig.h"
#import "MFRestConnectionConfig.h"
#import "MFAbstractRestAuth.h"
#import "MFSyncRestResponseProtocol.h"
#import "MFRestError.h"
#import "MFJsonMapperServiceProtocol.h"
#import "MFBeanLoader.h"
#import "MFTechnicalError.h"
#import "MFDomResponseReader.h"
#import "MFStreamResponseReader.h"
#import "MFCoreLog.h"

@implementation MFRestInvoker

id refToSelf;
MFContext *refToContext;
CFHTTPMessageRef request;
CFURLRef url;
NSMutableData *responseBytes;
CFReadStreamRef readStream;
CFRunLoopRef runLoop;
MFConnectionTimeout *timeoutChecker;
CFHTTPMessageRef httpResponse;

@synthesize ResponseClass = _ResponseClass;
@synthesize urlProtocol = _urlProtocol;
@synthesize getParameters = _getParameters;
@synthesize actionSynchro = _actionSynchro;
@synthesize connectionConfig = _connectionConfig;
@synthesize invocationConfig = _invocationConfig;

#pragma mark - MFRestInvokerProtocol
-(void) initializeWithResponseClass:(Class <MFSyncRestResponseProtocol>) responseClass withActionSynchro:(NSObject<MFActionProtocol> *) actionSynchro withConnectionConfig:(MFRestConnectionConfig *) connectionConfig withInvocations:(MFRestInvocationConfig *) invocations {
    self.ResponseClass = responseClass;
    if([self restInvokerUrlProtocol] == MFRestInvokerUrlProtocolHTTP) {
        self.urlProtocol = @"http://";
    }
    else if([self restInvokerUrlProtocol] == MFRestInvokerUrlProtocolHTTPS){
        self.urlProtocol = @"https://";
    }
    self.getParameters = [[NSMutableArray alloc] init];
    self.actionSynchro = actionSynchro;
    self.connectionConfig = connectionConfig;
    self.invocationConfig = invocations;
    refToSelf = self;
}

-(void) prepare
{
    url = [self newUrl];
    request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), url, kCFHTTPVersion1_1);
    
    if ([self.connectionConfig isProxy] && [self.connectionConfig isProxyAuth]) {
        CFStringRef usr = CFBridgingRetain([self.connectionConfig proxyUser]);
        CFStringRef pass = CFBridgingRetain([self.connectionConfig proxyPassword]);
        
        CFHTTPMessageAddAuthentication(request, NULL, usr, pass, NULL, true);
        
        CFRelease(usr);
        CFRelease(pass);
    }
}

-(void) initializeWithContext:(MFContext *) context
{
    // on ajoute le body a partir des invocations
    CFStringRef bodyString = CFBridgingRetain([[self.invocationConfig requestWriter] getHttpEntity]);
    
    NSLog(@"----DEBUG bodyString: %@",bodyString);
    
    CFDataRef bodyDataExt = CFStringCreateExternalRepresentation(kCFAllocatorDefault, bodyString, kCFStringEncodingUTF8, 0);
    CFHTTPMessageSetBody(request, bodyDataExt);
    
    CFRelease(bodyString);
    CFRelease(bodyDataExt);
    
    // on specifie qu'on est en json
    CFHTTPMessageSetHeaderFieldValue(request, CFSTR("Content-Type"), CFSTR("application/json"));
    
    // on ajoute les identifiants
    MFAbstractRestAuth *restAuth = [[MFBeanLoader getInstance] getBeanWithKey:@"MFAbstractRestAuth"];
    NSDictionary *headers = [restAuth getAuthHeadersWithLogin:[self.connectionConfig user] withPassword:[self.connectionConfig password] withUrl:[(__bridge NSURL *)(url) path] withEntrypoint:[self.connectionConfig wsEntryPoint]];
    for (NSString *key in headers) {
        CFHTTPMessageSetHeaderFieldValue(request, (__bridge CFStringRef)key, (__bridge CFStringRef)[headers objectForKey:key]);
    }
    
}

-(Class <MFSyncRestResponseProtocol>) processWithDispatcher:(MFActionProgressMessageDispatcher*) dispatcher withContext:(MFContext *) context {
    refToContext = context;
    id response = [[self.ResponseClass alloc] init];
    responseBytes = [[NSMutableData alloc] init];
    
    // on initialise l'objet réponse
    [[self.invocationConfig responseReader] initializeResponse];
    
    // on prépare le readstream
    readStream = [self newReadStream];
    [self configureReadstreamBeforeInvocation:readStream];
    
    CFStreamClientContext dataStreamContext = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFOptionFlags registeredEvents = kCFStreamEventHasBytesAvailable | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered;
    
    runLoop = CFRunLoopGetCurrent();
    
    if (CFReadStreamSetClient(readStream, registeredEvents, readStreamCallBack, &dataStreamContext)) {
        CFReadStreamScheduleWithRunLoop(readStream, runLoop, kCFRunLoopCommonModes);
    }
    
    // on tente l'ouverture du readstream
    if (!CFReadStreamOpen(readStream)) {
        // une erreur s'est produite...
        [context addErrors:[NSArray arrayWithObject:[[MFTechnicalError alloc] initWithCode:HTTP_CONNECTION_ERROR localizedDescriptionKey:@"Could not open http stream reader"]]];
        CFRelease(readStream);
    } else {
        // on démarre le détecteur de timeouts et on lance la requête serveur
        timeoutChecker = [[MFConnectionTimeout alloc] initWithConnectionTimeout:(int)self.connectionConfig.timeout withDataTimeout:(int)self.connectionConfig.soTimeout withDelegate:self withContext:context];
        CFRunLoopRun();
        
        // on arrête le détecteur de timeouts et on lit la répose reçue
        [timeoutChecker invalidate];
        NSError* error = (NSError*)CFBridgingRelease(CFReadStreamCopyError(readStream));
        if (error) {
            [context addErrors:[NSArray arrayWithObject:[[MFTechnicalError alloc] initWithCode:[error code] localizedDescriptionKey:[NSHTTPURLResponse localizedStringForStatusCode:(NSInteger)error]]]];
        } else {
            response = [[self.invocationConfig responseReader] getResponse];
        }
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    CFRelease(request);
    CFRelease(url);
    
    return response;
}

#pragma mark - Internal methods
/**
 * @brief récupère le flux json depuis la réponse reçue du serveur
 */
-(NSString *) getMessageBodyFrom:(CFHTTPMessageRef) message
{
    CFHTTPMessageSetBody(message, (__bridge CFDataRef)responseBytes);
    
    CFDataRef respBodyData = CFHTTPMessageCopyBody(message);
    NSData *responseBodyData = (__bridge NSData*) respBodyData;
    NSString *responseBody = [[NSString alloc] initWithData:responseBodyData encoding:NSUTF8StringEncoding];
    
    CFRelease(respBodyData);
    
    return responseBody;
}

/**
 * @brief construit une url depuis la configuration de l'application
 */
-(CFURLRef) newUrl
{
    // on construit l'url à partir des paramètres
    NSString *sUrl = [NSString stringWithFormat:@"%@%@:%li%@", self.urlProtocol, [self.connectionConfig host], (long)[self.connectionConfig port] , [self.connectionConfig path]];
    sUrl = [self concatenatePath:[self.connectionConfig wsEntryPoint] toUrl:sUrl];
    sUrl = [self concatenatePath:[self.connectionConfig command] toUrl:sUrl];
    
    NSLog(@"Server url is : %@", sUrl);
    
    for (NSString *param in self.getParameters)
        sUrl = [self concatenatePath:param toUrl:sUrl];
    
    return CFURLCreateWithString(kCFAllocatorDefault, (__bridge CFStringRef)(sUrl), NULL);
}

/**
 * @brief ajoute un chemin à une url, en tenant compte des caractères / qui doivent ou non être ajoutés
 */
-(NSString *) concatenatePath:(NSString *) pPath toUrl:(NSString *) pUrl;
{
    NSString *rPath = nil;
    
    // on gère les "/" en début et en fin de chaines
    if ([pPath hasPrefix:@"/"] && [pUrl hasSuffix:@"/"])
        rPath = [NSString stringWithFormat:@"%@%@", pUrl, [pPath substringFromIndex:1]];
    else if (![pPath hasPrefix:@"/"] && ![pUrl hasSuffix:@"/"])
        rPath = [NSString stringWithFormat:@"%@/%@", pUrl, pPath];
    else
        rPath = [NSString stringWithFormat:@"%@%@", pUrl, pPath];
    
    return rPath;
}

/**
 * @brief construit un objet de lecture de flux à partir de la requête, et ajoute les éventuels paramètres de connexion au proxy
 */
-(CFReadStreamRef) newReadStream
{
    // on crée le readstream depuis le message construit
    CFReadStreamRef rReadStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, request);
    
    // on ajoute les paramètres de proxy
    if ([self.connectionConfig isProxy]) {
        CFTypeRef keys[2], values[2];
        
        keys[0] = kCFStreamPropertyHTTPProxyHost;
        values[0] = CFBridgingRetain([self.connectionConfig proxyHost]);
        keys[1] = kCFStreamPropertyHTTPProxyPort;
        values[1] = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, (void *)[self.connectionConfig proxyPort]);
        
        CFDictionaryRef proxyDict = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFReadStreamSetProperty(rReadStream, kCFStreamPropertyHTTPProxy, proxyDict);
    }
    return rReadStream;
}

/**
 * @brief fonction appelée quand un retour du serveur est reçu.
 * La lecture du retour serveur se fait sur un objet de type CFReadStreamRef, qu'on lie à un CFRunLoopRef.
 * Cette fonction est instancié quand des données ou des erreurs sont reçues, ou que la lecture est terminée
 */
void readStreamCallBack(CFReadStreamRef readStream, CFStreamEventType type, void *clientCallBackInfo) {
    if (type == kCFStreamEventHasBytesAvailable) {
        [timeoutChecker stopConnectionTimeout];
        
        uint8_t buf[1024];
        unsigned int len = 1024;
        
        CFIndex numBytesRead = CFReadStreamRead(readStream, buf, len);
        
        if(numBytesRead > 0) {
            [timeoutChecker resetDataTimeout];
            [responseBytes appendBytes:buf length:numBytesRead];
            
            // si on a un reader de type stream, on traite le flux au fur et à mesure
            if ([refToSelf hasStreamReader]) [refToSelf readMessageReceived];
        }
    } else if (type == kCFStreamEventErrorOccurred) {
        CFRunLoopStop(CFRunLoopGetCurrent());
    } else if (type == kCFStreamEventEndEncountered) {
        CFHTTPMessageRef httpResponse = (CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
        
        if (httpResponse) {
            NSString *responseBody = [refToSelf getMessageBodyFrom:httpResponse];
            NSLog(@"----DEBUG responseBody: %@", responseBody);
        }
        // si on a un reader de type dom, on traite le flux à la fin
        if (![refToSelf hasStreamReader]) [refToSelf readMessageReceived];
        
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
}

-(BOOL) hasStreamReader
{
    return [[((MFRestInvoker *)refToSelf).invocationConfig responseReader] isKindOfClass:[MFStreamResponseReader class]];
}

-(void) readMessageReceived
{
    CFHTTPMessageRef httpResponse = (CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
    
    if (httpResponse) {
        NSString *responseBody = [refToSelf getMessageBodyFrom:httpResponse];
        
        if (responseBody) {
            [[((MFRestInvoker *)refToSelf).invocationConfig responseReader] readResponse:responseBody withContext:refToContext];
        }
        
        CFRelease(httpResponse);
    }
}

#pragma mark - TimeoutsCheckerD-(void) configureReadstreamBeforeInvocation:(CFReadStreamRef)readStreamelegate
-(void) onConnectionTimeoutReached:(MFConnectionTimeout *) timeoutChecker withContext:(id<MFContextProtocol>) ctx
{
    CFRunLoopStop(runLoop);
    [ctx addErrors:[NSArray arrayWithObject:[[MFTechnicalError alloc] initWithCode:CONNECTION_TIMEOUT localizedDescriptionKey:@"Timeout reached when trying to connect"]]];
}

-(void) onDataTimeoutReached:(MFConnectionTimeout *) timeoutChecker withContext:(id<MFContextProtocol>) ctx
{
    CFRunLoopStop(runLoop);
    [ctx addErrors:[NSArray arrayWithObject:[[MFTechnicalError alloc] initWithCode:CONNECTION_TIMEOUT localizedDescriptionKey:@"Timeout reached when waiting for data"]]];
}

-(void) timeoutCheckerTick:(MFConnectionTimeout *) timeoutChecker withContext:(id<MFContextProtocol>) ctx
{
    //nothing to do
}



#pragma mark - Overloading methods
-(MFRestInvokerUrlProtocol) restInvokerUrlProtocol {
    return MFRestInvokerUrlProtocolHTTP;
}

-(void) configureReadstreamBeforeInvocation:(CFReadStreamRef)readStream {
    //Default : do nothing
}


@end
