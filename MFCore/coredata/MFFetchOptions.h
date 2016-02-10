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
//  MFFetchOptions.h
//  MFCore
//
//

@interface MFFetchOptions : NSObject

@property (nonatomic,strong) NSPredicate *predicate ;
@property (nonatomic,strong,readonly) NSMutableArray *sortDescriptors;
@property (nonatomic,strong) NSNumber *fetchLimit;
@property (nonatomic,strong) NSNumber *fetchOffset;
@property (nonatomic,strong) NSString *cacheName;

/*!
 * @brief create a empty fetch options
 * @return fetch options
 */
+(id) createFetchOptions;

/*!
 * @brief create a fetch options initialized with a predicate
 * @param predicate predicate
 * @return fetch options
 */
+(id) createFetchOptionsWithPredicate:(NSPredicate *) predicate;

/*!
 * @brief create a fetch options initialized with a sort
 * @param sortDescriptor list of sort descriptors
 * @return fetch options
 */
+(id) createFetchOptionsWithSort:(NSArray *) sortDescriptors;

/*!
 * @brief create a fetch options initialized with a predicate
 * @param predicate predicate
 * @return fetch options
 */
+(id) createFetchOptionsWithPredicate:(NSPredicate *) predicate andSort:(NSArray *) sortDescriptors;

/*!
 * @brief add a condition : equals to value
 * @param property property name
 * @param value value
 */
-(void) addEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value ;

/*!
 * @brief add a condition : equals to value
 * @param property property name
 * @param value value
 * @param clauseLink clauseLink
 */
-(void) addEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value clauseLink:(NSString *) clauseLink ;

/*!
 * @brief add a condition : not equals to value
 * @param property property name
 * @param value value
 */
-(void) addNotEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value ;

/*!
 * @brief add a condition : not equals to value
 * @param property property name
 * @param value value
 * @param clauseLink clauseLink
 */
-(void) addNotEqualsValueConditionOnProperty:(NSString *)property withValue:(id) value clauseLink:(NSString *) clauseLink ;

/*!
 * @brief add a condition : compare to value
 * @param property property name
 * @param value value
 * @param operatorType operator type
 */
-(void) addCompareConditionOnProperty:(NSString *)property withValue:(id)value andOperatorType:(NSPredicateOperatorType)operatorType;

/*!
 * @brief add a condition : compare to value
 * @param property property name
 * @param value value
 * @param operatorType operator type
 * @param clauseLink clauseLink
 */
-(void) addCompareConditionOnProperty:(NSString *)property withValue:(id)value andOperatorType:(NSPredicateOperatorType)operatorType clauseLink:(NSString *) clauseLink;


/*!
 * @brief add a condition : like value (case insensitive)
 * @param property property name
 * @param value value
 */
-(void) addLikeValueConditionOnProperty:(NSString *)property withValue:(id)value ;

/*!
 * @brief add a condition : like value (case insensitive)
 * @param property property name
 * @param value value
 * @param clauseLink clause link
 */
-(void) addLikeValueConditionOnProperty:(NSString *)property withValue:(id)value clauseLink:(NSString *)clauseLink;

/*!
 * @brief add a condition : like value (case sensitive)
 * @param property property name
 * @param value value
 */
-(void) addLikeValueCaseSensitiveConditionOnProperty:(NSString *)property withValue:(id) value;

/*!
 * @brief add a condition : like value (case sensitive)
 * @param property property name
 * @param value value
 * @param clauseLink clause link
 */
-(void) addLikeValueCaseSensitiveConditionOnProperty:(NSString *)property withValue:(id) value clauseLink:(NSString *) clauseLink;

/*!
 * @brief add a condition : between values
 * @param property property name
 * @param min min value
 * @param max max value
 */
-(void) addBetweenConditionOnProperty:(NSString *)property valueBetween:(id)min and:(id)max;

/*!
 * @brief add a condition : between values
 * @param property property name
 * @param min min value
 * @param max max value
 * @param clauseLink clause link
 */
-(void) addBetweenConditionOnProperty:(NSString *)property valueBetween:(id)min and:(id)max clauseLink:(NSString *) clauseLink;

/*!
 * @brief add a condition : in value list
 * @param property property name
 * @param values value list
 */
-(void) addInValueConditionOnProperty:(NSString *)property inValue:(NSArray *)values;

/*!
 * @brief add a condition : in value list
 * @param property property name
 * @param values value list
 * @param clauseLink clause link
 */
-(void) addInValueConditionOnProperty:(NSString *)property inValue:(NSArray *)values clauseLink:(NSString *)clauseLink;

/*!
 * @brief add a condition : not in value list
 * @param property property name
 * @param values value list
 */
-(void) addNotInValueConditionOnProperty:(NSString *)property notInValue:(NSArray *)values;

/*!
 * @brief add a condition : not in value list
 * @param property property name
 * @param values value list
 * @param clauseLink clause link
 */
-(void) addNotInValueConditionOnProperty:(NSString *)property notInValue:(NSArray *)values clauseLink:(NSString *)clauseLink;

/*!
 * @brief add condition : property value is nil
 * @param property property name
 */
-(void) addNilConditionOnProperty:(NSString *)property;

/*!
 * @brief add condition : property value is nil
 * @param property property name
 * @param clauseLink clause link
 */
-(void) addNilConditionOnProperty:(NSString *)property  clauseLink:(NSString *) clauseLink ;

/*!
 * @brief add condition : value is not nil
 * @param property property name
 */
-(void) addNotNilConditionOnProperty:(NSString *)property;

/*!
 * @brief add condition : property value is not nil
 * @param property property name
 * @param clauseLink clause link
 */
-(void) addNotNilConditionOnProperty:(NSString *)property  clauseLink:(NSString *) clauseLink ;

/*!
 * @brief add a predicate
 * @param pred predicate to add
 * @param clauseLink clause link
 */
-(void) addPredicate:(NSPredicate *)pred clauseLink:(NSString *) clauseLink;

/*!
 * @brief add an ascending sort
 * @param propertyName property to sort
 * @param ascending ascending
 */
-(void) addAscendingSortOnProperty:(NSString *)propertyName;

/*!
 * @brief add an descending sort
 * @param propertyName property to sort
 * @param ascending ascending
 */
-(void) addDescendingSortOnProperty:(NSString *)propertyName;

/*!
 * @brief add a sort
 * @param sortDescriptor sort descriptor to add
 */
-(void) addSort:(NSSortDescriptor *)sortDescriptor;

@end
