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
//  MFFetchOptions.m
//  MFCore
//
//

#import "MFFetchOptions.h"
#import "NSPredicate+MFPredicateHelper.h"

@implementation MFFetchOptions

// init
-(id) init
{
    self = [super init];
    if(self ) {
        _sortDescriptors = [[NSMutableArray alloc] init];
    }
    return self;
}

// create fetchOptions
+(id) createFetchOptions
{
    return [[MFFetchOptions alloc] init] ;
}

// create fetchOptions with predicate
+(id) createFetchOptionsWithPredicate:(NSPredicate *) predicate {
    MFFetchOptions *fetchOptions = [[MFFetchOptions alloc] init];
    fetchOptions.predicate = predicate;
    return fetchOptions;
}

// create fetchOptions with sort
+(id) createFetchOptionsWithSort:(NSArray *) sortDescriptors {
    MFFetchOptions *fetchOptions = [[MFFetchOptions alloc] init];
    for( NSSortDescriptor *sortDesc in sortDescriptors ) {
        [fetchOptions addSort: sortDesc ];
    }
    return fetchOptions;
}

// create fetchOptions with predicate and sort
+(id) createFetchOptionsWithPredicate:(NSPredicate *) predicate andSort:(NSArray *) sortDescriptors{
    MFFetchOptions *fetchOptions = [[MFFetchOptions alloc] init];
    fetchOptions.predicate = predicate;
    for( NSSortDescriptor *sortDesc in sortDescriptors ) {
        [fetchOptions addSort: sortDesc ];
    }
    return fetchOptions;
}

// condition: equals to value
-(void) addEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value
{
    [self addEqualsValueConditionOnProperty:property withValue:value clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: equals to value + clauseLink
-(void) addEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value clauseLink:(NSString *) clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property equalsToValue: value];
    [self addPredicate:pred clauseLink:clauseLink];
}

// condition: not equals to value
-(void) addNotEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value
{
    [self addNotEqualsValueConditionOnProperty:property withValue:value clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: not equals to value + clauseLink
-(void) addNotEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value clauseLink:(NSString *) clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property notEqualsToValue: value];
    [self addPredicate:pred clauseLink:clauseLink];
}

// condition: compare to value + operator type
-(void) addCompareConditionOnProperty:(NSString *)property withValue:(id)value andOperatorType:(NSPredicateOperatorType)operatorType
{
    [self addCompareConditionOnProperty:property withValue:value andOperatorType:operatorType clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: compare to value + operator type + clauseLink
-(void) addCompareConditionOnProperty:(NSString *)property withValue:(id)value andOperatorType:(NSPredicateOperatorType)operatorType clauseLink:(NSString *)clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property compareTo:value andOperatorType:operatorType];
    [self addPredicate:pred clauseLink:clauseLink];
}

// condition: like value
-(void) addLikeValueConditionOnProperty:(NSString *)property withValue:(id) value
{
    [self addLikeValueConditionOnProperty:property withValue:value clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: like value + clauseLink
-(void) addLikeValueConditionOnProperty:(NSString *)property withValue:(id) value clauseLink:(NSString *) clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property valueLike:value];
    [self addPredicate:pred clauseLink:clauseLink];
}

// condition: like value case sensitive
-(void) addLikeValueCaseSensitiveConditionOnProperty:(NSString *)property withValue:(id) value
{
    [self addLikeValueConditionOnProperty:property withValue:value clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: like value case sensitive + clause link
-(void) addLikeValueCaseSensitiveConditionOnProperty:(NSString *)property withValue:(id) value clauseLink:(NSString *) clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property valueLikeCaseSensitive:value];
    [self addPredicate:pred clauseLink:clauseLink];
}

// condition: between values
-(void) addBetweenConditionOnProperty:(NSString *)property valueBetween:(id)min and:(id)max
{
    [self addBetweenConditionOnProperty:property valueBetween:min and:max clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: between values + clause link
-(void) addBetweenConditionOnProperty:(NSString *)property valueBetween:(id)min and:(id)max clauseLink:(NSString *)clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property valueBetween:min and:max];
    [self addPredicate:pred clauseLink:clauseLink];
}

// condition: in value
-(void) addInValueConditionOnProperty:(NSString *)property inValue:(NSArray *)values
{
    [self addInValueConditionOnProperty:property inValue:values clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: in value + clause link
-(void) addInValueConditionOnProperty:(NSString *)property inValue:(NSArray *)values clauseLink:(NSString *)clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property inValue: values];
    [self addPredicate:pred clauseLink:clauseLink];
}

// condition: in value
-(void) addNotInValueConditionOnProperty:(NSString *)property notInValue:(NSArray *)values
{
    [self addNotInValueConditionOnProperty:property notInValue:values clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: not in value + clause link
-(void) addNotInValueConditionOnProperty:(NSString *)property notInValue:(NSArray *)values clauseLink:(NSString *)clauseLink
{
    NSPredicate *pred = [NSPredicate MF_createPredicateWithProperty:property inValue: values];
    NSPredicate *notPred = [NSPredicate MF_createNotPredicateWithPredicate: pred];
    [self addPredicate:notPred clauseLink:clauseLink];
}

// condition: nil value
-(void) addNilConditionOnProperty:(NSString *)property
{
    [self addNilConditionOnProperty:property clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: nil value + clause link
-(void) addNilConditionOnProperty:(NSString *)property  clauseLink:(NSString *) clauseLink
{
    [self addEqualsValueConditionOnProperty:property withValue:nil clauseLink:clauseLink];
}

// condition: not nil value
-(void) addNotNilConditionOnProperty:(NSString *)property
{
    [self addNotNilConditionOnProperty:property clauseLink:MFQUERY_CLAUSELINK_AND];
}

// condition: not nil value + clause link
-(void) addNotNilConditionOnProperty:(NSString *)property clauseLink:(NSString *) clauseLink
{
    [self addNotEqualsValueConditionOnProperty:property withValue:nil clauseLink:clauseLink];
}

// add a predicate + clause link
-(void) addPredicate:(NSPredicate *)pred clauseLink:(NSString *) clauseLink
{
    if ( self.predicate != nil ) {
        
        if ( [clauseLink isEqualToString:MFQUERY_CLAUSELINK_AND]) {
            self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[self.predicate, pred]];
        }
        else {
            self.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[self.predicate, pred]];
        }
    }
    else {
        self.predicate = pred ;
    }
}

// add ascending sort on property
-(void) addAscendingSortOnProperty:(NSString *)propertyName
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    [self addSort: sortDescriptor];
}

// add descending sort on property
-(void) addDescendingSortOnProperty:(NSString *)propertyName
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
    [self addSort: sortDescriptor];
}

// add a sort descriptor
-(void) addSort:(NSSortDescriptor *)sortDescriptor
{
    [[self sortDescriptors] addObject: sortDescriptor];
}

@end
