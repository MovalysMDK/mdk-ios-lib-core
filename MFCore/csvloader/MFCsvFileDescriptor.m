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

#import "MFCsvFileDescriptor.h"

@implementation MFCsvFileDescriptor

static NSString *const CONST_CSV_DATAS_FILE_NAME_SEPARATOR = @"_";

static NSString *const CONST_CSV_DATAS_ATTRIBUTE_SEPARATOR = @"-";

@synthesize isManyToManyAssociation ;

/**
  * Create the description of the parsed file thanks to its name
  * Find the class model to use
  * Find the selector to launch to create or fill the datas
  * @param  p_sFileName file name to parse
  */
-(id) initWithFileName:(NSString *)p_sFileName {
    self = [super init];
    if (self) {
        self.isFileOK = YES ;
        [self findSimpleModelClassOfFile:p_sFileName];
        // Cherche relation many-to ?
        if(nil != self.modelClass) {
            [self findFactorySelectorOfClass:[_modelClass description]];
        } else{
            NSArray* parsedFileName = [p_sFileName componentsSeparatedByString:CONST_CSV_DATAS_FILE_NAME_SEPARATOR];
            if ( [parsedFileName count] == 3 ){
                NSString *sClassName1 = [parsedFileName objectAtIndex:1] ;
                NSString *sClassName2 = [parsedFileName objectAtIndex:2] ;
                self.leftAssociationClass = [self findClassWithName:sClassName1];
                self.rightAssociationClass = [self findClassWithName:sClassName2];
                                    
                self.completionSelectorForLeftClass = [self findCompletionSelectorOfDescriptor:sClassName1] ;
                self.completionSelectorForRightClass = [self findCompletionSelectorOfDescriptor:sClassName2] ;
                self.isManyToManyAssociation = YES ;
            } else{
                MFCoreLogInfo(@"File '%@' is ignored  ", p_sFileName );
                self.isFileOK = NO ;
            }
        }
        MFCoreLogInfo(@"File '%@' is initialized  ", self.description );
    }
    return self ;
}

/**
 * Find the class with the file name given : M%@, if found modify the modelclass attribute 
 * @param p_sFileName containing a separator CONST_CSV_DATAS_FILE_NAME_SEPARATOR and after the name used to search the class
 */
-(void) findSimpleModelClassOfFile:(NSString *)p_sFileName {
    
    MFCoreLogVerbose(@"file short name %@   ", p_sFileName);
    NSUInteger posSepa =  [p_sFileName rangeOfString:CONST_CSV_DATAS_FILE_NAME_SEPARATOR].location ;
    
    if (posSepa != NSNotFound){
        NSString *sClassName = [p_sFileName substringFromIndex:(posSepa+1)] ;
        MFCoreLogVerbose(@"sClassName %@   ", sClassName);
        
        Class oModelClass = NSClassFromString( [@"M" stringByAppendingString:sClassName]) ;
        if(nil == oModelClass) {
            MFCoreLogVerbose(@"Simple Class Name %@ not found ", sClassName );
        } else {
            self.modelClass = oModelClass  ;
            self.isManyToManyAssociation = false ;
            MFCoreLogVerbose(@"oModelClass %@  trouvé ", oModelClass);
        }
    } else {
        MFCoreLogInfo(@" File Name %@ doesn't content the separator '%@' to distinguish the class name ", p_sFileName,CONST_CSV_DATAS_FILE_NAME_SEPARATOR );
        self.isFileOK = FALSE ;
    }
}

/**
  * Find the class with the file name given : M%@
  * @param p_sFileName containing a separator CONST_CSV_DATAS_ATTRIBUTE_SEPARATOR and after the name used to search the class 
  * @return class found or else nil
  */
-(Class) findClassWithName:(NSString *)p_sFileName {
    
    NSUInteger posSepa = [p_sFileName rangeOfString:CONST_CSV_DATAS_ATTRIBUTE_SEPARATOR].location ;
    Class r_oModelClass = nil ;
    if (posSepa != NSNotFound){
        NSString *sClassName = [p_sFileName substringToIndex:posSepa] ;
        r_oModelClass = NSClassFromString( [@"M" stringByAppendingString:sClassName ]) ;
        if(nil == r_oModelClass) {
            MFCoreLogVerbose(@"Many to many Class Name %@ not found ", p_sFileName  );
            self.isFileOK = FALSE ;
        } else {
            //MFCoreLogVerbose(@"oModelClass %@  trouvé ", r_oModelClass);
        }
    }
    return r_oModelClass ;
}
/**
  * Return the selector to use for creating instance with the name of the class  (MF_create%@WithDictionary:inContext:)
  * @param p_sClassName class name of the searched selector
  */
-(void) findFactorySelectorOfClass:(NSString *)p_sClassName {
    NSString *sMethodFactoryClassName = [[NSString alloc] initWithFormat:@"MF_create%@WithDictionary:inContext:" ,p_sClassName]; //MF_createMEmployeeWithDictionary
    
    self.factorySelectorForEntity = NSSelectorFromString(sMethodFactoryClassName);
    
    if( self.factorySelectorForEntity == nil){
        self.isFileOK  = false ;
    }
}
/**
 * Find selector ("MF_completeAtt1WithDictionary:InContext:") with many to many association descriptor name
 * like : class1-att1
 * can be nil if not found
 */
-(SEL) findCompletionSelectorOfDescriptor:(NSString *)p_sClassNameWithAttInParenthesis {
    
    SEL r_selector = nil ;
    NSUInteger posSepa =  [p_sClassNameWithAttInParenthesis rangeOfString:CONST_CSV_DATAS_ATTRIBUTE_SEPARATOR].location ;
    if (posSepa != NSNotFound){
        NSString *sAttName = [p_sClassNameWithAttInParenthesis substringFromIndex:(posSepa+1)];
        
        NSString *sMethodFactoryClassName = [[NSString alloc] initWithFormat:@"MF_fill%@WithDictionary:inContext:" ,[sAttName capitalizedString] ] ; //MF_completeSkillsWithDictionary
        r_selector = NSSelectorFromString(sMethodFactoryClassName);
    }
    return r_selector ;
}
/**
 * Find class (MClass1) in the many to many association descriptor name
 * like : Class1-att1
 * can be nil if not found
 */
-(Class) findCompletedClassOfDescriptor:(NSString *)p_sClassNameWithAttInParenthesis {
    NSUInteger posSepa =  [p_sClassNameWithAttInParenthesis rangeOfString:CONST_CSV_DATAS_ATTRIBUTE_SEPARATOR].location ;
    if (posSepa != NSNotFound){
        NSString *sClassName = [p_sClassNameWithAttInParenthesis substringToIndex:posSepa];
        Class oModelClass = NSClassFromString( [@"M" stringByAppendingString:sClassName]) ;
        if(nil == oModelClass)
        {
            MFCoreLogVerbose(@"Completed Class Name %@ not found ", sClassName );
        }else{
            return oModelClass ;
        }
    }
    return nil ;
}
/**
  * Description text of the instance object
  */
-(NSString *)description{
    NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:100] ;
    [desc appendFormat:@"isFileOK %d \n" , self.isFileOK ];
    [desc appendFormat:@"isManyToManyAssociation %d\n" , isManyToManyAssociation ];
    [desc appendFormat:@"modelClass %@\n" , _modelClass ];
    if ( isManyToManyAssociation ) {
        [desc appendFormat:@"leftAssociationClass %@\n" , _leftAssociationClass ];
        [desc appendFormat:@"rightAssociationClass %@\n" , _rightAssociationClass ];
    }

    return desc ;
}
@end
