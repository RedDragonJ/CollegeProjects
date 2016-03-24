//
//  ViewController.m
//  iOSWebServices
//
//  Created by Hanxin Sun on 11/9/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ViewController.h"
#import "MyValues.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel* myKey;
@property (nonatomic, weak) IBOutlet UILabel* myResponse;
@property (nonatomic, weak) IBOutlet UILabel* myLocation;
@property (nonatomic, weak) IBOutlet UILabel* myQuestion;
@property (nonatomic, weak) IBOutlet UITextField* myAnswerText;
@property (nonatomic, weak) IBOutlet UIButton* goButton;

@property (nonatomic, strong) NSMutableDictionary* myResult;
@property (nonatomic, strong) NSString* viewKey;
@property (nonatomic, strong) NSString* viewAnswer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.viewKey == nil && self.viewAnswer == nil)//first load view if key and answer are empty
    {
        [self DisableUIStuffs];//disable button and textfield
        [self ShowProgressSpinner];//show spinner
        [self performSelectorInBackground:@selector(doNetworkWrapper) withObject:nil];//call network connection and download data in background
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark dismiss keybroad when touch other places
//method to dismiss keybroad if user touch some else and not editing
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark receive data from background thread
- (void) didReceiveDataKey:(NSMutableDictionary *)newDict
{
    [self parserJSON:newDict];//receive data from background and retrive data to display on view
}

#pragma mark button action
- (IBAction) MyGoButton:(id)sender
{
    NSLog(@"button tapped");
    
    self.viewAnswer = self.myAnswerText.text;//get contents from textfield
    
    [self DisableUIStuffs];//disable button and textfield
    [self ShowProgressSpinner];//display spinner
    [self performSelectorInBackground:@selector(doNetworkWrapper) withObject:nil];//call network connection and download data in background
}

#pragma mark enable/disable UI stuffs
- (void) EnableUIStuffs
{
    NSLog(@"enable ui stuffs");
    [self.goButton setEnabled:YES];//enable button
    [self.myAnswerText setEnabled:YES];//enable textfield
}

- (void)DisableUIStuffs
{
    NSLog(@"disable ui stuffs");
    [self.goButton setEnabled:NO];//disable button
    [self.myAnswerText setEnabled:NO];//disable textfield
}

- (void) parserJSON: (NSMutableDictionary*) myData
{
    NSLog(@"parser");
    //NSLog(@"%@", myData);
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{//run UI stuffs in block
        [self EnableUIStuffs];//enable button and textfield
        [self HideProgressSpinner];//cancel spinner display
        NSMutableDictionary* newDict = [myData objectForKey:@"MappingEntry"];//extract value by this key
        //NSLog(@"new dictionary %@", newDict);
        NSMutableDictionary* newData = [newDict objectForKey:@"Treasure"];//extract value by this key
        //NSLog(@"another new dictionary %@", newData);
        self.viewKey = [newData objectForKey:@"SecretKey"];//save the key for later use
        self.myKey.text = [newData objectForKey:@"SecretKey"];//display key on view
        NSLog(@"response: %@", [newData objectForKey:@"Response"]);
        self.myResponse.text = [newData objectForKey:@"Response"];//display response on view
        self.myLocation.text = [newData objectForKey:@"Location"];//display location on view
        self.myQuestion.text = [newData objectForKey:@"Question"];//display question on view
        self.myAnswerText.text = nil;//set textfield empty
    }];
}

#pragma mark network wrapper
- (void) doNetworkWrapper
{
    ConnectionHandler* chhandler;
    chhandler = [[ConnectionHandler alloc]init];
    chhandler.ch = self;
    //send control to background process main loop pause
    
    MyValues* val;
    val = [[MyValues alloc]init];
    val.key = self.viewKey;
    val.answer = self.viewAnswer;
    //save key and answer to new object class
    
    [chhandler netWorkConnection:val];//call networking connection method
}


@end
