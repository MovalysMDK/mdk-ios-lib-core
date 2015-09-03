//
//  LinkEntity.h
//  
//
//  Created by Lagarde Quentin on 03/09/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity;

@interface LinkEntity : NSManagedObject

@property (nonatomic, retain) NSString * sAttribute;
@property (nonatomic, retain) Entity *baseEntity;

@end
