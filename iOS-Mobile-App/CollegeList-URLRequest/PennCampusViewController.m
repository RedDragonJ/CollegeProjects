//
//  PennCampusViewController.m
//  CollegeList
//
//  Created by Hanxin Sun on 10/14/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "PennCampusViewController.h"
#import "WebViewController.h"

@interface PennCampusViewController () <UITableViewDataSource, UITableViewDelegate>

//declare preperties
@property (nonatomic,strong) NSArray* pennCampuses;
@property (nonatomic, strong) NSString* campusName;
@property (nonatomic, strong) NSString* campusWebAddr;

@end

@implementation PennCampusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set title
    self.title = self.pennNameTitle;
    self.pennCampuses = @[@"Penn State - Main", @"Penn State - Abington", @"Penn State - Beaver", @"Penn State - Behrend", @"Penn State - Berks"];
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
    return self.pennCampuses.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mypittstyle"];
    cell.textLabel.text = [self.pennCampuses objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //////////////////
    //link to different school website based on which cell been clicked
    //////////////////
    
    if (indexPath.row == 0)
    {
        self.campusName = [self.pennCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.psu.edu"];
        [self performSegueWithIdentifier:@"webViewPenn" sender:self];
    }
    else if (indexPath.row == 1)
    {
        self.campusName = [self.pennCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://abington.psu.edu"];
        [self performSegueWithIdentifier:@"webViewPenn" sender:self];
    }
    else if (indexPath.row == 2)
    {
        self.campusName = [self.pennCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.br.psu.edu"];
        [self performSegueWithIdentifier:@"webViewPenn" sender:self];
    }
    else if (indexPath.row == 3)
    {
        self.campusName = [self.pennCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://psbehrend.psu.edu"];
        [self performSegueWithIdentifier:@"webViewPenn" sender:self];
    }
    else if (indexPath.row == 4)
    {
        self.campusName = [self.pennCampuses objectAtIndex:indexPath.row];
        self.campusWebAddr = [NSString stringWithFormat:@"http://www.bk.psu.edu"];
        [self performSegueWithIdentifier:@"webViewPenn" sender:self];
    }
}

#pragma mark Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"webViewPenn"])
    {
        WebViewController* pwc = (WebViewController*)[segue destinationViewController];
        pwc.titleName = self.campusName;
        pwc.webAddrString = self.campusWebAddr;
    }
}

@end
