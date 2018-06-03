//
//  TableViewDataSource.m
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import "TableViewDataSource.h"
#import "DetailTableViewCell.h"

static NSString* const entityName = @"UserImages";
static NSString* const objectKey = @"images";

@implementation TableViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.users = [NSMutableArray<User*> new];
        self.images = [NSMutableArray new];
        
        coredataManager = [CoreDataManager sharedInstance];
        if ([coredataManager fetchDataObjectWith:entityName] == NULL) {
            isCoreDataEmpty = YES;
        }
        else {
            isCoreDataEmpty = NO;
        }
        
        apiManager = [APIManager sharedInstance];
        apiManager.delegate = self;
        [apiManager downloadDataFromAPI:@"https://api.stackexchange.com/2.2/users?site=stackoverflow"];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.users.count > 0) {
        return self.users.count;
    }
    else {
        return 0;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DetailTableViewCell *cell = (DetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"StackOverFlowCell"];
    
    if (self.users.count > 0) {
        User* user = self.users[indexPath.row];
        cell.customeCellName.text = user.userName;
        NSString* badges = [NSString stringWithFormat:@"Gold: %i\nSilver: %i\nBronze: %i", (int)[user.userBadges valueForKey:@"gold"], (int)[user.userBadges valueForKey:@"silver"], (int)[user.userBadges valueForKey:@"bronze"]];
        cell.customeCellBadges.text = badges;
        if (self.images.count > 0) {
            cell.customCellImageView.image = self.images[indexPath.row];
        }
        else {
            cell.customCellImageView.image = [UIImage imageNamed:@"man"];
        }
    }
    else {
        cell.customeCellName.text = @"No Data";
        cell.customeCellBadges.text = @"No Data";
    }
    
    return cell;
}

#pragma mark - APIManagerDelegate
- (void)failedFetchWithError:(NSError *)error {
    self.users = NULL;
    self.images = NULL;
    
    [self.delegate update];
}

- (void)receivedJSON:(NSDictionary *)jsonDict {
    
    NSMutableArray* imageLinks = [NSMutableArray new];
    
    NSArray* arrDicts = (NSArray*)[jsonDict valueForKey:@"items"];
    for (NSDictionary* item in arrDicts) {
        User* singleUser = [[User alloc]initWith:item];
        [imageLinks addObject:singleUser.userGravatar];
        [self.users addObject:singleUser];
    }
    
    if (isCoreDataEmpty == YES) {
        [apiManager downloadImageFromAPIs:imageLinks completion:^(NSArray *imageArray) {
            [self.images addObjectsFromArray:imageArray];
            [self->coredataManager insertNewObject:[self->coredataManager getManagedObjectWith:entityName] set: self.images with:objectKey];
            [self->coredataManager saveContext];
            [self.delegate update];
        }];
    }
    else {
        NSArray* resultArr = [coredataManager fetchDataObjectWith:entityName];
        NSManagedObject* object = (NSManagedObject*)[resultArr firstObject];
        NSArray* savedImages = [object valueForKey:objectKey];
        [self.images addObjectsFromArray:savedImages];
        [self.delegate update];
    }
}

@end
