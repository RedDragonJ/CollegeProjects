//
//  ConnectionHandler.m
//  iOSWebServices
//
//  Created by Hanxin Sun on 11/11/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ConnectionHandler.h"

NSString* baseAddress = @"https://s3.amazonaws.com/technical-challenge/Contacts_v2.json";

@implementation ConnectionHandler

@synthesize Conn = _Conn;

#pragma mark call method to do JSON
- (void) netWorkConnection
{
    NSLog(@"networking called");
    
    NSURL* myAddress = [[NSURL alloc]initWithString:baseAddress];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:myAddress]; //create request
    _Conn = [[NSURLConnection alloc]initWithRequest:request delegate:self]; //create connection
    if (_Conn)
    {
        //connected
        NSLog(@"connection called");
        webData = [NSMutableData data];//handle data
    }
    
    CFRunLoopRun();//continue background loop until called to stop
    
    //////////
    //I also could use NSURLSession, AFNetworking, or Other API call for the connection
    //There are different ways to use it depend on the situation
    ////////
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
    
    NSError* err;
    NSArray* myResult = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&err];//parse downloaded data from data container to dictionary
    
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
