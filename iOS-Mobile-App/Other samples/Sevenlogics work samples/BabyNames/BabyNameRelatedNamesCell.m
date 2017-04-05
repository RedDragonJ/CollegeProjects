//
//  BabyNameRelatedNamesCell.m
//  BabyNames
//
//  Created by James Sun on 8/17/16.
//
//

#import "BabyNameRelatedNamesCell.h"

#import "ViewHelper.h"
#import "Arrayhelper.h"

@implementation BabyNameRelatedNamesCell

+ (BabyNameRelatedNamesCell*)BabyNameRelatedNamesCell:(UITableView*)tableView
{
    static NSString* BabyNameRelatedNamesCellID = @"BabyNameRelatedNamesCellID";
    
    BabyNameRelatedNamesCell* cell = [tableView dequeueReusableCellWithIdentifier:BabyNameRelatedNamesCellID];
    
    if (nil == cell)
    {
        cell = (BabyNameRelatedNamesCell*)[ViewHelper viewFromBundleNamed:@"BabyNameRelatedNamesCell"];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mycollectionView registerNib:[UINib nibWithNibName:@"BabyNameRelatedNamesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BabyNameRelatedNamesCollectionViewCellID"];
    
    [self addSubview:self.mycollectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.mycollectionView.frame = self.contentView.frame;
}

#pragma mark - collection view methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([ArrayHelper isEmptyArray:self.similarBabyNames])
    {
        return 0;
    }
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.similarBabyNames count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BabyName* similarBaby = [self.similarBabyNames objectAtIndex:[indexPath row]];
    NSString* relatedName = similarBaby.babyName;
    
    //quicksand doesn't work here because no font file.
    UIFont* font = [UIFont fontWithName:@"MyriadPro-Regular" size:18.0];
    CGSize idealSize = [ViewHelper idealStringSize:relatedName withWidth:0 withFont:font];
    
    return CGSizeMake(idealSize.width + 8.0, CGRectGetHeight(self.mycollectionView.frame));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BabyNameRelatedNamesCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BabyNameRelatedNamesCollectionViewCellID" forIndexPath:indexPath];
    
    BabyName* similarBaby = [self.similarBabyNames objectAtIndex:[indexPath row]];
    
    cell.namelabel = [[SL_BabyNameLabel alloc]init];
    cell.namelabel.babyName = similarBaby;
    
    cell.relatedNameLabel.text = cell.namelabel.babyName.babyName;
    cell.relatedNameLabel.textColor = cell.namelabel.textColor;
    
    return cell;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,20,0,12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BabyName* similarBaby = [self.similarBabyNames objectAtIndex:[indexPath row]];
    
    /////TEST/////
    //NSString* selectedText = similarBaby.babyName;
    //NSLog(@"------- clicked on %@", selectedText);
    
    if (self.completionblock != nil)
    {
        self.completionblock(similarBaby);
    }
}

@end
