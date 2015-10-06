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
//  MFAbstractSynchonizationAction.m
//

#import "MFBeanLoader.h"
#import "MFSynchronizationAction.h"
#import "MFRestError.h"
#import "MFSyncTimestampService.h"
#import "MFObjectToSyncService.h"
#import "MFSynchronisationResponseTreatmentInformation.h"
#import "MFSynchronizationActionParameterOUT.h"
#import "MFSynchronizationActionParameterIN.h"
#import "MFRestConnectionConfig.h"
#import "MFRestInvokerProtocol.h"
#import "MFRestInvocationConfig.h"
#import "MFSyncRestResponseProtocol.h"
#import "MFAckStreamRequestBuilder.h"
#import "MFAckDomRequestBuilder.h"
#import "MFDomRequestWriter.h"
#import "MFRestResponseProcessorProtocol.h"
#import "MFLocalCredentialServiceProtocol.h"
#import "MFConfigurationHandler.h"
#import "MFRestInvoker.h"
#import "MFReachability.h"
#import "MFApplication.h"
#import "MFBeansKeys.h"
#import "MFSettingsValidationManager.h"
#import "MFSynchroProperty.h"
#import "MFCoreDataHelper.h"
#import "MFError.h"
#import "MFCoreSynchro.h"


@implementation MFSynchronizationAction

- (BOOL) hasPreExecuteDialog
{
    return false;
}

