//
//  ContactDetailViewController.h
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@protocol ContactDetailFormDelegate

-(void)didReceiveInformations:(NSMutableArray*) userInfos;//delegate method

@end

@interface ContactDetailViewController : UIViewController

@property (nonatomic, assign) id<ContactDetailFormDelegate> cdfDelegate;

@property (nonatomic, strong) NSString* myNameInView2;


- (void) getPersonalInfos: (NSString*) person;

- (BOOL) checkWhiteSpaceAndCharacter: (Contact*) checkContact;

@end
