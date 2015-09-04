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


#import "MFCoreLog.h"
#import "MFCoreContext.h"
#import "MFCoreBean.h"

#import "MFGenericLoadDataAction.h"
#import "MFDataLoaderProtocol.h"
#import "MFDataLoaderActionParameterProtocol.h"


@interface MFGenericLoadDataAction()

@property (nonatomic, strong) NSDictionary *filterParameters;

@end


@implementation MFGenericLoadDataAction

NSString *const MFAction_MFGenericLoadDataAction = @"MFGenericLoadDataAction";


-(id) doAction:(id) parameterIn withContext: (id<MFContextProtocol>)context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch {
    MFCoreLogVerbose(@"MFGenericLoadDataAction> doAction");
    NSMutableArray * changedDataLoaderArray = [NSMutableArray array];
    if ( [parameterIn isKindOfClass:[NSArray class]] ) {
        NSArray *dataLoaderParams = parameterIn;
        
        for( id <MFDataLoaderActionParameterProtocol> dataLoaderParam in dataLoaderParams ) {
            [changedDataLoaderArray addObject:[dataLoaderParam getDataLoaderClassName]];
            [self reloadDataLoader:dataLoaderParam withContext:context];
        }
    }
    else {
        id<MFDataLoaderActionParameterProtocol> dataLoaderParam = parameterIn;
        [changedDataLoaderArray addObject:[dataLoaderParam getDataLoaderClassName]];
        [self reloadDataLoader:dataLoaderParam withContext:context];
    }
    
    MFCoreLogVerbose(@"MFGenericLoadDataAction< doAction");
    return changedDataLoaderArray ;
}

-(id) doOnSuccess:(id) parameterOut withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch{
    return nil;
}

-(id) doOnFailed:(id) parameterOut withContext: (id<MFContextProtocol>) context withQualifier:(id<MFActionQualifierProtocol>) qualifier withDispatcher:(MFActionProgressMessageDispatcher*) dispatch{    
    return nil ;
}

-(void) reloadDataLoader:(id<MFDataLoaderActionParameterProtocol>)dataLoaderParameter withContext:(id<MFContextProtocol>)context
{
    NSArray *ids = [dataLoaderParameter getDataIdentifiers] ;
    NSDictionary *options = [dataLoaderParameter getLoadingOptions] ;
    NSString* className = [dataLoaderParameter getDataLoaderClassName] ;
    
    // FTO : On gère ici le cas des entités transient qui n'ont pas de DataLoader, donc pas d'action ?? lancer. il faut voir par la suite comment gèrer ces entités.
    if(![className isEqualToString:@""]) {
    	id<MFDataLoaderProtocol> dataLoader = [[MFBeanLoader getInstance] getBeanWithKey:className];
    	[dataLoader setDataIdentifiers:ids];
    	[dataLoader setLoadingOptions:options];
    
    	self.filterParameters = [dataLoader getFilterParameters];
    	[dataLoader reload:context];
    }
}

@end
