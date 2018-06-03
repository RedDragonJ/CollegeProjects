//
//  User.m
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWith:(NSDictionary*)userDataDict {
    self = [super init];
    if (self) {
        self.userID = (int)[userDataDict valueForKey:@"account_id"];
        self.userName = [[NSString alloc]initWithFormat:@"%@",[userDataDict valueForKey:@"display_name"]];
        self.userGravatar = [[NSString alloc]initWithFormat:@"%@",[userDataDict valueForKey:@"profile_image"]];
        self.userBadges = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)[userDataDict valueForKey:@"badge_counts"]];
    }
    return self;
}

@end
