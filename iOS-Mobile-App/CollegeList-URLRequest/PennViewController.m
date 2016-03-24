//
//  PennViewController.m
//  CollegeList
//
//  Created by Hanxin Sun on 10/13/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "PennViewController.h"
#import "PennCampusViewController.h"
#import "WebViewController.h"

@interface PennViewController () <UITableViewDataSource, UITabBarDelegate>

//declare properties
@property (nonatomic, strong) NSArray* pennInfo;
@property (nonatomic, strong) NSString* pennHistoryName;
@property (nonatomic, strong) NSString* pennCampusesName;
@property (nonatomic, strong) NSString* pennHistoryAddr;

@end

@implementation PennViewController

#pragma mark penn lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.pennName;
    self.pennInfo = @[@"History", @"Campuses"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark penn table view
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pennInfo.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mypittstyle"];
    cell.textLabel.text = [self.pennInfo objectAtIndex:indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)//tap on history cell
    {
        self.pennHistoryName = [self.pennInfo objectAtIndex:indexPath.row];
        self.pennHistoryAddr = [NSString stringWithFormat:@"http://www.psu.edu/this-is-penn-state/our-history"];
        [self performSegueWithIdentifier:@"webViewPenn" sender:self];//link to new view controller through dentifier
    }
    else if (indexPath.row == 1)//tap on schools cell
    {
        self.pennCampusesName = [self.pennInfo objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"pennSchools" sender:self];//link to new view controller through dentifier
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"pennSchools"])
    {
        PennCampusViewController* pcvc = (PennCampusViewController*)[segue destinationViewController];
        pcvc.pennNameTitle = self.pennCampusesName;
    }
    else if ([segue.identifier isEqualToString:@"webViewPenn"])
    {
        WebViewController* pwc = (WebViewController*)[segue destinationViewController];
        pwc.titleName = self.pennHistoryName;
        pwc.webAddrString = self.pennHistoryAddr;
    }
}

@end
