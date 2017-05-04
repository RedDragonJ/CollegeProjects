//
//  MyContactDetailViewController.h
//  MyContact
//
//  Created by James H Layton on 5/3/17.
//  Copyright © 2017 james. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface MyContactDetailViewController : BaseView

@property (nonatomic, weak) IBOutlet UIImageView* profileImage;
@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UILabel* companyName;
@property (nonatomic, weak) IBOutlet UILabel* phone;
@property (nonatomic, weak) IBOutlet UILabel* address;
@property (nonatomic, weak) IBOutlet UILabel* birthday;
@property (nonatomic, weak) IBOutlet UILabel* email;

@property (nonatomic, strong) NSMutableDictionary* detailsInfoDict;

@end
