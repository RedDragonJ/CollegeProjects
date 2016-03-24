//
//  Contact.h
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, strong) NSString* myLastName;
@property (nonatomic, strong) NSString* myFirstName;
@property (nonatomic, strong) NSString* myEmails;
@property (nonatomic, strong) NSString* myPhones;

- (void)logContact;

@end
