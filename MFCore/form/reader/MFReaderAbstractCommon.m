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
//  MFReaderCommon.m
//  MFCore
//
//

#import "MFCoreLog.h"
#import "MFCoreFormDescriptor.h"
#import "MFCoreFormValidator.h"

#import "MFReaderAbstractCommon.h"
#import "MFReaderFactory.h"
#import "MFReaderProtocol.h"
#import "MFReaderStackAttribute.h"
#import "MFReaderAttributeNameDictionary.h"

@interface MFReaderAbstractCommon ()

@property(nonatomic, strong) id<MFDescriptorCommonProtocol> parentDescriptor;

@end

@implementation MFReaderAbstractCommon
@synthesize numberOfErrors = _numberOfErrors;

/**
 * Public API.
 * See interface for more information about it.
 *
 */
-(void) fillDescriptorData:(NSObject<MFDescriptorCommonProtocol> *) parentDescriptor
    withDataFromDictionary:(NSDictionary *) dictionary
{
    [self fillWithValidationDescriptorData:parentDescriptor withDataFromDictionary:dictionary];
}

/**
 * Fill descriptor but don't validate it.
 * Used for partial file.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor
 * @param parentDescriptor - descriptor to fill
 * @param dictionary - data used to fill descriptor
 *
 * @return Indicate if validation is recommended.
 */
-(BOOL) fillWithoutValidationDescriptorData:(NSObject<MFDescriptorCommonProtocol> *) parentDescriptor
                     withDataFromDictionary:(NSDictionary *) dictionary
{
    NSString *name = [dictionary objectForKey:DESCRIPTOR_ATTRIBUTE_NAME];
    MFCoreLogVerbose(@"Process dictionary for element named: %@", name);
    id stuff = nil;
    // Indicate if a partial plist file directly include an array
    BOOL includeArray = NO;
    for (NSString *key in [dictionary allKeys])
    {
        if(includeArray && ![DESCRIPTOR_ATTRIBUTE__INCLUDE isEqualToString:key])
        {
            // If a partial plist file directly include an array and we find other items in this one, we have a syntactic problem.
            MFCoreLogError(@"Bad syntax to include an array in %@", dictionary);
            self.numberOfErrors++;
            // In every case, we don't continue to read this file.
            break;
        }
        stuff = [dictionary objectForKey:key];
        // Only this function can detect a partial plist file which directly includes an array
        includeArray = [self checkKey:key OfDescriptor:parentDescriptor Named:name WithValue:stuff];
    }
    
    
    // If we are in the case of partial plist file which directly includes an array, we need to disabled the validation of the given dictionary.
    return !includeArray;
}

-(void) fillIncludeWithoutValidationDescriptorData:(NSObject<MFDescriptorCommonProtocol> *) parentDescriptor
                            withDataFromDictionary:(NSDictionary *) dictionary
{
    NSString *name = [dictionary objectForKey:DESCRIPTOR_ATTRIBUTE_NAME];
    MFCoreLogVerbose(@"Process dictionary for element named: %@", name);
    // Indicate if a partial plist file directly include an array
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // Only this function can detect a partial plist file which directly includes an array
        [self checkKey:key OfDescriptor:parentDescriptor Named:name WithValue:obj];
    }];
    
}



/**
 * Fill descriptor and validate it if necessary.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor.
 * @param parentDescriptor - descriptor to fill
 * @param dictionary - data used to fill descriptor
 */
-(void) fillWithValidationDescriptorData:(NSObject<MFDescriptorCommonProtocol> *) parentDescriptor
                  withDataFromDictionary:(NSDictionary *) dictionary
{
    // Validator's errors
    NSArray *descriptorErrors = nil;
    if([self fillWithoutValidationDescriptorData:parentDescriptor withDataFromDictionary:dictionary])
    {
        // Global validation
        if(parentDescriptor.name.length == 0)
        {
            //            // Descriptor's name is mandatory
            //            MFCoreLogError(@"Attribut 'name' is missing for element : %@", dictionary);
            //            self.numberOfErrors++;
        }
        else
        {
            NSString *fullName =  [self.parentDescriptor.fileName stringByAppendingFormat:@"-%@", parentDescriptor.name];
            if(fullName) {
                if(![MFReaderAttributeNameDictionary storeAndValidName:fullName]){
                    self.numberOfErrors++;
                }
            }
            else {
                if(![MFReaderAttributeNameDictionary storeAndValidName:parentDescriptor.name]){
                    self.numberOfErrors++;
                }
            }
        }
        // Custom validation : validator search
        descriptorErrors = [self validateDescriptor:parentDescriptor];
        if(nil != descriptorErrors && descriptorErrors.count > 0)
        {
            // Custom validation finds some errors
            MFCoreLogError(@"Error for %@ :%@", dictionary, [descriptorErrors componentsJoinedByString:@"\n"]);
            self.numberOfErrors++;
        }
    }
}

