//
//  User.h
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (assign) int userID;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSMutableDictionary* userBadges;
@property (nonatomic, strong) NSString* userGravatar;

- (instancetype)initWith:(NSDictionary*)userDataDict;

@end
