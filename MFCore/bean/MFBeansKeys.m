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


#import "MFBeansKeys.h"

/**
 * Cette classe définit les clés utilisées pour la création des beans de l'application.
 * Il faut que les constantes de ce fichier correspondent à celles dans les fichiers 
 * Framework.xml et OverloadedFrameworl.xml
 */


// Beans Keys

NSString *const BEAN_KEY_CONFIGURATION_HANDLER                          = @"configurationHandler";
NSString *const BEAN_KEY_CORE_DATA_HELPER                               = @"coreDataHelper";
NSString *const BEAN_KEY_CORE_DATA_PERSISTENT_STORE                     = @"coreDataPersistentStore";
NSString *const BEAN_KEY_CORE_DATA_MEMORY_STORE                         = @"coreDataMemoryStore";
NSString *const BEAN_KEY_CSV_LOADER_HELPER                              = @"csvLoaderHelper";
NSString *const BEAN_KEY_BASE_VIEW_MODEL                                = @"baseViewModel";

NSString *const BEAN_KEY_WAIT_RUN_INIT                                  = @"MFWaitRunInit";
NSString *const BEAN_KEY_CORE_DATA_RUN_INIT                             = @"MFCoreDataRunInit";
NSString *const BEAN_KEY_LOAD_FORM_RUN_INIT                             = @"MFLoadFormRunInit";
NSString *const BEAN_KEY_LOAD_VISUAL_CONFIGURATION_RUN_INIT             = @"MFLoadVisualConfigurationRunInit";

NSString *const BEAN_KEY_MAP_VIEW_CONTROLLER                            = @"mapViewController";
NSString *const BEAN_KEY_WEB_VIEW_CONTROLLER                            = @"webViewController";
NSString *const BEAN_KEY_CREATE_EMAIL_VIEW_CONTROLLER                   = @"createEMailViewcontroller";
NSString *const BEAN_KEY_MANAGE_PHOTO_VIEW_CONTROLLER                   = @"managePhotoViewcontroller";
NSString *const BEAN_KEY_PHOTO_DETAILS_VIEW_CONTROLLER                  = @"photoDetailViewcontroller";

NSString *const BEAN_KEY_FIELD_DESCRIPTOR                               = @"fieldDescriptor";
NSString *const BEAN_KEY_SECTION_DESCRIPTOR                             = @"sectionDescriptor";
NSString *const BEAN_KEY_FORM_DESCRIPTOR                                = @"formDescriptor";
NSString *const BEAN_KEY_GROUP_DESCRIPTOR                               = @"groupDescriptor";
NSString *const BEAN_KEY_COLUMN_DESCRIPTOR                              = @"columnDescriptor";
NSString *const BEAN_KEY_WORKSPACE_DESCRIPTOR                           = @"workspaceDescriptor";

NSString *const BEAN_KEY_READER_SECTION                                 = @"sectionReader";
NSString *const BEAN_KEY_READER_FORM                                    = @"formReader";
NSString *const BEAN_KEY_READER_WORKSPACE                               = @"workspaceReader";
NSString *const BEAN_KEY_READER_COLUMN                                  = @"columnReader";

NSString *const BEAN_KEY_PROPERTY                                       = @"property";
NSString *const BEAN_KEY_BINDING_COMPONENT_DESCRIPTOR                   = @"bindingComponentdescriptor";
NSString *const BEAN_KEY_FORM_EXTEND                                    = @"formExtend";

NSString *const BEAN_KEY_EXTENSION_KEYBOARDING_UI_CONTROL               = @"extensionKeyboardingUIControl";
NSString *const BEAN_KEY_EXTENSION_KEYBOARDING_UI_CONTROL_WITH_REG_EXP  = @"extensionKeyboardingUIControlWithRegExp";

NSString *const BEAN_KEY_BASE_COMPONENT                                 = @"baseComponent";
NSString *const BEAN_KEY_TEXT_FIELD                                     = @"textField";
NSString *const BEAN_KEY_LABEL                                          = @"label";

NSString *const BEAN_KEY_POSITION_VIEW_MODEL                            = @"positionViewModel";
NSString *const BEAN_KEY_PHOTO_VIEW_MODEL                               = @"photoViewModel";

NSString *const BEAN_KEY_ACTION_GENERIC_LOAD_DATA                       = @"MFGenericLoadDataAction";

NSString *const BEAN_KEY_VIEW_MODEL_CREATOR                             = @"MViewModelCreator";

NSString *const BEAN_KEY_KEYNOTFOUND                                    = @"MFKeyNotFound";

NSString *const BEAN_KEY_FORM_SEARCH_DELEGATE                           = @"MFFormSearchDelegate";
NSString *const BEAN_KEY_FORM_SEARCH_EXTEND                             = @"MFFormSearchExtend";

NSString *const BEAN_KEY_EXCEPTION                                      = @"MFException";
NSString *const BEAN_KEY_BINDING                                        = @"MFBinding";

NSString *const BEAN_KEY_SECURITY_HELPER                                = @"MFSecurityHelper";



