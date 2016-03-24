//
//  WebViewController.h
//  CollegeList
//
//  Created by Hanxin Sun on 10/14/15.
//  Copyright © 2015 james. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

//public declaration so other classes can each access it
@property (nonatomic, strong) IBOutlet UIWebView* myWebView;//declare for web view later
@property (nonatomic, strong) NSString* titleName;//pass in title name
@property (nonatomic, strong) NSString* webAddrString;//pass in web address

@end
