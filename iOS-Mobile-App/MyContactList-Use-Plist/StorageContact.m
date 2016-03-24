//
//  StorageContact.m
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "StorageContact.h"

@implementation StorageContact

+ (id) sharedInstance
{
    static dispatch_once_t pred;
    static StorageContact* sharedInstancePointer;
    dispatch_once(&pred, ^{ sharedInstancePointer = [[StorageContact alloc]init];});
    
    return sharedInstancePointer;
}

///// only ever called once
-(id)init
{
    NSLog(@"Storage contact init");
    self = [super init];
    if (self)
    {
        // do ant initialization here
    }
    return self;
}

#pragma mark randomrecords
/*-(NSString *) randomStringWithLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}*/

//////////
- (void) addContact:(Contact*) ac //add the new contact person information to file
{
 
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSString* fn;
    NSString* ln;
    NSString* email;
    NSString* phone;
    
    NSLog(@"path is: %@", documentsDirectory);
    
    for (int i=1; i<=8712; ++i)//problem load data into file with 50,000 reps at file size over 2.2MB
    {
        fn = [self randomStringWithLength:5];
        ln = [self randomStringWithLength:5];
        email = [self randomStringWithLength:5];
        phone = [self randomStringWithLength:5];
        
        if (![fileManager fileExistsAtPath:filePath])//check if file not exist
        {
            filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];//create new file
            
            NSDictionary* myNewContact = [[NSDictionary alloc]initWithObjectsAndKeys:ln, @"Lastname", fn, @"Firstname", email, @"Emails", phone, @"phone", nil];//create dictionary contain 4 fields
            NSArray* arrayOfDictionary = [[NSArray alloc]initWithObjects: myNewContact, nil];//make dictionary array
            [arrayOfDictionary writeToFile:filePath atomically:YES];//write dictionary array to file
        }
        else// file is there
        {
            NSDictionary* myNewContact = [[NSDictionary alloc]initWithObjectsAndKeys:ln, @"Lastname", fn, @"Firstname", email, @"Emails", phone, @"phone", nil];//create dictionary contain 4 fields
            NSArray* readFileFromPath = [NSArray arrayWithContentsOfFile:filePath];//read file into array
            readFileFromPath = [readFileFromPath arrayByAddingObject:myNewContact];//append the dictionary into the file array
            [readFileFromPath writeToFile:filePath atomically:YES];//rewrite the file array into array in order change the file data
        }
    }*/

    
    
    //!!!TEST!!!// NSLog(@"add one person contact information");
    ///////
    //find file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSLog(@"path is: %@", documentsDirectory);
    
    if (![fileManager fileExistsAtPath:filePath])//check if file not exist
    {
        filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];//create new file
        
        NSDictionary* myNewContact = [[NSDictionary alloc]initWithObjectsAndKeys:ac.myLastName, @"Lastname", ac.myFirstName, @"Firstname", ac.myEmails, @"Emails", ac.myPhones, @"phone", nil];//create dictionary contain 4 fields
        NSArray* arrayOfDictionary = [[NSArray alloc]initWithObjects: myNewContact, nil];//make dictionary array
        [arrayOfDictionary writeToFile:filePath atomically:YES];//write dictionary array to file
    }
    else// file is there
    {
        NSDictionary* myNewContact = [[NSDictionary alloc]initWithObjectsAndKeys:ac.myLastName, @"Lastname", ac.myFirstName, @"Firstname", ac.myEmails, @"Emails", ac.myPhones, @"phone", nil];//create dictionary contain 4 fields
        NSArray* readFileFromPath = [NSArray arrayWithContentsOfFile:filePath];//read file into array
        readFileFromPath = [readFileFromPath arrayByAddingObject:myNewContact];//append the dictionary into the file array
        [readFileFromPath writeToFile:filePath atomically:YES];//rewrite the file array into array in order change the file data
    }
}

