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
//  MFKeyboardingUIComponentConfiguration.h
//  MFCore
//
//

#import "MFConfigurationUIComponent.h"

/*!
 * Keyboarding UI component configuration.
 */
@interface MFConfigurationKeyboardingUIComponent : MFConfigurationUIComponent

/*!
 Component maximum length.
 */
@property(nonatomic, strong) NSNumber *maxLength;

/*!
 Component minimum length
 */
@property(nonatomic, strong) NSNumber *minLength;

/*!
 Indicate if the component must be filled.
 */
@property(nonatomic, strong) NSNumber *mandatory;

@end