#pragma mark MFActionProtocol delegate
- (id) doAction:(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch
{
    MFSynchronizationActionParameterOUT *result = nil;
    
    [dispatch dispatchProgressMessage:@"do action" withParam:nil andContext:context];
    
    if ([MFReachability isConnectionReady]) {
        result = [self doSynchronization:parameterIn withContext:context withQualifier:qualifier withDispatcher:dispatch];
    } else {
        [dispatch dispatchProgressMessage:@"No connection " withParam:nil andContext:context];
        
        result = [self doLocalProcessWithFirstFailure:true withContext:context];
        if ( result == nil && ![context hasError] ){
            [context addErrors:@[ [MFError errorWithDomain:@"synchro" code:404 userInfo:nil]]] ;
        }
    }
    
    if (result != nil) {
        result.nextScreen = parameterIn == nil ? nil : ((MFSynchronizationActionParameterIN *) parameterIn).nextScreen;
        result.informations = self.information;
    } else if ([context hasError]) {
        NSLog(@"An error occured in synchro %@ " , [context errors][0]  );
    }
    
    return result;
}

- (id) doOnSuccess:(id) parameterOut withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch
{
    NSLog(@"doOnSuccess");
    return parameterOut;
}

- (id) doOnFailed:(id) parameterOut withContext:(id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher *) dispatch
{
    NSLog(@"doOnFailed");
    return parameterOut;
}

#pragma mark MFSynchronizationAction methods
/**
 * @brief effectue l'action de synchronisation
 */
- (MFSynchronizationActionParameterOUT *) doSynchronization:(id) parameterIn withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch
{
    MFSynchronizationActionParameterOUT *result = nil;
    // on envoie un message de progression
    [dispatch dispatchProgressMessage:@"before prepare synchro" withParam:nil andContext:context];
    
    // initialise le service de sauvegarde de la dernière date de synchro
    MFSyncTimestampService *syncTimestampService = [[MFBeanLoader getInstance] getBeanWithKey:@"MFSyncTimestampService"];
    NSDictionary *syncTimestamps = [syncTimestampService getSyncTimestampsWithContext:context];
    
    // initialise le service de récupération des entités à synchroniser (ie les entités modifiées ou créées)
    MFObjectToSyncService *objectToSyncService = [[MFBeanLoader getInstance] getBeanWithKey:@"MFObjectToSyncService"];
    NSDictionary *currentObjectsToSync = [objectToSyncService getObjectsToSyncWithContext:context];
    
    // liste des invocations, méthode de récupération
    NSArray *invocationsList = [(id <MFSynchronizationActionProtocol>)self getInvocationConfigs:currentObjectsToSync];
    MFConfigurationHandler* config = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];

    if ([invocationsList count] > 0) {
        
        MFRestConnectionConfig *restConnectionConfig = [self retrieveRestConfiguration];
        
        // initialise une instance de la classe invoquant le serveur
        id<MFRestInvokerProtocol> restInvoker = [[MFBeanLoader getInstance] getBeanWithKey:@"RestInvoker"];
        
        // réponse et réponse précédentes, lues en retour du serveur
        id<MFSyncRestResponseProtocol> response;
        id<MFSyncRestResponseProtocol> oldResponse;
        NSMutableArray *synchronizedObjects = [[NSMutableArray alloc] init];
        
        // on parcourt les invocations
        for (MFRestInvocationConfig *invocationConfig in invocationsList) {
            oldResponse = nil;
            
            while (oldResponse == nil || (![(id <MFSyncRestResponseProtocol>)oldResponse isTerminated]) || ([(id <MFSyncRestResponseProtocol>)oldResponse hasAcks])) {
                // on envoie un message de progression
                [dispatch dispatchProgressMessage:[NSString stringWithFormat:@"before prepare synchro"] withParam:nil andContext:context];
                
                // on initialise la classe d'invocation
                [restInvoker initializeWithResponseClass:self.ResponseClass withActionSynchro:self withConnectionConfig:restConnectionConfig withInvocations:invocationConfig];
                
                // on complète la classe d'invocation
                [self appendGetParameters:restInvoker withConfig:config];
                
                // on prépare la classe d'invocation
                [restInvoker prepare];
                
                syncTimestamps = [syncTimestampService getSyncTimestampsWithContext:context];
                currentObjectsToSync = [objectToSyncService getObjectsToSyncWithContext:context];
                
                // on sera dans la première passe si aucun ack n'est en cours sur la réponse
                [(MFRestInvoker *)restInvoker setFirstPass:TRUE];
                
                if (oldResponse != nil && [(id <MFSyncRestResponseProtocol>)oldResponse hasAcks]) {
                    [[(MFDomRequestWriter *)[invocationConfig requestWriter] requestBuilders ] addObject:[[MFAckDomRequestBuilder alloc] initWithAcks:[(id <MFSyncRestResponseProtocol>)oldResponse acks]]];
                    [(MFRestInvoker *)restInvoker setFirstPass:FALSE];
                }
                
                // on envoie un message de progression
                [dispatch dispatchProgressMessage:@"before prepare data" withParam:nil andContext:context];
                
                // on prépare les classes en charge de l'écriture de la requête à envoyer au serveur
                [[invocationConfig requestWriter] prepare:(oldResponse == nil) withObjects:currentObjectsToSync timeStamps:syncTimestamps synchedList:synchronizedObjects inParameter:parameterIn context:context];
                
                // on invoque le serveur et on lit la réponse
                response = [self doInvocationWithConfig:invocationConfig withConnectionConfig:restConnectionConfig withRestInvoker:restInvoker withDispatcher:dispatch withContext:context];
                
                if (![context hasError]) {
                    [self.information complete:[(id <MFSyncRestResponseProtocol>)response information]];
                    
                    oldResponse = response;
                    
                    [self doOnSuccessInvocationWithResponse:response withInvocationConfig:invocationConfig withInformation:self.information withSynchedObjects:synchronizedObjects withContext:context];
                    
                    syncTimestamps = [syncTimestampService getSyncTimestampsWithContext:context];
                    
                    if ((![(id <MFSyncRestResponseProtocol>)oldResponse isTerminated]) || ([(id <MFSyncRestResponseProtocol>)oldResponse hasAcks])) {
                        response = nil;
                    }
                    
                    // on envoie un message de progression
                    [dispatch dispatchProgressMessage:@"Finished invocation" withParam:nil andContext:context];
                } else {
                    result = [self doOnFailedInvocationWithResponse:response withContext:context withQualifier:qualifier withDispatcher:dispatch];                    break;
                }
            }
            if ([context hasError]) {
                break;
            }
        }
        
        if (![context hasError]) {
            result = [self doOnSuccesSynchroWithResponse:response withConnectionConfig:restConnectionConfig withContext:context];
        } else {
            result = [self doOnFailedInvocationWithResponse:response withContext:context withQualifier:qualifier withDispatcher:dispatch];
        }
    } else {
        result = [[MFSynchronizationActionParameterOUT alloc] init];
    }
    
    return result;
}

