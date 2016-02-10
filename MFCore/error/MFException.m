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
//  MFException.m
//  MFCore
//
//

#import "MFCoreI18n.h"

#import "MFException.h"

@implementation MFException


-(NSString *) description
{
    NSMutableString *mString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"Name : %@\nReason : %@",self.name, self.reason]];
    if(nil != self.innerException)
    {
        [mString appendString:@"\n"];
        [mString appendString:[self.innerException description]];
    }
    return mString;
}


+(MFException *)getNotImplementedExceptionOfMethodName:(NSString *)methodName inClass:(Class)targetClass andUserInfo:(NSDictionary *)info {
    MFException *exception = [[MFException alloc] initWithName:MFLocalizedStringFromKey(@"exception.not.implemented.name") reason:[NSString stringWithFormat:MFLocalizedStringFromKey(@"exception.not.implemented.reason"),methodName, [targetClass description]] userInfo:info];
    return exception;
}

+(void)throwNotImplementedExceptionOfMethodName:(NSString *)methodName inClass:(Class)targetClass andUserInfo:(NSDictionary *)info {
    @throw ([MFException getNotImplementedExceptionOfMethodName:methodName inClass:targetClass andUserInfo:info]);
}

+(MFException *)getExceptionWithName:(NSString *)name andReason:(NSString *)reason andUserInfo:(NSDictionary *)info {
    MFException *exception = [[MFException alloc] initWithName:name reason:reason userInfo:info];
    return exception;
}

+(void)throwExceptionWithName:(NSString *)name andReason:(NSString *)reason andUserInfo:(NSDictionary *)info {
    @throw ([MFException getExceptionWithName:name andReason:reason andUserInfo:info]);
}


@end
