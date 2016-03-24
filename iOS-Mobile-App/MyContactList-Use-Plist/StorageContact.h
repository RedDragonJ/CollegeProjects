//
//  StorageContact.h
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface StorageContact : NSObject

+ (id) sharedInstance;

- (void) addContact:(Contact*) ac;
- (void) deleteContact:(NSMutableArray*) dc;

- (NSMutableArray*) getContact: (NSString*) gc;
- (NSMutableArray*) getAllContact;

- (void) updateContact:(NSMutableArray*) uc;

@end