-(MFRestConnectionConfig *)retrieveRestConfiguration {
    // récupère la configuration
    MFConfigurationHandler* config = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    MFRestConnectionConfig *restConnectionConfig = [[MFBeanLoader getInstance] getBeanWithKey:@"MFRestConnectionConfig"];
    [restConnectionConfig initializeWithHost:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_HOST_USERDEFAULTS_KEY]
                                        port:[[MFApplication getInstance] intPreferenceWithKey:SYNCHRO_CONFIG_PORT_USERDEFAULTS_KEY]
                                        path:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PATH_USERDEFAULTS_KEY]
                                wsEntryPoint:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_WSENTRYPOINT_USERDEFAULTS_KEY]
                                     command:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_COMMAND_USERDEFAULTS_KEY]
                                        user:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_USER_USERDEFAULTS_KEY]
                                    password:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PASSWORD_USERDEFAULTS_KEY]
                                   proxyHost:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PROXYHOST_USERDEFAULTS_KEY]
                                   proxyPort:[[MFApplication getInstance] intPreferenceWithKey:SYNCHRO_CONFIG_PROXYPORT_USERDEFAULTS_KEY]
                                   proxyUser:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PROXYUSER_USERDEFAULTS_KEY]
                               proxyPassword:[[MFApplication getInstance] preferenceWithKey:SYNCHRO_CONFIG_PROXYPASSWORD_USERDEFAULTS_KEY]];
    
    [restConnectionConfig setMockMode:[config getBooleanProperty:sync_mock_mode withDefault:NO]];
    [restConnectionConfig setMockStatusCode:[[config getNumberProperty:sync_mock_testid] integerValue]];
    return restConnectionConfig;
}

/**
 * @brief appelé en cas de synchronisation effectuée sans problème, en charge de mettre à jour les paramètres de connexion en base
 */
- (MFSynchronizationActionParameterOUT *) doOnSuccesSynchroWithResponse:(id <MFSyncRestResponseProtocol>) response withConnectionConfig:(MFRestConnectionConfig *) connectionConfig withContext:(id<MFContextProtocol>) context
{
    MFSynchronizationActionParameterOUT *result = [[MFSynchronizationActionParameterOUT alloc] init];
    
    [[[MFBeanLoader getInstance] getBeanWithKey:@"MFLocalCredentialService"] storeCredentialsWithLogin:connectionConfig.user withResource:response.resource withContext:context];
    
    return result;
}

/**
 * @brief ajoute les paramètres de connexion à la configuration de la synchro
 */
- (void) appendGetParameters:(id<MFRestInvokerProtocol>) restInvoker withConfig:(MFConfigurationHandler *) config
{
    NSString *login = [[MFApplication getInstance] userName];
    NSString *mobileId = [[MFApplication getInstance] getUniqueId];
    
    if (![config getBooleanProperty:case_sensitive_login withDefault:NO]) {
        login = [login lowercaseString];
    }
    NSNumber *loginHash = [NSNumber numberWithLong:[self hashCode:[NSString stringWithFormat:@"%@*%@",login,mobileId]]];
    
    [restInvoker.getParameters addObject:[loginHash stringValue]];
}

/**
 * @brief invoque le serveur
 */
- (id<MFSyncRestResponseProtocol>) doInvocationWithConfig:(MFRestInvocationConfig *) invocationConfig withConnectionConfig:(MFRestConnectionConfig *) connectionConfig withRestInvoker:(id<MFRestInvokerProtocol>) restInvoker withDispatcher:(MFActionProgressMessageDispatcher *) dispatch withContext: (id<MFContextProtocol>) context
{
    [restInvoker initializeWithContext:context];
    if (![context hasError]) {
        // on envoie un message de progression
        [dispatch dispatchProgressMessage:@"before prepare data" withParam:nil andContext:context];
        return [restInvoker processWithDispatcher:dispatch withContext:context];
    } else {
        return nil;
    }
}

/**
 * @brief met à jour la date de dernière synchro sur le client en cas de synchro réussie
 */
- (void) doOnSuccessInvocationWithResponse:(id <MFSyncRestResponseProtocol>) response withInvocationConfig:(MFRestInvocationConfig *) invocationConfig withInformation:(MFSynchronisationResponseTreatmentInformation *) information withSynchedObjects:(NSArray *) synchedList withContext:(id<MFContextProtocol>) context
{
    NSMutableDictionary *syncTimestamps = [[NSMutableDictionary alloc] init];
    
    for (id <MFRestResponseProcessorProtocol> responseProcessor in [invocationConfig responseProcessors]) {
        [responseProcessor processResponse:response withTimestamps:syncTimestamps withContext:context withInformation:information];
    }
    
    [[[MFBeanLoader getInstance] getBeanWithKey:@"MFSyncTimestampService"] saveSyncTimestamps:syncTimestamps withContext:context];
    [[[MFBeanLoader getInstance] getBeanWithKey:@"MFObjectToSyncService"] deleteObjectToSynchronize:synchedList withContext:context];
    
    // on commit
    MFCoreDataHelper *coreDataHelper = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER];
    [coreDataHelper saveContext:context];
}

