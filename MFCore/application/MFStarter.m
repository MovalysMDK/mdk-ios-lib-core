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
//  MFStarter.m
//  MFCore
//
//

#import "MFCoreFoundationExt.h"
#import "MFCoreContext.h"
#import "MFCoreBean.h"
#import "MFCoreLog.h"
#import "MFCoreInit.h"
#import "MFCoreCoredata.h"
#import "MFCoreConfig.h"

#import "MFStarter.h"

NSString *const STEP_INIT_PROPERTIES = @"STEP_INIT_PROPERTIES";
NSString *const STEP_INIT_CLASSES = @"STEP_INIT_CLASSES";

NSString *const STARTER_START = @"START";
NSString *const STARTER_END = @"END";
NSString *const STARTER_CLASS_NOT_FOUND = @"CLASS NOT FOUND";

@implementation MFStarter

#define StarterProgressCallbackBlock(PARAM1,PARAM2) \
dispatch_async(dispatch_get_main_queue(),^{ \
if (self.starterProgressCallbackBlock!=nil) { \
self.starterProgressCallbackBlock(PARAM1, PARAM2); \
} \
});\

#define StarterEndCallbackBlock() \
dispatch_async(dispatch_get_main_queue(),^{ \
if (self.starterEndCallbackBlock!=nil) { \
self.starterEndCallbackBlock(); \
} \
});\

#define StarterInitCallbackBlock(PARAM1) \
dispatch_async(dispatch_get_main_queue(),^{ \
if (self.starterInitCallbackBlock!=nil) { \
self.starterInitCallbackBlock(PARAM1); \
} \
});\


+(instancetype) getInstance{
    //Faire un singleton
    static MFStarter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(id) init {
    if (self = [super init]) {
        self.settingsValidationManager = [[MFSettingsValidationManager alloc] init];
        
    }
    return self;
}


- (void) start {
    //Démarrage du framework en mode autonome
    [self initStarterProperties];
    
    [MFHelperQueue configureMainQueue];
    StarterProgressCallbackBlock(STEP_INIT_PROPERTIES, STARTER_START)
    
    MFConfigurationHandler *registry = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    // Récupération des objets instanciés par le beansFactory
    id<MFContextFactoryProtocol> contextFactory = [[MFBeanLoader getInstance] getBeanWithType:@protocol(MFContextFactoryProtocol)];
    
    _propertiesLoaded = YES;
    StarterProgressCallbackBlock(STEP_INIT_PROPERTIES, STARTER_END)
    
    NSString *databaseName = [registry getStringProperty: MFPROP_DATABASE_NAME];
    MFCoreLogInfo(@"  database name: %@", databaseName);
    // Create MFContext for RunInit
    MFCoreLogInfo(@"starter: create mfContext (_firstLaunching=%d)" , _firstLaunching);
    id<MFContextProtocol> mfContext = [contextFactory createMFContext];
    
    //Démarrage des classes du framework
    NSArray *fwks = [[registry getProperty:MFPROP_STARTER_FWK] getArray];
    NSArray *users = [[registry getProperty:MFPROP_STARTER_PROJECT] getArray];
    NSInteger count = 1;
    if (fwks!=nil) {
        count = count + [fwks count];
    }
    if (users!=nil) {
        count = count + [users count];
    }
    NSInteger nsCount = count;
    StarterInitCallbackBlock(nsCount)
    
    StarterProgressCallbackBlock(STEP_INIT_CLASSES, STARTER_START)
    [self startSubStarter: fwks inContext:mfContext];
    
    //Démarrage des classes
    [self startSubStarter: users  inContext:mfContext];
    StarterProgressCallbackBlock(STEP_INIT_CLASSES, STARTER_END)
    
    //Save Core Data Context
    [self saveCoreDataContext:mfContext];
    
    _started = YES;
    StarterEndCallbackBlock()

    MFCoreLogInfo(@"starter: settings verification in main queue %@", [MFHelperQueue isInMainQueue]?@"YES":@"NO");
    [self checkFirstLaunch];
    _startRunning = NO;
}


-(void) startSubStarter:(NSArray *) starters inContext:(id<MFContextProtocol>) mfContext {
    Class tempClass = nil;
    id<MFRunInitProtocol> subStarter = nil;
    for(NSString *starterName in starters) {
        tempClass = NSClassFromString(starterName);
        StarterProgressCallbackBlock(starterName, STARTER_START)
        if (tempClass!=nil) {
            if ([tempClass conformsToProtocol:@protocol(MFRunInitProtocol)]) {
                subStarter = [[MFBeanLoader getInstance] getBeanWithKey: starterName];
                MFCoreLogInfo(@"starter: run init %@ in main queue %@", starterName, [MFHelperQueue isInMainQueue]?@"YES":@"NO");
                [subStarter startUsingContext: mfContext firstLaunch: self.isFirstLaunching];
            }
            StarterProgressCallbackBlock(starterName, STARTER_END)
        }
        else {
            StarterProgressCallbackBlock(starterName, STARTER_CLASS_NOT_FOUND)
        }
    }
}

- (void) setInitCallBack:(MFStarterInitCallBack) initCallBack withProgressCallBack:(MFStarterProgressCallBack) progressCallBack withEndCallBack:(MFStarterEndCallBack) endCallBack{
    self.starterProgressCallbackBlock = progressCallBack;
    self.starterInitCallbackBlock = initCallBack;
    self.starterEndCallbackBlock = endCallBack;
}

- (void) saveFirstLaunching {
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filepath = [docsDirectory stringByAppendingString:@"/.first"];
    [[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil] ;
}

-(void) setupFirstLaunching {
    
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filepath = [docsDirectory stringByAppendingString:@"/.first"];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath] == YES ) {
        [self setFirstLaunching:NO];
    } else {
        [self setFirstLaunching:YES];
    }
}

-(void) checkFirstLaunch {
    if ( _firstLaunching == YES ) {
        // le lancement s'est bien déroulé , on cree le fichier de verif
        
        [self saveFirstLaunching];
        [self.settingsValidationManager copyUserFwkSettingsToNotModifiableSettings];
        _firstLaunching = NO ;
    }else {
        [self.settingsValidationManager verifyIfUserFwkSettingsHasChanged] ;
    }
}

-(void) initStarterProperties {
    _startRunning = YES;
    _started = NO;
    _appFailure = NO;
    _propertiesLoaded = NO;
}

-(void) saveCoreDataContext:(id<MFContextProtocol>)mfContext {
    MFCoreLogInfo(@"starter: save mfContext");
    MFCoreDataHelper *coreDataHelper = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER];
    NSError* error = [coreDataHelper saveContext:mfContext];
    if (error!=nil) {
        [NSException raise:@"Failure saving context" format:@"error: %@", error];
    }
}
@end
