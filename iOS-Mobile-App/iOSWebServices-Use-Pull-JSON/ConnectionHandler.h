//
//  ConnectionHandler.h
//  iOSWebServices
//
//  Created by Hanxin Sun on 11/11/15.
//  Copyright © 2015 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyValues.h"

@protocol ConnectionHandler

- (void) didReceiveDataKey: (NSMutableDictionary*) newDict;

@end

@interface ConnectionHandler : NSObject <NSURLConnectionDataDelegate> //implement this delegate
{
    NSMutableData* webData;
}

@property (nonatomic, assign) id <ConnectionHandler> ch;

@property (nonatomic, strong) NSURLConnection* Conn;

- (void) netWorkConnection: (MyValues*) myval;

@end
