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
//#import <Typhoon/TyphoonBlockComponentFactory.h>
//
//#import "MFBeanLoader.h"
//#import "MFCoreLog.h"
//
//#import <Typhoon/TyphoonAssembly+TyphoonAssemblyFriend.h>
//
//@interface MFBeanLoader()
//
///**
// * @brief Crée les beans de l'application
// */
//@property(strong, nonatomic, readonly) TyphoonComponentFactory *beansFactory;
//
//@end
//
//@implementation MFBeanLoader
//
//+(MFBeanLoader *)getInstance{
//    static MFBeanLoader *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc]init];
//    });
//    return instance;
//}
//
//-(id) init {
//    self = [super init];
//    if (self) {
//        // Initialisation de Typhoon et choix entre mode block car mode XML ( ne marche pas sur le terminal)
//        Class oClassMFFrameworkComponents = NSClassFromString(@"MFFrameworkExtendedComponentsAssembly");
//        Class oClassProjComponents = NSClassFromString(@"MFProjectComponentsAssembly");
//        Class oClassProjGenComponents = NSClassFromString(@"MFProjectGeneratedComponentsAssembly");
//#pragma clang diagnostic push
//        
//#pragma GCC diagnostic ignored "-Wundeclared-selector"
//        TyphoonAssembly *oFwkAssembly = [oClassMFFrameworkComponents performSelector:@selector(assembly)] ;
//        TyphoonAssembly *oProjAssembly = [oClassProjComponents performSelector:@selector(assembly)] ;
//        TyphoonAssembly *oProjGenAssembly = [oClassProjGenComponents performSelector:@selector(assembly)] ;
//#pragma clang diagnostic pop
//        
//        _beansFactory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[
//                                                                              oFwkAssembly,
//                                                                              oProjAssembly,
//                                                                              oProjGenAssembly
//                                                                              ]];
//    }
//    
//    return self;
//}
//
//
//- (id) getBeanWithKey:(NSString *)key {
//    if(key == nil || _beansFactory == nil)
//        @throw([NSException exceptionWithName:@"Nil Key" reason:@"The beans factory or the Key of the bean is nil (getBeanWithKey)" userInfo:nil]);
//    return [_beansFactory componentForKey:key];
//}
//
//- (id) getBeanWithType:(id)classOrProtocol {
//    if(classOrProtocol == nil || _beansFactory == nil)
//        @throw([NSException exceptionWithName:@"Nil Key" reason:@"The beans factory or the Key of the bean is nil (getBeanWithType)" userInfo:nil]);
//    
//    return [_beansFactory componentForType:classOrProtocol];
//}
//
//- (id) getOptionalBeanWithKey:(NSString *)key {
//#pragma clang diagnostic push
//#pragma GCC diagnostic ignored "-Wundeclared-selector"
//    if ( ! [_beansFactory performSelector:@selector(definitionForKey:) withObject:key] ) {
//        MFCoreLogVerbose(@"getOptionalBeanWithKey optional bean key not found %@ " ,  key);
//        return nil ;
//    } else {
//        return [_beansFactory componentForKey:key];
//    }
//#pragma clang diagnostic pop
//}
//
//- (NSArray *) getAllBeansWithType:(id)classOrProtocol {
//    if(classOrProtocol == nil || _beansFactory == nil)
//        @throw([NSException exceptionWithName:@"Nil Key" reason:@"The beans factory or the Key of the bean is nil (getAllBeansWithType)" userInfo:nil]);
//    
//    return [_beansFactory allComponentsForType:classOrProtocol];
//}
//
//@end
