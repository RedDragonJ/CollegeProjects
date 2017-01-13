//
//  BabyNameRelatedNamesCell.h
//  BabyNames
//
//  Created by James Sun on 8/17/16.
//
//

#import <UIKit/UIKit.h>
#import "BabyName.h"
#import "BabyNameDetailViewController_iPhone.h"
#import "BabyNameRelatedNamesCollectionViewCell.h"

typedef void (^BabyRelatedNames_completionBlock)(BabyName*);

@interface BabyNameRelatedNamesCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) BabyRelatedNames_completionBlock completionblock;

@property (nonatomic, strong) NSArray* similarBabyNames;

@property (nonatomic, weak) IBOutlet UICollectionView* mycollectionView;

+ (BabyNameRelatedNamesCell*)BabyNameRelatedNamesCell:(UITableView*)tableView;

@end
