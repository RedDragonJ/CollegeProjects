//
//  ViewController.h
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDetailViewController.h"

@interface ViewController : UIViewController <ContactDetailFormDelegate>

@property (nonatomic, strong) NSMutableArray* contactNames;

@property (nonatomic, strong) IBOutlet UITableView* myNewTableView;


- (void) sortMyArray: (NSArray*) sma;

@end

