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


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface MFApplication : NSObject

#pragma mark - Properties
/*
 * @brief The specific Movalys CoreData
 */
@property (strong, nonatomic) NSDictionary *movalysCoreDataContext;

#pragma mark - Methods

/*!
 * @brief donne l'unique instance du starter
 */
+(instancetype) getInstance;

/*!
 * @brief retourne un bean d'après la clé key
 * @param key : La clé du bean que l'on souhaite récupérer
 * @return un bean si le composant existe ou une exception si le composant n'est pas paramétré
 */
- (id) getBeanWithKey:(NSString *)key;

/*!
 * @brief retourne un bean d'après la clé key
 * @param key : La clé du bean que l'on souhaite récupérer
 * @return un bean si le composant existe ou 'nil' si le composant n'est pas paramétré
 */
- (id) getOptionalBeanWithKey:(NSString *)key;

/*!
 * @brief retourne un bean d'après un type de Classe ou Protocole
 * @param classOrProtocol : La classe ou le protocole dont oon souhaite récupérer un bean
 * @return un bean si le composant existe ou une exception si le composant n'est pas paramétré */
- (id) getBeanWithType:(id)classOrProtocol;

/*!
 * @brief indique si on est dans le queue principale
 * @return true si on est dans la queue principale
 */
- (BOOL) isInMainQueue;

/*!
 * @brief execute bloc in main queue asynchronously
 */
-(void) execInMainQueue:(void (^)())bloc;

/*!
 * @brief execute bloc in main queue synchronously
 */
-(void) execSyncInMainQueue:(void (^)())bloc;

-(void) launchAction:(NSString *) actionName withCaller:(id) caller withInParameter:(id) parameterIn;

/*!
 * @brief access to the login of user to connect
 * @return a text containing the login of the user
 */
-(NSString *) userName ;
/*!
 * @brief modify the user information to connect to the server
 * @param new user login to connect to the server
 */
-(void) setUserName:(NSString *) p_userName ;
/*!
 * @brief access to the password of user to connect
 * @return a text containing the password of the user
 */
-(NSString *) userPassword ;
/*!
 * @brief modify the user information to connect to the server
 * @param new user password to connect to the server
 */
-(void) setUserPassword:(NSString *) p_userPassword ;
/*!
 * @brief access to the url to connect to the server
 * @return the url to connect to the server
 */
-(NSURL *) urlServer ;
/*!
 * @brief modify the url  to connect to the server
 * @param new server url to connect to the server
 */
-(void) setUrlServer:(NSURL *) p_serverUrl ;

/*!
 * @brief modify the preference value of the given key
 * @param key key of the setting modified
 * @param value new value of the setting specified by the key
 */
-(void) setPreferenceWithKey:(NSString *) key andValue:(NSString *) value ;
/*!
 * @brief return the value of the setting sepcified by the key
 * @param key key of the setting returned
 * @return the value saved in the user settings
 */
-(NSString *) preferenceWithKey:(NSString *) key ;

/*!
 * @brief retourne un identifiant unique pour le device
 * @return identifiant unique du device
 */
-(NSString *) getUniqueId;

/*!
 * @brief déconstruit l'url de connexion au serveur
 */
-(void) computeSettings;

/*!
 * @brief mise à jour d'une préférence avec une valeur numérique
 * @param key clé de la valeur à modifier
 * @param p_value nouvelle valeur de la clé correspondante
 */
-(void) setPreferenceWithKey:(NSString *) key andIntValue:(NSInteger) p_value;

/*!
 * @brief renvoie la valeur numérique d'une préférence
 * @param key clé de la préférence
 * @return valeur de la clé
 */
-(NSInteger) intPreferenceWithKey:(NSString *) key;

/*!
 * @brief renvoie l'identifiant du device tel que connu par le serveur
 */
-(long) getCurrentUserResource;

/*!
 * @brief met à jour l'identifiant du device tel que connu par le serveur
 * @return
 */
-(void) setCurrentUserResource:(long)userResource;

/*!
 * @brief Returns the time in seconds since the application start date
 * @return the time in seconds since the application start date
 */
+(NSTimeInterval) timeSinceApplicationLaunch ;


@end
