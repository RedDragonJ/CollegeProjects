//
//  FSQPeopleHereTableViewController.m
//  ios-interview
//
//  Created by Samuel Grossberg on 3/17/16.
//  Copyright © 2016 Foursquare. All rights reserved.
//

#import "FSQPeopleHereTableViewController.h"
#import "iosinterview-Swift.h"

@interface FSQPeopleHereTableViewController ()

@property (nonatomic, strong) Venue* venue;
@property (nonatomic, strong) FSQVenue* fsqVenue;
@property (nonatomic, strong) NSMutableArray<Visitor*>* sortedCompleteArray;
@property (nonatomic, strong) NSMutableArray<Visitor*>* nonVisitorArray;
@property (nonatomic) BOOL filterSwitch;

@end

@implementation FSQPeopleHereTableViewController

#pragma mark - FSQPeopleHereTableViewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init all the variables
    self.venue = [[Venue alloc]init];
    self.fsqVenue = [[FSQVenue alloc]init];
    self.sortedCompleteArray = [[NSMutableArray<Visitor*> alloc]init];
    self.nonVisitorArray = [[NSMutableArray<Visitor*> alloc]init];
    
    self.filterSwitch = false;
    
    // Remove other cells
//    self.tableView.tableFooterView = [[UIView alloc]init];
    
    PeopleManager* manager = [[PeopleManager alloc]init];
    [manager getDataWithCompletion:^(NSDictionary<NSString *,id> * _Nullable dict, NSString * _Nullable err) {
        if (err == NULL) {
        
            [self.venue setDataWithJson:dict]; // Set the data to the data model class
            
            [self.nonVisitorArray addObjectsFromArray:self.venue.venueVisitors];
            
            [self.sortedCompleteArray addObjectsFromArray:[self.fsqVenue findNoVisitWithOpenTime:self.venue.venueOpenTime closeTime:self.venue.venueCloseTime inputArray:self.venue.venueVisitors]]; // Get the data fill with no visitors //NOTE: this also can be send back from a seperate delegate
            
            [self.tableView reloadData]; // Update the tableview data
        }
        else {
            
            // Create an error view if something wrong
            // Create a process label // NOTE: normally should use spinner or custom view
            self.tableView.userInteractionEnabled = NO;
            UILabel* errorLabel = [[UILabel alloc]init];
            errorLabel.text = @"Error, try again later!";
            errorLabel.textAlignment = NSTextAlignmentCenter;
            errorLabel.textColor = [UIColor lightGrayColor];
            [errorLabel setFrame:CGRectMake(self.tableView.frame.size.width/2-100, self.tableView.frame.size.height/2-30, 200, 60)];
            [self.tableView addSubview:errorLabel];
        }
    }];
    
}
- (IBAction)filterTableView:(UIBarButtonItem *)sender {
    
    
    if (self.filterSwitch == false) {
        self.filterSwitch = YES;
        [self.tableView reloadData];
    }
    else {
        self.filterSwitch = NO;
        [self.tableView reloadData];
    }
    
}

#pragma mark - Table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.venue.venueVisitors == NULL) {
        return 0;
    }
    else {
        return [self.sortedCompleteArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    
    if (cell == NULL) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VenueCell"];
    }

    if (self.venue.venueVisitors == NULL) {
        return cell;
    }
    else {
        Visitor* visitor = [self.sortedCompleteArray objectAtIndex:indexPath.row];
        
        if (visitor.visitorId == NULL) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = visitor.visitorName;
        NSString* timeStr = [self.fsqVenue getTimeWithFirstTime:visitor.visitorArriveTime secondTime:visitor.visitorLeaveTime];
        cell.detailTextLabel.text = timeStr;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
