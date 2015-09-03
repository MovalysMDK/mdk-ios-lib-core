//
//  Entity.h
//  
//
//  Created by Lagarde Quentin on 03/09/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * sAttribute;
@property (nonatomic, retain) NSNumber * bAttribute;
@property (nonatomic, retain) NSDate * dAttribute;
@property (nonatomic, retain) NSNumber * fAttribute;
@property (nonatomic, retain) NSNumber * iAttribute;
@property (nonatomic, retain) NSSet *linkedEntities;
@end

@interface Entity (CoreDataGeneratedAccessors)

- (void)addLinkedEntitiesObject:(NSManagedObject *)value;
- (void)removeLinkedEntitiesObject:(NSManagedObject *)value;
- (void)addLinkedEntities:(NSSet *)values;
- (void)removeLinkedEntities:(NSSet *)values;

@end
