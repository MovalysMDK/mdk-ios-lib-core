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
//  MFSettingsValidationManager.h
//  MFCore
//
//

FOUNDATION_EXPORT NSString *const APPLICATION_PARAMETER_USERNAME_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_PARAMETER_PASSWORD_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_PARAMETER_URLSERVER_KEY_PREFERENCE;

FOUNDATION_EXPORT NSString *const APPLICATION_PARAMETER_PROXYLOGIN_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_PARAMETER_PROXYPASSWORD_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_PARAMETER_PROXYURL_KEY_PREFERENCE;

FOUNDATION_EXPORT NSString *const APPLICATION_COMPUTE_PARAMETER_URLSERVERHOST_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_COMPUTE_PARAMETER_URLSERVERPORT_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_COMPUTE_PARAMETER_URLSERVERPATH_KEY_PREFERENCE;

FOUNDATION_EXPORT NSString *const APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERHOST_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERPORT_KEY_PREFERENCE;
FOUNDATION_EXPORT NSString *const APPLICATION_COMPUTE_PARAMETER_PROXYURLSERVERPATH_KEY_PREFERENCE;

FOUNDATION_EXPORT const int TAG_FOR_SETTINGS_UNCOMPLETE_ALERT;

/*!
 * @brief This class manages and validates the user defaults settings
 */
@interface MFSettingsValidationManager : NSObject

#pragma mark - Methods

/*! @brief Notification reception of the change of settings when application is already launched
 * @param notification launched by the system
 */
-(void) settingsUserChanged:(NSNotification *)notification ;

/*!
 * @brief return true the user name settings is correct else return false and open an alert view. Thanks not to take account the notification send when the application modify the settings programmatically to save the backup data
 * @return true if value ok , else false
 */
-(BOOL) isUserSettingsValuesCorrect ;

/*!
 * @brief if the settings have changed reset the database else does nothing
 */
-(void) verifyIfUserFwkSettingsHasChanged ;

/*!
 * @brief copy the settings in order to follow the change of value
 */
-(void) copyUserFwkSettingsToNotModifiableSettings ;

@end
