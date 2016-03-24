//
//  Contact.m
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "Contact.h"

@interface Contact()
{
    //ivar;
}

@end

@implementation Contact

- (void)logContact //method to log the properties
{
    NSLog(@"%@, %@, %@, %@", self.myLastName, self.myFirstName, self.myEmails, self.myPhones);
}

@end
