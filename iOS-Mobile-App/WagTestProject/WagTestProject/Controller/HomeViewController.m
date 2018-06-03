//
//  HomeViewController.m
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import "HomeViewController.h"
#import "TableViewDataSource.h"

@interface HomeViewController ()

@property (nonatomic, strong) TableViewDataSource* tableViewDataSource;

@end

@implementation HomeViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = [self.view center];
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    self.tableViewDataSource = [TableViewDataSource new];
    self.tableViewDataSource.delegate = self;
    self.homeTableView.dataSource = self.tableViewDataSource;
    self.homeTableView.delegate = self;
    self.homeTableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DataSourceUpdateDelegate
- (void)update {
    [spinner stopAnimating];
    [self.homeTableView reloadData];
}

@end
