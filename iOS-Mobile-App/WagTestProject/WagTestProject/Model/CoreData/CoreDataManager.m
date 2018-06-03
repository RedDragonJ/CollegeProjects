//
//  CoreDataManager.m
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"

@implementation CoreDataManager

+ (CoreDataManager *)sharedInstance {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [CoreDataManager new];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) saveContext {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate saveContext];
}

- (NSManagedObjectContext*) getContext {
    NSManagedObjectContext* context = ((AppDelegate*)[[UIApplication sharedApplication]delegate]).persistentContainer.viewContext;
    return context;
}

- (NSManagedObject*) getManagedObjectWith:(NSString*)entity {
    return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self.getContext];
}

- (void) insertNewObject:(NSManagedObject*)object set:(NSArray*)value with:(NSString*)key {
    [object setValue:value forKey:key];
}

- (nullable NSArray*) fetchDataObjectWith:(NSString*)entity {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entity];
    
    NSError* error = NULL;
    NSArray* results = [self.getContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
        return NULL;
    }
    
    if (!([results count] > 0)) {
        return NULL;
    }
    
    return results;
}

@end
