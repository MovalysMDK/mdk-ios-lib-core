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

#import <Foundation/Foundation.h>

/*!
 * @category NSNotificationCenter+Identifiable
 * @brief Thsi catgory on NSNotificationCenter allows to manage identifable notifications
 * @see NSNotification+Identifiable
 */
@interface NSNotificationCenter (Identifiable)

/*!
 * @brief Posts a given notification to the receiver.
 * @discussion You can create a notification with the NSNotification class method notificationWithName:object:identifier: or notificationWithName:object:userInfo:identifier:. An exception is raised if notification is nil.
 * @param notification The notification to post. This value must not be nil.
 * @param identifier The identifier of the notification. This value must not be nil.
 */
- (void)postNotification:(NSNotification *)notification identifier:(NSString *)identifier;

/*!
 * @brief Posts a given notification to the receiver.
 * @discussion You can create a notification with the NSNotification class method notificationWithName:object:identifier: or notificationWithName:object:userInfo:identifier:. An exception is raised if notification is nil.
 * @param notification The notification to post. This value must not be nil.
 * @param anObject The object posting the notification.
 * @param identifier The identifier of the notification. This value must not be nil.
 */
- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject identifier:(NSString *)identifier;

/*!
 * @brief Posts a given notification to the receiver.
 * @discussion You can create a notification with the NSNotification class method notificationWithName:object:identifier: or notificationWithName:object:userInfo:identifier:. An exception is raised if notification is nil.
 * @param notification The notification to post. This value must not be nil.
 * @param anObject The object posting the notification.
 * @param aUserInfo Information about the the notification. May be nil.
 * @param identifier The identifier of the notification. This value must not be nil.
 */
- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo identifier:(NSString *)identifier;

@end


