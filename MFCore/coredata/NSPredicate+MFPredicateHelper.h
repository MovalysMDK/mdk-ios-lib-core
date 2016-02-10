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
//  MFExpressionHelper.h
//  Pods
//
//
//

#import <CoreData/CoreData.h>

FOUNDATION_EXPORT NSString *const MFQUERY_CLAUSELINK_AND ;
FOUNDATION_EXPORT NSString *const MFQUERY_CLAUSELINK_OR ;

FOUNDATION_EXPORT NSString *const MFQUERY_FUNCTION_MIN ;
FOUNDATION_EXPORT NSString *const MFQUERY_FUNCTION_MAX ;
FOUNDATION_EXPORT NSString *const MFQUERY_FUNCTION_SUM ;
FOUNDATION_EXPORT NSString *const MFQUERY_FUNCTION_AVG ;
FOUNDATION_EXPORT NSString *const MFQUERY_FUNCTION_CNT ;

@interface NSPredicate (MFPredicateHelper)

/*!
 * @brief Build a keypath with format association.attribute
 * @param asso association name
 * @param attribute attribute name
 * @return keypath
 */
+ (NSString *) MF_keyPathForAsso: (NSString *)asso andAttribute:(NSString *) attribute ;

/*!
 * @brief Create a predicate with property equals to value
 * @param property property name
 * @param value value
 * @return predicate
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property equalsToValue:(id) value ;

/*!
 * @brief Create a predicate with property not equals to value
 * @param property property name
 * @param value value
 * @return predicate
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property notEqualsToValue:(id) value ;

/*!
 * @brief Create a predicate with property compared to value using operator
 * @param property property name
 * @param value value
 * @param andOperatorType operator type
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property compareTo:(id)value andOperatorType:(NSPredicateOperatorType)operatorType;

/*!
 * @brief Create a predicate with property like value (case insensitive)
 * @param property property name
 * @param value value
 * @return predicate
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueLike:(id) value ;

/*!
 * @brief Create a predicate with property like %value% (case insensitive)
 * @param property property name
 * @param value value
 * @return predicate
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueContains:(id) value;

/*!
 * @brief Create a predicate with property like value (case sensitive)
 * @param property property name
 * @param value value
 * @return predicate
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueLikeCaseSensitive:(id) value ;

/*!
 * @brief Create a contain predicate with property equals to value
 * @param property property name
 * @param value value
 * @return predicate
 */
+ (NSPredicate *) MF_createContainsPredicateWithProperty: (NSString *)property equalsToValue:(id) value ;

/*!
 * @brief Create a predicate with property between min and max
 * @param property property name
 * @param min min value
 * @param max max value
 * @return predicate
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueBetween:(id)min and:(id) max ;

/*!
 * @brief Create a predicate with value that matches one of values
 * @param property property name
 * @param values list of values
 * @return predicate
 */
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property inValue:(NSArray *) values ;

/*!
 * @brief Inverse a predicate (not)
 * @param pred predicate
 * @return predicate
 */
+ (NSPredicate *) MF_createNotPredicateWithPredicate:(NSPredicate *) pred ;

@end