/**
 * Check and process the given key and descriptor.
 *
 * @see MFDescriptorCommonProtocol for more information about descriptor.
 * @param key - attribute name to process
 * @param descriptor - descriptor to fill
 * @param name - descriptor's name
 * @param stuff - attribute corresponding value
 *
 * @return Indicate if plist file root is an array.
 */
-(BOOL) checkKey:(NSString *) key OfDescriptor:(NSObject<MFDescriptorCommonProtocol> *) descriptor
           Named:(NSString *) name WithValue:(id) stuff
{
    // We check if the attribute redirect to new screen description plist file
    if([DESCRIPTOR_ATTRIBUTE__INCLUDE isEqual:key])
    {
        // We check attribute's value type : it must be a NSString (file path)
        if([stuff isKindOfClass:[NSString class]])
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:stuff ofType:@"plist"];
            if(!path)
            {
                MFCoreLogError(@"plist file named %@ doesn't exist", stuff);
                self.numberOfErrors++;
            }
            // Here we can not know the pllist file root type. So we try with NSDictionary
            NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
            if(dictionary)
            {
                // Ok, it's a dictionary : this dictionary can be partial because an other piece of the descriptor can be in the previous plist file. So we fill the descriptor with read data and we don't validate this dictionary.
                [self fillIncludeWithoutValidationDescriptorData:descriptor withDataFromDictionary:dictionary];
            }
            else
            {
                MFCoreLogError(@"partial plist description file named '%@'.plist must be a dictionnary.", stuff);
            }
        }
        else
        {
            // "include" attribute's value isn't a NSString : we have got a problem
            MFCoreLogError(@"Unexpected type for attribute named : %@", key);
            self.numberOfErrors++;
        }
    }
    else
    {
        [MFReaderStackAttribute beginReadAttribute: key];
        [self processKey:key ofDescriptor:descriptor named:name withValue:stuff];
        [MFReaderStackAttribute endReadAttribute: key];
    }
    return NO;
}

/**
 * Process a plist file attribute if this attribute isn't "include" attribute.
 *
 * @param key - Plist file attribute name
 * @param descriptor - current descriptor to fill
 * @param name - descriptor name
 * @param stuff - attribute's value
 */
-(void) processKey:(NSString *) key ofDescriptor:(NSObject<MFDescriptorCommonProtocol> *) descriptor
             named:(NSString *) name withValue:(id) stuff
{
    BOOL affect = NO;
    NSArray *stuffArray = nil;
    NSString *keyAfterMapping = nil;
    NSObject<MFDescriptorCommonProtocol> *child = nil;
    keyAfterMapping = [self mapKey:key];
    MFCoreLogVerbose(@"Process key '%@' of element named '%@'", key, name);
    MFCoreLogVerbose(@"Stuff of key named '%@' is : %@", key, stuff);
    
    if(nil != stuff)
    {
        // If we find a collection type then this is a new object
        if([stuff isKindOfClass:[NSDictionary class]])
        {
            // This is a dictionary : a complex new descriptor. We need the appropriate reader to process it.
            MFCoreLogVerbose(@"stuff of key named '%@' is kind of NSDictionary", key);
            affect = YES;
            if(self.delegate != nil)
            {
                affect = [self.delegate processKey:key WithDictionaryValue:stuff  ForCurrentDescriptor:descriptor];
            }
            if(affect)
            {
                child = [self findAndExecuteReaderFromDictionary:stuff andParentDescriptor:descriptor];
                if(child)
                    [descriptor setValue:child forKey:keyAfterMapping];
                else
                    [descriptor setValue:stuff forKey:key];
                
            }
        }
        else if([stuff isKindOfClass:[NSArray class]])
        {
            // This is an array : each item is new complex object.
            stuffArray = stuff;
            MFCoreLogVerbose(@"stuff of key named '%@' is kind of NSArray (length : %lu)", key, (unsigned long)stuffArray.count);
            NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:((NSArray *) stuff).count];
            [self readDescriptorDataFromArray:stuff toNewArray:newArray withParentDescriptor:descriptor];
            MFCoreLogVerbose(@"stuff of key named '%@' new array length is %lu", key, (unsigned long)newArray.count);
            affect = YES;
            if(self.delegate != nil)
            {
                affect = [self.delegate processKey:key withArrayValue:newArray  forCurrentDescriptor:descriptor];
            }
            if(affect)
            {
                [descriptor setValue:newArray forKey:keyAfterMapping];
            }
        }
        else
        {
            // This isn't a collection type
            MFCoreLogVerbose(@"stuff of key named '%@' isn't kind of NSDictionary or NSArray", key);
            affect = YES;
            if(self.delegate != nil)
            {
                affect = [self.delegate processKey:key withSimpleValue:stuff forCurrentDescriptor:descriptor];
            }
            if(affect)
            {
                [descriptor setValue:stuff forKey:keyAfterMapping];
            }
        }
    }
    if(!affect)
    {
        MFCoreLogWarn(@"The system can not use property named '%@' on element named '%@' with value '%@'",key, name, stuff);
        self.numberOfErrors++;
    }
    
}

