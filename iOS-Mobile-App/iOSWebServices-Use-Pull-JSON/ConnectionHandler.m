//
//  ConnectionHandler.m
//  iOSWebServices
//
//  Created by Hanxin Sun on 11/11/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ConnectionHandler.h"

NSString* baseAddress = @"http://www.jaybers.com/json/treasure.php?PittUser=has92&PittStudentID=3830225";

@implementation ConnectionHandler

@synthesize Conn = _Conn;

#pragma mark call method to do JSON
- (void) netWorkConnection:(MyValues *)myval
{
    NSLog(@"networking called");
    
    NSURL* myAddress;
    
    if (myval.key == nil && myval.answer == nil)//first connection
    {
        NSLog(@"first url called");
        myAddress = [[NSURL alloc]initWithString:baseAddress];
    }
    else//second connection
    {
        NSLog(@"second url called");
        NSString* newAddress = [[NSString alloc]initWithFormat:@"%@&SecretKey=%@&AnswerSubmitted=%@", baseAddress, myval.key, myval.answer];//append more string to base string
        myAddress = [[NSURL alloc]initWithString:newAddress];
    }
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:myAddress];//create request
    _Conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];//create connection
    if (_Conn) {//connected
        NSLog(@"connection called");
        webData = [NSMutableData data];//handle data
    }
    
    CFRunLoopRun();//continue background loop until called to stop
}

#pragma mark connection handle
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"----- server response -----");
    [webData setLength:0];//server response, set data container to empty
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"----- receive data -----");
    [webData appendData:data];//downloading chunk data and build into data container
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"----- fail to load data from server -----: %@", error);
    webData = nil;//set data container to nil if server fail
    _Conn = nil;//close connection if server fail
    CFRunLoopStop(CFRunLoopGetCurrent());//stop background loop
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"----- finished load data -----");
    //NSString* dataInfo = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    //NSLog(@"data: %@", dataInfo);
    
    NSError* err;
    NSMutableDictionary* myResult = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&err];//parse downloaded data from data container to dictionary
    
    if (myResult)//dictionary has value
    {
        [self.ch didReceiveDataKey:myResult];//return dictionary to main loop
        //NSLog(@"good: %@", myResult);
        CFRunLoopStop(CFRunLoopGetCurrent());//stop background loop
    }
    else//dictionary empty
    {
        NSLog(@"***** ERROR *****:%@", err);//show parse error
        CFRunLoopStop(CFRunLoopGetCurrent());//stop background loop
    }
}

@end
