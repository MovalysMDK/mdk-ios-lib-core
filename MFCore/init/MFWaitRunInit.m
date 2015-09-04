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


#import "MFCoreConfig.h"
#import "MFCoreBean.h"
#import "MFWaitRunInit.h"

@interface MFWaitRunInit()

/**
 * @brief Une instance de ConfigurationHandler
 */
@property (nonatomic, strong) MFConfigurationHandler *configurationHandler;

@end


@implementation MFWaitRunInit

- (void) startUsingContext:(id<MFContextProtocol>)mfContext firstLaunch:(BOOL)firstLaunch{

    if(!_configurationHandler) {
        _configurationHandler = [[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CONFIGURATION_HANDLER];
    }
    NSNumber *sec = [[_configurationHandler getProperty:MFPROP_MFWaitRunInit_wait] getNumberValue] ;
    
    for (int i=0; i<[sec intValue]*60; ++i) {
        usleep(1000000/60); // 60fps
    }
}

@end
