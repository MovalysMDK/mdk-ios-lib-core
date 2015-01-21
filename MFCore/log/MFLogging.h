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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See theLOG_LEVEL_ERROR
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
// Define LOG LEVEL for this file based on Xcode Configuration
//  MFLogging.h
//  Step2
//
//

#import <CocoaLumberjack/DDLog.h>

// Define LOG LEVEL for this file based on Xcode Configuration
//#ifdef DEBUG
//static const int mfStartLogLevel = LOG_LEVEL_VERBOSE;
//#else
static const int mfStartLogLevel = LOG_LEVEL_ERROR;
//#endif

// active log level
extern int ddLogLevel;

#define MFLOG_LEVEL_VERBOSE @"verbose"
#define MFLOG_LEVEL_DEBUG @"debug"
#define MFLOG_LEVEL_INFO @"info"
#define MFLOG_LEVEL_WARNING @"warning"
#define MFLOG_LEVEL_ERROR @"error"