//////////
- (void) deleteContact:(NSMutableArray*) dc //delete particular person contact information in file
{
    //!!!TEST!!// NSLog(@"delete one person contact information");

    NSMutableArray* myNewDataArray = [[NSMutableArray alloc]init];//create new mutablearray object
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:filePath];//read file into array
    
    for (NSDictionary* dict in array)//loop array to find all dictionaries
    {
        NSInteger countArray = [array indexOfObject:dict];//count current index inside array
        NSString* tempFirstName = [dict objectForKey:@"Firstname"];
        NSString* tempLastName = [dict objectForKey:@"Lastname"];
        if ([tempFirstName isEqualToString:[dc objectAtIndex:0]] && [tempLastName isEqualToString:[dc objectAtIndex:1]])// check if strings match keys inside dictionary
        {
            myNewDataArray = [NSMutableArray arrayWithArray:array];//copy file array into new array, prevent change to the current looping array which may cause problems
            [myNewDataArray removeObjectAtIndex:countArray];//remove the dictionary at the index where in file array
        }
    }
    [myNewDataArray writeToFile:filePath atomically:YES];//write the new dictionary array to file
}

//////////
- (NSMutableArray*) getContact: (NSString*) gc //read only particular person contact information
{
    NSLog(@"get one person contact information");
    NSArray *a = [gc componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];//split the string pass in by white space and store into array
    
    NSMutableArray* myPersonalContact = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:filePath];//read file into array
    
    for (NSDictionary* dict in array)//loop array to find all dictionaries
    {
        NSString* tempFirstName = [dict objectForKey:@"Firstname"];
        NSString* tempLastName = [dict objectForKey:@"Lastname"];
        if ([tempFirstName isEqualToString:[a objectAtIndex:0]] && [tempLastName isEqualToString:[a objectAtIndex:1]])//check if strings match keys inside dictionary
        {
            //grab all values from current dictionary
            [myPersonalContact addObject:tempLastName];
            [myPersonalContact addObject:tempFirstName];
            [myPersonalContact addObject:[dict objectForKey:@"Emails"]];
            [myPersonalContact addObject:[dict objectForKey:@"phone"]];
        }
    }
    
    return myPersonalContact;// return the array contain one person all information
}

//////////
- (NSMutableArray*) getAllContact //read all contact names
{
    NSLog(@"read all contacts name");
    NSMutableArray* allContacts = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    
    NSArray* array = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary* dict in array)//loop and find dictionary in file array
    {
        NSString* namesMore = [[NSString alloc]initWithFormat:@"%@ %@", [dict objectForKey:@"Lastname"], [dict objectForKey:@"Firstname"]];//grab all the firstname and lastname, then put them inside a single string
        [allContacts addObject:namesMore];//write the string to array
    }
    return allContacts;//return array of contact names
}

//////////
- (void) updateContact:(NSMutableArray*) uc //update the contact information
{
    NSLog(@"updated contact infos: %@", uc);
    
    NSMutableArray* myNewDataArray = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary* dict in array)//loop and find dictionary inside file array
    {
        NSInteger countArray = [array indexOfObject:dict];//count current array index
        NSString* tempFirstName = [dict objectForKey:@"Firstname"];
        NSString* tempLastName = [dict objectForKey:@"Lastname"];
        if ([tempFirstName isEqualToString:[uc objectAtIndex:1]] && [tempLastName isEqualToString:[uc objectAtIndex:0]])//check if strings match the keys inside dictionary
        {
            myNewDataArray = [NSMutableArray arrayWithArray:array];//copy file array into new array to prevent crushes cause by current array while looping
            [myNewDataArray removeObjectAtIndex:countArray];//remove the object at the index
        }
    }
    NSDictionary* updatedInformation = [[NSDictionary alloc]initWithObjectsAndKeys:[uc objectAtIndex:2], @"Lastname", [uc objectAtIndex:3], @"Firstname", [uc objectAtIndex:4], @"Emails", [uc objectAtIndex:5], @"phone", nil];//create new dictionary of new information
    [myNewDataArray addObject:updatedInformation];//append dictionary to new array
    [myNewDataArray writeToFile:filePath atomically:YES];//rewrite the changed dictionary array back to file
}

@end
