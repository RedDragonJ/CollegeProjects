//
//  TableViewDataSource.h
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "APIManager.h"
#import "CoreDataManager.h"

@protocol DataSourceUpdateDelegate
- (void) update;
@end

@interface TableViewDataSource : NSObject <UITableViewDataSource, APIManagerDelegate> {
    APIManager* apiManager;
    CoreDataManager* coredataManager;
    BOOL isCoreDataEmpty;
}

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) NSMutableArray<User*> *users;
@property (nonatomic, strong) NSMutableArray* images;

@end
