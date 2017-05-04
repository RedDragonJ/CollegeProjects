//
//  MyContactTableViewController.h
//  MyContact
//
//  Created by James H Layton on 5/3/17.
//  Copyright © 2017 james. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "ConnectionHandler.h"

@interface MyContactTableViewController : BaseView <ConnectionHandler, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView* tableview;

@end
