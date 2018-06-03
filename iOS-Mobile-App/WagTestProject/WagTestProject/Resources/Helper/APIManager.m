//
//  APIManager.m
//  WagTestProject
//
//  Created by James H Layton on 6/1/18.
//  Copyright © 2018 james. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (APIManager *)sharedInstance {
    static APIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [APIManager new];
    });
    
    return sharedInstance;
}

- (void)downloadDataFromAPI:(NSString*) urlString {
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask* dataTask = [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response != NULL && error == NULL) {
            NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate receivedJSON:jsonDict];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate failedFetchWithError:error];
            });
        }
        
    }];
    [dataTask resume];
    
}

- (void)downloadImageFromAPIs:(NSArray*)urls completion:(void(^)(NSArray* imageArray))handler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        ^{
            NSMutableArray* tempArr = [NSMutableArray new];
            for (NSString* urlStr in urls) {
                NSURL *myUrl = [NSURL URLWithString:urlStr];
                NSData *myData = [NSData dataWithContentsOfURL:myUrl];
                UIImage *img = [UIImage imageWithData:myData];
                [tempArr addObject:img];
            }
                       
            dispatch_sync(dispatch_get_main_queue(), ^{
                handler((NSArray*)tempArr);
            });
    });
}

@end
