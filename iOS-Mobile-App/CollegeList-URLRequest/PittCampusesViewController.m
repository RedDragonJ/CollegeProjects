//
//  PittCampusesViewController.m
//  CollegeList
//
//  Created by Hanxin Sun on 10/13/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "PittCampusesViewController.h"
#import "WebViewController.h"

@interface PittCampusesViewController () <UITableViewDelegate, UITableViewDataSource>

//declare preperties
@property (nonatomic,strong) NSArray* pittCampuses;
@property (nonatomic, strong) NSString* campusName;
@property (nonatomic, strong) NSString* campusWebAddr;

@end

@implementation PittCampusesViewController

#pragma mark lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set title
    self.title = self.pittNameTtle;
    self.pittCampuses = @[@"Pitt - Main", @"Pitt - Bradford", @"Pitt - Greensburg", @"Pitt - Johntown", @"Pitt - Titusville"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view stuffs
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pittCampuses.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mypittstyle"];
    cell.textLabel.text = [self.pittCampuses objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //////////////////
    //link to different school website based on which cell been clicked
    //////////////////
    
    if (indexPath.row == 0)
    {
        self.campusName = [self.pittCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.pitt.edu"];
        [self performSegueWithIdentifier:@"webViewPitt" sender:self];
    }
    else if (indexPath.row == 1)
    {
        self.campusName = [self.pittCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.upb.pitt.edu"];
        [self performSegueWithIdentifier:@"webViewPitt" sender:self];
    }
    else if (indexPath.row == 2)
    {
        self.campusName = [self.pittCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.greensburg.pitt.edu"];
        [self performSegueWithIdentifier:@"webViewPitt" sender:self];
    }
    else if (indexPath.row == 3)
    {
        self.campusName = [self.pittCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.upj.pitt.edu"];
        [self performSegueWithIdentifier:@"webViewPitt" sender:self];
    }
    else if (indexPath.row == 4)
    {
        self.campusName = [self.pittCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.upt.pitt.edu"];
        [self performSegueWithIdentifier:@"webViewPitt" sender:self];
    }
}

#pragma mark Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"webViewPitt"])
    {
        WebViewController* pwc = (WebViewController*)[segue destinationViewController];
        pwc.titleName = self.campusName;
        pwc.webAddrString = self.campusWebAddr;
    }
}

@end









