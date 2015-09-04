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


#import "MFLocalizedString.h"

NSString *const CONST_FRAMEWORK_LOCALIZED_STRING        = @"Localizable-framework";
NSString *const CONST_PROJECT_LOCALIZED_STRING          = @"Localizable-project";

@implementation MFLocalizedString


+(NSString *)localizableStringFromKey:(NSString *)key {
    NSString *string = NSLocalizedStringFromTable(key, CONST_PROJECT_LOCALIZED_STRING, nil);

    if ([string isEqualToString:key]) {
        string = NSLocalizedStringFromTable(key, CONST_FRAMEWORK_LOCALIZED_STRING, nil);
    }
    
    if ([string isEqualToString:key]) {
        string = NSLocalizedString(key, nil);
    }
    
    if ([string isEqualToString:key]) {
        string = key;
    }
    return string;
}

+(NSString *)localizableStringFromKey:(NSString *)key forClass:(Class)aClass{
    NSString *string = [[NSBundle bundleForClass:aClass] localizedStringForKey:(key) value:@"" table:(CONST_PROJECT_LOCALIZED_STRING)];
    
    if ([string isEqualToString:key]) {
        string = [[NSBundle bundleForClass:aClass] localizedStringForKey:(key) value:@"" table:(CONST_FRAMEWORK_LOCALIZED_STRING)];
    }
    
    if ([string isEqualToString:key]) {
        string = NSLocalizedString(key, nil);
    }
    
    if ([string isEqualToString:key]) {
        string = key;
    }
    return string;
}

@end
