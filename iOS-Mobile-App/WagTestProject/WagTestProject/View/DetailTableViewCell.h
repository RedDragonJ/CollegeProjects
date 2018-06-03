//
//  DetailTableViewCell.h
//  WagTestProject
//
//  Created by James H Layton on 6/2/18.
//  Copyright © 2018 james. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* customCellImageView;
@property (nonatomic, weak) IBOutlet UILabel* customeCellName;
@property (nonatomic, weak) IBOutlet UILabel* customeCellBadges;

@end
