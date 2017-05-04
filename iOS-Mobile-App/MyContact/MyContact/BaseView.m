//
//  BaseView.m
//  iOSWebServices
//
//  Created by Hanxin Sun on 11/9/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "BaseView.h"

@interface BaseView ()

@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@end

@implementation BaseView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) ShowProgressSpinner
{
    NSLog(@"showSpinner");
    if (self.activityIndicator)
    {
        [self.activityIndicator removeFromSuperview];
    }
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    CGPoint centerPoint = self.view.center;
    self.activityIndicator.center = centerPoint;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

- (void) HideProgressSpinner
{
    NSLog(@"hideSpinner");
    if (self.activityIndicator)
    {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
