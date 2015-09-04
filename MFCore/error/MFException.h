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


#pragma mark - Constants

@interface MFException : NSException

#pragma mark - Properties
@property(nonatomic, strong) NSException *innerException;


#pragma mark - Methods

/*!
 * @brief Builds an not implemented exception
 * @param methodName the name of the method that should be implemented
 * @param targetClass the class in which the method should be implemented
 * @param info A dictionnary containing some informations to display in the exception
 * @return the built NotImplementedException
 */
+(MFException *)getNotImplementedExceptionOfMethodName:(NSString *)methodName inClass:(Class)targetClass andUserInfo:(NSDictionary *)info;

/*!
 * @brief Builds an not implemented exception
 * @param methodName the name of the method that should be implemented
 * @param targetClass the class in which the method should be implemented
 * @param info A dictionnary containing some informations to display in the exception
 */
+(void)throwNotImplementedExceptionOfMethodName:(NSString *)methodName inClass:(Class)targetClass andUserInfo:(NSDictionary *)info;

/*!
 * @brief Builds an basic exception
 * @param name The name of the exception
 * @param reason The reason of the exception
 * @param info A dictionnary containing some informations to display in the exception
 * @return the built basic exception
 */
+(MFException *)getExceptionWithName:(NSString *)name andReason:(NSString *)reason andUserInfo:(NSDictionary *)info;

/*!
 * @brief Builds a basic exception
 * @param name The name of the exception
 * @param reason The reason of the exception
 * @param info A dictionnary containing some informations to display in the exception
 */
+(void)throwExceptionWithName:(NSString *)name andReason:(NSString *)reason andUserInfo:(NSDictionary *)info;
@end
