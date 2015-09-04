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


#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "MFCoreBean.h"

#import "MFCoreCoredata.h"

#import "MFContextFactory.h"
#import "MFContextProtocol.h"


@interface MFContextFactory()

@property (strong, nonatomic) MFBeanLoader *_beanLoader;

@end

@implementation MFContextFactory


-(id)init
{
    self = [super init];
    if( self ) {
        __beanLoader = [MFBeanLoader getInstance];
    }
    return self;

}

-(id<MFContextProtocol>) createMFContext {
    id<MFContextProtocol> mfContext = [__beanLoader getBeanWithType:@protocol(MFContextProtocol)];
    return mfContext;
}

-(id<MFContextProtocol>)createMFContextWithCoreDataContext:(NSManagedObjectContext *)entityContext {
    id<MFContextProtocol> mfContext = [__beanLoader getBeanWithType:@protocol(MFContextProtocol)];
    mfContext.entityContext = entityContext;
    [mfContext.entityContext MR_setWorkingName: [entityContext MR_workingName]];
    return mfContext;
}

-(id<MFContextProtocol>) createMFContextWithCoreDataContextForCurrentThread {
    id<MFContextProtocol> mfContext = [__beanLoader getBeanWithType:@protocol(MFContextProtocol)];
    mfContext.entityContext = [[MFApplication getInstance] movalysContext];
    [mfContext.entityContext MR_setWorkingName:@"Default MDK Context"];
    return mfContext;
}

-(id<MFContextProtocol>) createMFContextWithChildCoreDataContext {
    id<MFContextProtocol> mfContext = [__beanLoader getBeanWithType:@protocol(MFContextProtocol)];
    mfContext.entityContext = [NSManagedObjectContext MR_contextWithParent:
                               [[MFApplication getInstance] movalysContext]];
    [mfContext.entityContext MR_setWorkingName:@"Default MDK Context child"];
    [mfContext.entityContext.parentContext MR_setWorkingName:@"Default MDK Context"];
    return mfContext;
}

-(id<MFContextProtocol>) createMFContextWithChildCoreDataContextWithParent:(NSManagedObjectContext *)parentContext {
    id<MFContextProtocol> mfContext = [__beanLoader getBeanWithType:@protocol(MFContextProtocol)];
    mfContext.entityContext = [NSManagedObjectContext MR_contextWithParent:parentContext];
    [mfContext.entityContext MR_setWorkingName:[NSString stringWithFormat:@"%@ child", [parentContext MR_workingName]]];
    return mfContext;
}

-(id<MFContextProtocol>) createMFContextWithDefaultCoreDataContext {
    id<MFContextProtocol> mfContext = [__beanLoader getBeanWithType:@protocol(MFContextProtocol)];
    mfContext.entityContext = [[MFApplication getInstance] movalysContext];
    [mfContext.entityContext MR_setWorkingName:@"Default MDK Context"];
    return mfContext;
}

@end
