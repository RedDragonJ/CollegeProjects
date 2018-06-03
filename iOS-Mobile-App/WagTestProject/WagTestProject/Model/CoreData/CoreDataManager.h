//
//  CoreDataManager.h
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedInstance;
- (void) saveContext;

- (NSManagedObject*) getManagedObjectWith:(NSString*)entity;
- (void) insertNewObject:(NSManagedObject*)object set:(NSArray*)value with:(NSString*)key;
- (nullable NSArray*) fetchDataObjectWith:(NSString*)entity;

@end