/**
 * @brief appelé en cas d'échec, traite les erreurs rencontrées
 */
- (MFSynchronizationActionParameterOUT *) doOnFailedInvocationWithResponse:(id <MFSyncRestResponseProtocol>) response withContext:(id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch
{
    MFSynchronizationActionParameterOUT *result = nil;
    
    switch ([[[context errors] objectAtIndex:0] code]) {
        case REST_AUTHENTICATION_ERROR:
            result = [[MFSynchronizationActionParameterOUT alloc] init];
            [result setLocalAuthentication:TRUE];
            break;
            
        case HTTP_CONNECTION_ERROR:
            result = [[MFSynchronizationActionParameterOUT alloc] init];
            [result setNoConnectionSynchronizationFailure:TRUE];
            break;
            
        case UNAUTHORIZATION_MSG_ID:
            [self doOnAuthenticationFailedWithContext:context];
            result = [[MFSynchronizationActionParameterOUT alloc]init];
            [result setAuthenticationFailure:true];
            break;
            
        case ID_NOT_COMPATIBLE_MOBILE_TIME:
            [self doOnIncompatibleMobileTimeWithContext:context withDispatcher:dispatch];
            result = [[MFSynchronizationActionParameterOUT alloc]init];
            [result setIncompatibleServerMobileTimeFailure:true];
            break;
            
        default:
            result = [self doLocalProcessWithFirstFailure:true withContext:context];
            [result setErrorInSynchronizationFailure:true];
            break;
    }
    
    return result;
}

- (void) doOnConnectionFailed:(id) parameterOut withContext:(id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch
{
    
}

/**
 * @brief supprime les paramètres d'authentification en cas d'erreur retournée par le serveur
 */
- (void) doOnAuthenticationFailedWithContext:(id<MFContextProtocol>) context
{
    [[[MFBeanLoader getInstance] getBeanWithType:@protocol(MFLocalCredentialServiceProtocol)] deleteLocalCredentialsWithContext:context];
}

- (void) doOnIncompatibleMobileTimeWithContext:(id<MFContextProtocol>) context withDispatcher:(MFActionProgressMessageDispatcher *) dispatch
{
    // on envoie un message de progression
    [dispatch dispatchProgressMessage:@"Incompatible mobile time" withParam:nil andContext:context];
}

/**
 * @brief appelé pour effectuer une authentification "locale" si la connexion n'est pas opérationnelle
 */
- (id) doLocalProcessWithFirstFailure:(BOOL) firstFailure withContext:(id<MFContextProtocol>) context
{
    MFSynchronizationActionParameterOUT *result;
    
    NSString *user = [[MFApplication getInstance] userName];
    
    int identitifyResult = [[[MFBeanLoader getInstance] getBeanWithType:@protocol(MFLocalCredentialServiceProtocol)] doIdentifyWithLogin:user withContext:context];
    
    if (identitifyResult == Identified_OK) {
        result = [[MFSynchronizationActionParameterOUT alloc] init];
        result.resetObjectToSynchronise = !firstFailure;
        result.localAuthentication = true;
    } else if (identitifyResult == Identified_KOCauseDate) {
        result = [[MFSynchronizationActionParameterOUT alloc] init];
        result.waitedTooLongBeforeSync = true;
        MFCoreLogVerbose(@"Waited to long to sync");
    } else if ( identitifyResult == Identified_KO ) {
        MFCoreLogVerbose(@"Could not authentify");
    } else {
        MFCoreLogVerbose(@"Could not authentify (unknown) ");
    }
    
    return result;
}

/**
 * @brief Effectue les mêmes calculs que la méthode java.lang.String.hashCode()
 */
- (long) hashCode:(NSString *) string
{
    long ret = 0;
    
    for (int i=0; i<string.length; i++)
        ret = (ret << 5) - ret + [string characterAtIndex:i];
    
    return ret;
}

@end
