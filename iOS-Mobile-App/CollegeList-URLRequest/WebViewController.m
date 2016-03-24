//
//  WebViewController.m
//  CollegeList
//
//  Created by Hanxin Sun on 10/14/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set up title of web page
    self.title = self.titleName;
    NSURL* pittUrl = [NSURL URLWithString:self.webAddrString];
    NSURLRequest* requestObj = [NSURLRequest requestWithURL:pittUrl];
    [self.myWebView loadRequest:requestObj];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
