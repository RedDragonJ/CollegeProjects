//
//  PittViewController.m
//  CollegeList
//
//  Created by Hanxin Sun on 10/13/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "PittViewController.h"
#import "PittCampusesViewController.h"
#import "WebViewController.h"

@interface PittViewController () <UITabBarDelegate, UITableViewDataSource>

//declare properties
@property (nonatomic, strong) NSArray* pittInfo;
@property (nonatomic, strong) NSString* pittHistoryName;
@property (nonatomic, strong) NSString* pittCampusesName;
@property (nonatomic, strong) NSString* pittHistoryAddr;

@end

@implementation PittViewController

#pragma mark pitt lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.pittName;
    self.pittInfo = @[@"History", @"Campuses"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark pitt table view
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pittInfo.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mypittstyle"];
    cell.textLabel.text = [self.pittInfo objectAtIndex:indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)//tap on history cell
    {
        self.pittHistoryName = [self.pittInfo objectAtIndex:indexPath.row];
        self.pittHistoryAddr = [NSString stringWithFormat:@"http://www.225.pitt.edu"];
        [self performSegueWithIdentifier:@"webViewPitt" sender:self];//link to new view controller through dentifier
    }
    else if (indexPath.row == 1)//tap on schools cell
    {
        self.pittCampusesName = [self.pittInfo objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"pittSchools" sender:self];//link to new view controller through dentifier
    }
}

#pragma mark Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"pittSchools"])
    {
        PittCampusesViewController* pcvc = (PittCampusesViewController*)[segue destinationViewController];
        pcvc.pittNameTtle = self.pittCampusesName;
    }
    else if ([segue.identifier isEqualToString:@"webViewPitt"])
    {
        WebViewController* pwc = (WebViewController*)[segue destinationViewController];
        pwc.titleName = self.pittHistoryName;
        pwc.webAddrString = self.pittHistoryAddr;
    }
}

@end











