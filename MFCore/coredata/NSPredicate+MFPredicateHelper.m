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
//  MFExpressionHelper.m
//  Pods
//
//
//

#import "NSPredicate+MFPredicateHelper.h"

NSString *const MFQUERY_CLAUSELINK_AND = @"AND";
NSString *const MFQUERY_CLAUSELINK_OR = @"OR";

NSString *const MFQUERY_FUNCTION_MIN = @"min:";
NSString *const MFQUERY_FUNCTION_MAX = @"max:";
NSString *const MFQUERY_FUNCTION_SUM = @"sum:";
NSString *const MFQUERY_FUNCTION_AVG = @"avg:";
NSString *const MFQUERY_FUNCTION_CNT = @"count:";

@implementation NSPredicate (MFPredicateHelper)


// keyPath for asso
+ (NSString *) MF_keyPathForAsso: (NSString *)asso andAttribute:(NSString *) attribute {
    return [@[asso, attribute] componentsJoinedByString:@"."];
}

// predicate equalsToValue
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property equalsToValue:(id) value {
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *expValue = [NSExpression expressionForConstantValue:value];
    
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                                              rightExpression:expValue modifier:NSDirectPredicateModifier
                                                         type:NSEqualToPredicateOperatorType options:0 ];
}

// predicate notEqualsToValue
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property notEqualsToValue:(id) value {
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *expValue = [NSExpression expressionForConstantValue:value];
    
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                                              rightExpression:expValue modifier:NSDirectPredicateModifier
                                                         type:NSNotEqualToPredicateOperatorType options:0 ];
}

// predicate compareTo
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property compareTo:(id)value andOperatorType:(NSPredicateOperatorType)operatorType {
    
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *expValue = [NSExpression expressionForConstantValue:value];
        
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                                              rightExpression:expValue modifier:NSDirectPredicateModifier
                                                         type:operatorType options:0 ];
}

// predicate valueLike
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueLike:(id) value {
    
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *expValue = [NSExpression expressionForConstantValue:value];
    
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                                              rightExpression:expValue modifier:NSDirectPredicateModifier
                                                         type:NSLikePredicateOperatorType options:NSCaseInsensitivePredicateOption ];
}

// predicate valueContains
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueContains:(id) value {
    
    NSString *likeValue = [NSString stringWithFormat:@"*%@*",value];
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *expValue = [NSExpression expressionForConstantValue:likeValue];
    
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                                              rightExpression:expValue modifier:NSDirectPredicateModifier
                                                         type:NSLikePredicateOperatorType options:NSCaseInsensitivePredicateOption ];
}


// predicate valueLike casesensitive
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueLikeCaseSensitive:(id) value {
    
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *expValue = [NSExpression expressionForConstantValue:value];
    
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                                              rightExpression:expValue modifier:NSDirectPredicateModifier
                                                         type:NSLikePredicateOperatorType options:0 ];
}

// contains predicate equalsToValue
+ (NSPredicate *) MF_createContainsPredicateWithProperty:(NSString *)property equalsToValue:(id) value {
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *expValue = [NSExpression expressionForConstantValue:value];
    
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                                              rightExpression:expValue modifier:NSDirectPredicateModifier
                                                         type:NSContainsPredicateOperatorType options:0 ];
}

// predicate between
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property valueBetween:(id)min and:(id) max {
    
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *minValue = [NSExpression expressionForConstantValue:min];
    NSExpression *maxValue = [NSExpression expressionForConstantValue:max];
    
    return [NSCompoundPredicate andPredicateWithSubpredicates: @[
        [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                 rightExpression:minValue modifier:NSDirectPredicateModifier
                 type:NSGreaterThanOrEqualToPredicateOperatorType options:0 ],
        [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
                 rightExpression:maxValue modifier:NSDirectPredicateModifier
                 type:NSLessThanOrEqualToPredicateOperatorType options:0 ]
        ]];
}

// predicate inValue
+ (NSPredicate *) MF_createPredicateWithProperty: (NSString *)property inValue:(NSArray *) values
{
    NSExpression *expKeyPath = [NSExpression expressionForKeyPath:property];
    NSExpression *inValueExp = [NSExpression expressionForConstantValue:values];
    return [NSComparisonPredicate predicateWithLeftExpression:expKeyPath
        rightExpression:inValueExp modifier:NSDirectPredicateModifier
        type:NSInPredicateOperatorType options:0 ];
}

// not predicate
+ (NSPredicate *) MF_createNotPredicateWithPredicate:(NSPredicate *) pred
{
    return [NSCompoundPredicate notPredicateWithSubpredicate:pred];
}

@end
