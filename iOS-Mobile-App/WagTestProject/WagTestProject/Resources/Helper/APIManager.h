//
//  APIManager.h
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol APIManagerDelegate
- (void) receivedJSON:(NSDictionary*)jsonDict;
- (void) failedFetchWithError:(NSError*)error;
@end

@interface APIManager : NSObject

@property (nonatomic, weak) id delegate;

+ (APIManager *)sharedInstance;
- (void)downloadDataFromAPI:(NSString*) url;
- (void)downloadImageFromAPIs:(NSArray*)urls completion:(void(^)(NSArray* imageArray))handler;

@end
