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


#import "MFCoreI18n.h"

#import "MFError.h"

@implementation MFError

+ (NSString *) getDomainBase
{
    return @"com.sopragroup.mf.error";
}

-(NSString *) domainBase
{
    return [MFError getDomainBase];
}

/*
 Designated initializer. dict may be nil if no userInfo desired.
 */
- (id)initWithCode:(NSInteger)code userInfo:(NSDictionary *)dict{
    self = [super initWithDomain:self.domainBase code:code userInfo:dict];
    return self;
}


- (id)initWithCode:(NSInteger)code localizedDescriptionKey:(NSString *)descriptionKey localizedFailureReasonErrorKey: (NSString *) failureReasonKey
{
self = [super initWithDomain:[self domainBase]
                        code: code
                    userInfo:@{NSLocalizedDescriptionKey :MFLocalizedStringFromKey(descriptionKey),NSLocalizedFailureReasonErrorKey : MFLocalizedStringFromKey(failureReasonKey)}];
    return self;
}

- (id)initWithCode:(NSInteger)code localizedDescriptionKey:(NSString *)descriptionKey
{
    self = [self initWithCode:code localizedDescriptionKey:descriptionKey localizedFailureReasonErrorKey:descriptionKey];
    return self;
}

/*
 Designated initializer. dict may be nil if no userInfo desired.
 */
+ (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict{
    return [NSError errorWithDomain:[MFError getDomainBase] code:code userInfo:dict];
}

@end
