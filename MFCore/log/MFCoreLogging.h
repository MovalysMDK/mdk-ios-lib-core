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
//  MFLogging.h
//  Step2
//
//

#import "MFLogging.h"
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDLogMacros.h>

#define MF_CORE_LOG_CONTEXT 1

#define MFCoreLogError(frmt, ...)       LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, DDLogFlagError,   MF_CORE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MFCoreLogWarn(frmt, ...)        LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, DDLogFlagWarning,    MF_CORE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MFCoreLogInfo(frmt, ...)        LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, DDLogFlagInfo,    MF_CORE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define MFCoreLogVerbose(frmt, ...)     LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, DDLogFlagVerbose, MF_CORE_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)


