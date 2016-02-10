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
//  MFBeanLoader.m
//  MFCore
//
//

#import "MFBeanLoader.h"
#import "MFBeansAssemblyProtocol.h"
#import "MFCoreLog.h"

@interface MFBeanLoader()

@property (nonatomic, strong) NSDictionary *singletons;

@property (nonatomic, strong) NSDictionary *prototypes;

@property (nonatomic, strong) NSDictionary *singletonInstances;

@end

@implementation MFBeanLoader

+(MFBeanLoader *)getInstance{
    static MFBeanLoader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(id) init {
    self = [super init];
    if (self) {
        NSArray *assemblies = @[
                                @"MFFrameworkExtendedComponentsAssembly",
                                @"MFProjectComponentsAssembly",
                                @"MFProjectGeneratedComponentsAssembly"
                                ];
        
        self.prototypes = [NSMutableDictionary dictionary];
        self.singletonInstances = [NSMutableDictionary dictionary];
        self.singletons = [NSMutableDictionary dictionary];
        
        for(NSString *assemblyClassName in assemblies) {
            [self registerComponentsFromAssembly:NSClassFromString(assemblyClassName)];
        }
    }
    return self;
}

-(void) registerComponentsFromAssembly:(Class)assemblyClass {
    NSMutableDictionary *mutableSingletons = [self.singletons mutableCopy];
    NSMutableDictionary *mutablePrototypes = [self.prototypes mutableCopy];
//    if([assemblyClass conformsToProtocol:@protocol(MFBeansAssemblyProtocol)]) {
        [((id<MFBeansAssemblyProtocol>)[[assemblyClass alloc] init]) registerComponentsInPrototypes:mutablePrototypes andSingletons:mutableSingletons];
//    }
    self.prototypes = mutablePrototypes;
    self.singletons = mutableSingletons;
}


- (id) getBeanWithKey:(NSString *)key {
    id returnObject = [self getOptionalBeanWithKey:key];
    if(!returnObject) {
        @throw([NSException exceptionWithName:@"Undeclared bean" reason:[NSString stringWithFormat:@"No component found for the key %@", key] userInfo:nil]);
    }
    return returnObject;
}

- (id) getBeanWithType:(id)protocol {
    NSString *protocolOrClassKey = NSStringFromProtocol(protocol);
    return [self getBeanWithKey:protocolOrClassKey];
}

- (id) getOptionalBeanWithKey:(NSString *)key {
    id returnObject = nil;
    if(!key) {
        @throw([NSException exceptionWithName:@"Nil Key" reason:@"The beans factory or the Key of the bean is nil (getBeanWithKey)" userInfo:nil]);
    }
    else {
        returnObject = [self.singletonInstances objectForKey:key];
        if(!returnObject) {
            returnObject = [self.singletons objectForKey:key];
            if(returnObject) {
                returnObject = [[((Class)returnObject) alloc] init];
                [(NSMutableDictionary *)self.singletonInstances setObject:returnObject forKey:key];
            }
            else {
                returnObject = [self.prototypes objectForKey:key];
                if(returnObject) {
                    returnObject = [[((Class)returnObject) alloc] init];
                }
            }
        }
    }
    return returnObject;
}

//- (NSArray *) getAllBeansWithType:(id)classOrProtocol {
//    if(classOrProtocol == nil || _beansFactory == nil)
//        @throw([NSException exceptionWithName:@"Nil Key" reason:@"The beans factory or the Key of the bean is nil (getAllBeansWithType)" userInfo:nil]);
//
//    return [_beansFactory allComponentsForType:classOrProtocol];
//}

@end
