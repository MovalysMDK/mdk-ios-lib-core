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

#define MF_CORE_LOG_CONTEXT 1

#define MFCoreLogError(frmt, ...)     SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_ERROR,   MF_CORE_LOG_CONTEXT, frmt, ##__VA_ARGS__)
#define MFCoreLogWarn(frmt, ...)     SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_WARN,    MF_CORE_LOG_CONTEXT, frmt, ##__VA_ARGS__)
#define MFCoreLogInfo(frmt, ...)     SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_INFO,    MF_CORE_LOG_CONTEXT, frmt, ##__VA_ARGS__)
#define MFCoreLogVerbose(frmt, ...)  SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_VERBOSE, MF_CORE_LOG_CONTEXT, frmt, ##__VA_ARGS__)

