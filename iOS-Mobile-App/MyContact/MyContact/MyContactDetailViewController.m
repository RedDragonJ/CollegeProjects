//
//  MyContactDetailViewController.m
//  MyContact
//
//  Created by James H Layton on 5/3/17.
//  Copyright © 2017 james. All rights reserved.
//

#import "MyContactDetailViewController.h"

@interface MyContactDetailViewController ()

@property (nonatomic, strong) UIImage* photo;


@end

@implementation MyContactDetailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Detail";
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"edit"] style:UIBarButtonItemStyleDone target:self action:@selector(EditDetails)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    [self ParseImage];
    [self ParseOthers];
}

#pragma mark - Parse
- (void) ParseImage
{
    NSString* imageString = [[NSString alloc]init];
    imageString = [self.detailsInfoDict objectForKey:@"largeImageURL"];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
    self.photo = [UIImage imageWithData:imageData];
    if (self.photo != NULL)
    {
        self.profileImage.image = self.photo;
    }
    
    self.profileImage.layer.cornerRadius = 75;
    self.profileImage.clipsToBounds = true;
}

- (void) ParseOthers
{
    
    //////
    // This is not the most efficient way to handle data, the most desirable is CoreData
    // Here also can use plist and sqlite depend on the situtation
    //////
    NSString* profileName = [[NSString alloc]init];
    NSString* profileCompanyName = [[NSString alloc]init];
    
    NSDictionary* phoneDict = [[NSDictionary alloc]init];
    NSString* phone = [[NSString alloc]init];
    
    NSDictionary* addressDict = [[NSDictionary alloc]init];
    NSString* street = [[NSString alloc]init];
    NSString* city = [[NSString alloc]init];
    NSString* State = [[NSString alloc]init];
    NSString* zip = [[NSString alloc]init];
    NSString* address = [[NSString alloc]init];
    
    NSString* birthday = [[NSString alloc]init];
    
    NSString* email = [[NSString alloc]init];
    
    //name
    profileName = [self.detailsInfoDict objectForKey:@"name"];
    
    //company
    profileCompanyName = [self.detailsInfoDict objectForKey:@"company"];
    
    //home phone
    phoneDict = [self.detailsInfoDict objectForKey:@"phone"];
    phone = [phoneDict objectForKey:@"home"];
    
    //address
    addressDict = [self.detailsInfoDict objectForKey:@"address"];
    street = [addressDict objectForKey:@"street"];
    city = [addressDict objectForKey:@"city"];
    State = [addressDict objectForKey:@"state"];
    zip = [addressDict objectForKey:@"zip"];
    address = [NSString stringWithFormat:@"%@, %@, %@ %@", street, city, State, zip];
    
    //birthday
    birthday = [self.detailsInfoDict objectForKey:@"birthdate"];
    
    //email
    email = [self.detailsInfoDict objectForKey:@"email"];
    
    self.name.text = profileName;
    self.companyName.text = profileCompanyName;
    self.phone.text = phone;
    self.address.text = address;
    self.birthday.text = birthday;
    self.email.text = email;
}

#pragma mark - Helper
- (void) EditDetails
{
    NSLog(@"edit details!!!");
    
    ///////
    //There are many ways to edit the detail view. Popup views, UITextField, or others
    //Most popular would be nib file with popup view
    ///////
}

@end












