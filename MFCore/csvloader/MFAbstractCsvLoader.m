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
//  MFAbstractCsvLoader.m
//  MFCore
//
//

#import "MFCoreContext.h"

#import "MFCsvFileDescriptor.h" 
#import "MFAbstractCsvLoader.h"

@interface MFAbstractCsvLoader()
/**
  * True is the read line is the first in the current file, False else
  */
@property(nonatomic) BOOL isFirstLineOfTheFile  ;
/**
  * Contains the labels (NSString *) of the columns of the CSV file. The label is the key in the dictionary where are saved the data
  */
@property(nonatomic,strong) NSMutableArray *headersLabel ;
/**
  * Contains the data (NSString *) parsed in the file in the same order than the headers labels
  */
@property(nonatomic,strong) NSMutableArray *csvData ;
/**
 * Context of the creation : the linked entity context is used to create entities
 */
@property(nonatomic,weak) id<MFContextProtocol> localContext ;
/**
 * Contains information about the treated file : class name and selector method, to use
 * These informations are created in the init phase.
 */
@property(nonatomic,strong) MFCsvFileDescriptor *fileDescriptor ;
/**
 * Index of the passage when reading CSV file
 */
@property(nonatomic) NSUInteger passageCounter  ;

@end

@implementation MFAbstractCsvLoader

@synthesize fileDescriptor ;

- (void) startUsingContext:(id<MFContextProtocol>)mfContext firstLaunch:(BOOL)firstLaunch {
    
    MFCoreLogInfo(@"startUsingContext with prefix '%@' and type '%@' " , [self prefixOfFilesToLoad] , [self typeOfFilesToLoad] );
    
    self.localContext = mfContext ;
    self.passageCounter = 1 ;
    [self launchDataCsvParsing];
    //self.passageCounter = 2 ;
    //[self launchDataCsvParsing];
    MFCoreLogInfo(@"end startUsingContext ");
 
}

-(NSString *) prefixOfFilesToLoad {
    return nil;
}

-(NSString *) typeOfFilesToLoad {
    return nil;
}

- (void) launchDataCsvParsing {
    MFCoreLogVerbose(@"> launchDataCsvParsing passage %lu " , (unsigned long) self.passageCounter );

    NSArray * resourcesFiles = [[NSBundle mainBundle] pathsForResourcesOfType:[self typeOfFilesToLoad]  inDirectory:@""];
    for(NSString *fileFullPath in resourcesFiles) {
        
        MFCoreLogVerbose(@"fileFullPath : %@   ", fileFullPath);
        NSString *fileName = [[fileFullPath substringFromIndex:[fileFullPath rangeOfString:@"/" options:NSBackwardsSearch].location +1] stringByDeletingPathExtension];
        
        if ( ![fileName hasPrefix: [self prefixOfFilesToLoad]] ) {
            MFCoreLogVerbose(@"File '%@' is ignored because the file name don't begin by '%@' ", fileName ,  [self prefixOfFilesToLoad] );
        } else {
            fileDescriptor = [[MFCsvFileDescriptor alloc] initWithFileName:fileName];
            if ( [fileDescriptor isFileOK] ) {
                MFCSVParser *newP = [[MFCSVParser alloc] initWithContentsOfCSVFile:fileFullPath];
                [newP setDelegate:self];
                //    [newP setRecognizesBackslashesAsEscapes:NO];
                [newP setSanitizesFields:YES];
                [newP parse];
            }
        }
    }
}

/**
 * Delegates parsing methods
 */
