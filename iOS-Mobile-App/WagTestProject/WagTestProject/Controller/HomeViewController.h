//
//  HomeViewController.h
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewDataSource.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, DataSourceUpdateDelegate> {
    UIActivityIndicatorView* spinner;
}

@property (nonatomic, weak) IBOutlet UITableView* homeTableView;

@end
