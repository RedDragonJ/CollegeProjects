//
//  ViewController.m
//  CollegeList
//
//  Created by Hanxin Sun on 10/13/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ViewController.h"
#import "PennViewController.h"
#import "PittViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* myTableView;
@property (nonatomic, strong) NSArray* collegeNamesArr;
@property (nonatomic, strong) NSString* myPittString;
@property (nonatomic,strong) NSString* myPennString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"listOfColleges"
                                                     ofType:@"txt"];
    NSString* fileContents = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    self.collegeNamesArr = [fileContents componentsSeparatedByString:@"\n"];
    
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
    return self.collegeNamesArr.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cells;
    cells = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mystyle"];
    cells.textLabel.text = [self.collegeNamesArr objectAtIndex:indexPath.row];
    return cells;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //NSLog(@"Click on Pitt");
        self.myPittString = [self.collegeNamesArr objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"pittConnect" sender:self];
    }
    else if (indexPath.row == 1)
    {
        //NSLog(@"Click on Penn");
        self.myPennString = [self.collegeNamesArr objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"pennConnect" sender:self];
    }
}

#pragma mark navigation stuffs
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pittConnect"])
    {
        PittViewController* pittVC = (PittViewController*)[segue destinationViewController];
        pittVC.pittName = self.myPittString;
    }
    else if ([segue.identifier isEqualToString:@"pennConnect"])
    {
        PennViewController* pennVC = (PennViewController*)[segue destinationViewController];
        pennVC.pennName = self.myPennString;
    }
}

@end













