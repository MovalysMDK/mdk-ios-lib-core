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

/*!
 * @class MFCsvFileDescriptor
 * @brief This class is a descriptor that allows to describes a CSV file
 * @discussion CSV files are used in generated application with MDK iOS to load some initialized datas.
 * This class allows to describes those files.
 */
@interface MFCsvFileDescriptor : NSObject


#pragma mark - Properties
/*!
 * Object used to have the entity datas
 */
@property(nonatomic) BOOL isFileOK ;

/*!
 * Object used to have the entity datas
 */
@property(nonatomic) BOOL isManyToManyAssociation ;

/*!
  * Simple class to instanciate
  */
@property(nonatomic,weak) Class  modelClass;

/*!
 * Selector in the factory category to affect the dictionary to the object whe the class in not a many to many association
 */
@property(nonatomic) SEL factorySelectorForEntity ;

/*!
 * Left class of association completing with the data of association
 * Right and left class can be interverted
 */
@property(nonatomic,weak) Class  leftAssociationClass ;
/*!
 * Selector used to complete the entity thanks to dictionary data fiven by the parser
 * for the LEFT class
 * Right and left class can be interverted
 */
@property(nonatomic) SEL completionSelectorForLeftClass ;

/*!
 * Right class of association completing with the data of association
 * Right and left class can be interverted
 */
@property(nonatomic,weak) Class  rightAssociationClass ;
/*!
 * Selector used to complete the entity thanks to dictionary data fiven by the parser 
 * for the RIGHT class
 * Right and left class can be interverted
 */
@property(nonatomic) SEL completionSelectorForRightClass ;

/*! 
  * File prefix of the files to load
  */
@property(nonatomic,strong) NSString *filePrefix ;


#pragma mark - Methods
/*!
 * @brief Buils a new instance of this descriptor given a CSV file name and returns it to the caller
 * @param fileName The CSV file name to be described by this object
 * @return The new instance of MFCsvFileDescriptor
 */
-(id) initWithFileName:(NSString *)fileName ;

@end