- (void) parser:(MFCSVParser *)parser parserDidBeginDocument:(NSString *)csvFile {
    _headersLabel = [[NSMutableArray alloc] init];
    _isFirstLineOfTheFile = YES ;
}
- (void) parser:(MFCSVParser *)parser didBeginLine:(NSUInteger)lineNumber {	
    if ( lineNumber == 1 ){
        _headersLabel = [[NSMutableArray alloc] init];
        _isFirstLineOfTheFile = YES ;
    }else{
        _isFirstLineOfTheFile = NO ;
        _csvData = [[NSMutableArray alloc] init];
    }    
}
- (void)parser:(MFCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    
    if ( _isFirstLineOfTheFile ) {
        [_headersLabel addObject:field];
    }else{
        [_csvData addObject:field];
    }
    
}
- (void) parser:(MFCSVParser *)parser didEndLine:(NSUInteger)lineNumber {
    
    if (lineNumber > 1) { // on transforme pas l entête
        if (  [self.headersLabel count] == [self.csvData count] ) {
            //MFCoreLogInfo(@" datasDictionary header %@ datas %@ ", self.headersLabel , self.csvData   );
            NSDictionary *datasDictionary = [[NSDictionary alloc] initWithObjects:self.csvData forKeys:self.headersLabel];
            
            // on traite les données récupérées 
            [self transformDataToObject:datasDictionary];
            //if ( lineNumber%100 == 0 ) {
                //[[[MFBeanLoader getInstance] getBeanWithKey:BEAN_KEY_CORE_DATA_HELPER] saveContext:self.localContext];
                //}
        } else if ( [self.csvData count] > 1 ){
            MFCoreLogWarn(@"Data Inconsistency Different count between datas %@ and headers %@ ", self.csvData, self.headersLabel );
        }
    }    
}
- (void) parser:(MFCSVParser *)parser parserDidEndDocument:(NSString *)csvFile {
	MFCoreLogVerbose(@"parser ended: %@", csvFile);
}
- (void) parser:(MFCSVParser *)parser didFailWithError:(NSError *)error {
	MFCoreLogVerbose(@"ERROR: %@",     error);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
/**
  * Transform the data and labels parsed in the file to create new entities
  */
-(void) transformDataToObject:(NSDictionary*) p_datasDictionary {
    
    if ( fileDescriptor.isManyToManyAssociation ) {
        // Completion of already existing objects
        if ( [fileDescriptor.leftAssociationClass  respondsToSelector:fileDescriptor.completionSelectorForLeftClass] ){
            [fileDescriptor.leftAssociationClass  performSelector:fileDescriptor.completionSelectorForLeftClass withObject:p_datasDictionary withObject:self.localContext];
            
            //MFCoreLogVerbose(@"MANYTOMANY LEFT selector performed created with dictionary %@" , p_datasDictionary);
        }else{ 
            MFCoreLogInfo(@"MANYTOMANY LEFT newInstance of class ( %@ ) does'nt responds to selector  created ", fileDescriptor.leftAssociationClass );
        }
        
        if ( [fileDescriptor.rightAssociationClass  respondsToSelector:fileDescriptor.completionSelectorForRightClass] ){
            [fileDescriptor.rightAssociationClass  performSelector:fileDescriptor.completionSelectorForRightClass withObject:p_datasDictionary withObject:self.localContext];
            
            //MFCoreLogVerbose(@"MANYTOMANY RIGHT selector performed newInstance %@  created ", newInstance );
        }else{
            MFCoreLogInfo(@"MANYTOMANY RIGHT newInstance of class ( %@ ) does'nt responds to selector  created ", fileDescriptor.rightAssociationClass );
        }
        
    }else{
        if ( self.passageCounter == 1 ) {
            // creation of object by performing factory creation selector
            if ( [fileDescriptor.modelClass  respondsToSelector:fileDescriptor.factorySelectorForEntity] ){
                [fileDescriptor.modelClass  performSelector:fileDescriptor.factorySelectorForEntity withObject:p_datasDictionary withObject:self.localContext];
                //MFCoreLogVerbose(@"1 selector performed newInstance created ");
            }else{
                MFCoreLogInfo(@"1 class ( %@ ) does'nt responds to selector  created ", fileDescriptor.modelClass );
            }
        }/* else if (  self.passageCounter == 2 ) {
            SEL fillAttributesSelector = NSSelectorFromString(@"MF_fillEntityAttributesWithDictionary:inContext:");
            if ( [fileDescriptor.modelClass respondsToSelector:fillAttributesSelector] ){
                //MFCoreLogVerbose(@"2 > perform  fillAttributesSelector ");
                [fileDescriptor.modelClass performSelector:fillAttributesSelector withObject:p_datasDictionary withObject:self.localContext];
            } else {
                MFCoreLogVerbose(@"2 >problem  can't perform fillAttributesSelector ");
            }
        }*/
    }
}
#pragma clang diagnostic pop

@end
