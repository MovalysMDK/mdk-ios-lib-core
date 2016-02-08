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

#import "NSNotification+Identifiable.h"
#import "NSNotificationCenter+Identifiable.h"

@implementation NSNotificationCenter (Identifiable)

- (void)postNotification:(NSNotification *)notification identifier:(NSString *)identifier {
    notification.identifier = identifier;
    [self postNotification:notification];
}

- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject identifier:(NSString *)identifier {
    NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
    notification.identifier = identifier;
    [self postNotification:notification];
    
}
- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo identifier:(NSString *)identifier {
    NSNotification *notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
    notification.identifier = identifier;
    [self postNotification:notification];
}

@end