/**
 * Map an attribute name with an other.
 *
 * @param key - attribute name to map.
 * @return mapping key
 */
-(NSString *) mapKey:(NSString *) key
{
    NSString *keyAfterMapping = key;
    // Custom mapping
    if([key isEqualToString:DESCRIPTOR_ATTRIBUTE_TYPE])
    {
        keyAfterMapping = @"uitype";
        MFCoreLogVerbose(@"Map key '%@' with key '%@'", key, keyAfterMapping);
    }
    return keyAfterMapping;
}

/**
 * Validate the given descriptor if an appropriate validator exists.
 *
 * @see MFValidatorDescriptorProtocol for more information about validator.
 * @param descriptor - Descriptor to validate
 * @return Array of error messages
 */
-(NSArray *) validateDescriptor:(NSObject<MFDescriptorCommonProtocol> *) descriptor
{
    MFCoreLogVerbose(@"Ask for validator's type : %@", [descriptor class]);
    id<MFValidatorDescriptorProtocol> validator = [MFValidatorDescriptorFactory getValidatorFromDescriptor:descriptor];
    if(nil == validator)
    {
        MFCoreLogVerbose(@"No validator found for type : %@", [descriptor class]);
        return nil;
    }
    else
    {
        return [validator validateDescriptor:descriptor];
    }
}

/**
 * Find the appropriate reader and use it to extract data from given dictionary.
 *
 * @see MFReaderProtocol for more information about reader
 * @param dictionary - data to use
 * @return Descriptor build with dictionary's data
 */
-(NSObject<MFDescriptorCommonProtocol> *) findAndExecuteReaderFromDictionary:(NSDictionary *) dictionary andParentDescriptor:(id<MFDescriptorCommonProtocol>) parent
{
    // We need to read the type name to determine the good reader to load.
    id stuff = [dictionary objectForKey:DESCRIPTOR_ATTRIBUTE_TYPE];
    id<MFReaderProtocol> reader = nil;
    NSString *typeName = nil;
    if(nil != stuff)
    {
        MFCoreLogVerbose(@"Attribute named '%@' (value : %@) found in dictionary : %@", DESCRIPTOR_ATTRIBUTE_TYPE, stuff, dictionary);
        // Type name must be a string
        if([stuff isKindOfClass:[NSString class]])
        {
            // We try to load the corresponding reader
            typeName = (NSString *) stuff;
            reader = [MFReaderFactory createReaderFromTypeName:typeName andParentDescriptor:parent];
        }
    }
    // If the reader is nil then we try to find it with current attribute name
    if(nil == reader)
    {
        reader = [MFReaderFactory createReaderFromStackWithParentDescriptor:parent];
    }
    if(nil != reader)
    {
        // If a reader has been found, we execute it.
        id<MFDescriptorCommonProtocol> descriptor = [reader readFromDictionary:dictionary];
        self.numberOfErrors += reader.numberOfErrors;
        return descriptor;
    }
    else
    {
        //        // else we have an issue.
        //        MFCoreLogError(@"To be unable to load reader for type or attribute '%@'", nil != typeName ? typeName : [MFReaderStackAttribute getCurrentReadAttribute]);
        //        self.numberOfErrors++;
        return nil;
    }
    
}

/**
 * Build a descriptor array from a plist file attribute array.
 *
 * @param array - plist file attribute array
 * @param toArray - descriptor array
 * @param parent - parent of the next descriptor.
 */
-(void) readDescriptorDataFromArray:(NSArray *) array toNewArray:(NSMutableArray *) toArray withParentDescriptor:(id<MFDescriptorCommonProtocol>) parent
{
    for (id stuff in array)
    {
        if([stuff isKindOfClass:[NSDictionary class]])
        {
            MFCoreLogVerbose(@"stuff is kind of NSDictionary");
            [toArray addObject:[self findAndExecuteReaderFromDictionary:stuff andParentDescriptor:parent]];
        }
        else if([stuff isKindOfClass:[NSArray class]])
        {
            MFCoreLogVerbose(@"stuff is kind of NSArray");
            NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:((NSArray *) stuff).count];
            [self readDescriptorDataFromArray:stuff toNewArray:newArray withParentDescriptor:parent];
            [toArray addObject:newArray];
        }
        else
        {
            MFCoreLogVerbose(@"stuff isn't processing because it isn't kind of NSArray or NSDictionnary");
        }
    }
}

#pragma mark - MFReaderProtocol implementation

-(id) initWithParentDescriptor:(id<MFDescriptorCommonProtocol>) parentDescriptor
{
    self = [self init];
    if(self)
    {
        self.parentDescriptor = parentDescriptor;
    }
    return self;
}

/**
 * Don't implement this function here.
 * Create a new class which inherites this class and implements this function.
 */
-(id<MFDescriptorCommonProtocol>) readFromDictionary:(NSDictionary *) dictionary
{
    @throw [NSException exceptionWithName:@"NotImplementedMethod" reason:@"Method named 'readFromDictionary' isn't implemented" userInfo:nil];
}

@end
