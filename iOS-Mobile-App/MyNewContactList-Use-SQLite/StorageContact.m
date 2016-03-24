//
//  StorageContact.m
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "StorageContact.h"
#import "Contact.h"
#import "sqlite3.h"

@implementation StorageContact

//global stuff
sqlite3* db;

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

#pragma mark database stuff
- (NSString*)getDBFilePath
{
    // doc path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (BOOL)createOrOpenDataBaseFile: (NSString*) newPath
{
    if (sqlite3_open([newPath UTF8String], &db) == SQLITE_OK)
    {
        //db file create ok
        return true;
    }
    else
    {
        //fail to create db file
        sqlite3_close(db);
        return false;
    }
}

- (BOOL)createDBSystemToDBFile
{
    char* err;
    NSString* sqlCreate = @"CREATE TABLE \"Contacts\" (\"FirstName\" VARCHAR, \"LastName\" VARCHAR, \"Phone\" VARCHAR, \"Email\" VARCHAR, \"ID\" INTEGER PRIMARY KEY  NOT NULL  UNIQUE )";
    //NSLog(@"-----%@-----", sqlCreate);
    
    if (sqlite3_exec(db, [sqlCreate UTF8String], NULL, NULL, &err) == SQLITE_OK)
    {
        //create db table ok
        return true;
    }
    else
    {
        //fail create db table
        return false;
    }
}

- (BOOL) InsertToRecord: (Contact*)myNewContact
{
    NSLog(@"6");
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO Contacts('FirstName', 'LastName', 'Phone', 'Email') VALUES('%@', '%@', '%@', '%@')", myNewContact.myFirstName, myNewContact.myLastName, myNewContact.myPhones, myNewContact.myEmails];
    NSLog(@"sql is:%@", sql);
    
    const char* cstr = [sql UTF8String];
    char* err;
    if (sqlite3_exec(db, cstr, NULL, NULL, &err) == SQLITE_OK)
    {
        //add data to file ok
        return true;
    }
    else
    {
        //fail add data to file
        return false;
    }
}

- (void) testInsertFirst:(NSString*) first testInsertLast:(NSString*) last testInsertPhone:(NSString*) phone testInsertEmail:(NSString*) email
{
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO Contacts('FirstName', 'LastName', 'Phone', 'Email') VALUES('%@', '%@', '%@', '%@')", first, last, phone, email];
    
    const char* cstr = [sql UTF8String];
    char* err;
    if (sqlite3_exec(db, cstr, NULL, NULL, &err) != SQLITE_OK)
    {
        //bad todo handle
        NSLog(@"insert fail");
    }
    else
    {
        //worked
        NSLog(@"insert worked");
    }

}

- (BOOL) DeleteFirst: (NSString*)myFirstName  DeleteLast: (NSString*)myLastName
{
    NSString* deleteSQL=[NSString stringWithFormat:@"DELETE FROM Contacts WHERE FirstName = '%@' AND LastName = '%@'", myFirstName, myLastName];
    char* err;
    
    if(sqlite3_exec(db, [deleteSQL UTF8String], NULL, NULL, &err) == SQLITE_OK)
    {
        //success to delete
        return true;
    }
    else
    {
        //fail to delete
        return false;
    }
}

- (BOOL) UpdateFirst: (NSString*)firstName UpdateLast: (NSString*)lastName UpdatePhone: (NSString*)phone UpdateEmail: (NSString*)email myFirst: (NSString*) testFirstName myLast: (NSString*) testLastName
{
    NSString* updateSQL=[NSString stringWithFormat:@"UPDATE Contacts SET FirstName = '%@', LastName = '%@', Phone = '%@', Email = '%@' WHERE FirstName = '%@' AND LastName = '%@'", firstName, lastName, phone, email, testFirstName, testLastName];
    sqlite3_stmt* statement;

    if(sqlite3_prepare_v2(db, [updateSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        //success to delete
        sqlite3_step(statement);
        return true;
    }
    else
    {
        //fail to delete
        return false;
    }
}

#pragma mark randomrecords
-(NSString *) randomStringWithLength: (int) len
{
 
 NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
 NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
 
 for (int i=0; i<len; i++)
 {
     [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
 }
 
 return randomString;
}

- (void) testAddContact
{
    bool DBFileDecide;
    NSMutableString* path = [NSMutableString stringWithString:[self getDBFilePath]];
    NSLog(@"path is:%@", path);
    NSString* pathFile = [path stringByAppendingPathComponent:@"MyContacts.sqlite"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:pathFile])
    {
        DBFileDecide = [self createOrOpenDataBaseFile:pathFile];
        if (DBFileDecide == true)
        {
            //successful
            NSLog(@"***** create or open the file ok *****");
            NSString* fn;
            NSString* ln;
            NSString* email;
            NSString* phone;
            
            for (int i=1; i<=50000; ++i)
            {
                fn = [self randomStringWithLength:5];
                ln = [self randomStringWithLength:5];
                email = [self randomStringWithLength:5];
                phone = [self randomStringWithLength:5];
                
                [self testInsertFirst:fn testInsertLast:ln testInsertPhone:phone testInsertEmail:email];
            }
        }
        else
        {
            NSLog(@"fail to add to file");
        }
    }
}

//////////
- (BOOL) addContact:(Contact*) ac //add the new contact person information to file
{
    bool DBFileDecide;
    bool DBFileSystemDecide;
    bool addToFileDecide;
    NSMutableString* path = [NSMutableString stringWithString:[self getDBFilePath]];
    NSLog(@"path is:%@", path);
    NSString* pathFile = [path stringByAppendingPathComponent:@"MyContacts.sqlite"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSLog(@"5");
    if (![fileManager fileExistsAtPath:pathFile])// check if file not exist
    {
        NSLog(@"***** file not exist and create new file *****");
        NSString* pathFile = [path stringByAppendingPathComponent:@"MyContacts.sqlite"];
        DBFileDecide = [self createOrOpenDataBaseFile:pathFile];
        if (DBFileDecide == true)
        {
            //successful
            NSLog(@"***** create or open the file ok *****");
            DBFileSystemDecide = [self createDBSystemToDBFile];
            if (DBFileSystemDecide == true)
            {
                //successful
                NSLog(@"***** create db table ok *****");
                addToFileDecide = [self InsertToRecord:ac];
                if (addToFileDecide == true)
                {
                    //successful
                    NSLog(@"***** add data to file ok *****");
                    return true;
                }
                else
                {
                    //fail
                    NSLog(@"***** fail to add data to file *****");
                    return false;
                }
            }
            else
            {
                //fail
                NSLog(@"***** fail create db table *****");
                return false;
            }
        }
        else
        {
            //fail
            NSLog(@"***** fail create or open file *****");
            return false;
        }
    }
    else
    {
        NSLog(@"***** file already exist, add to file now *****");
        DBFileDecide = [self createOrOpenDataBaseFile:pathFile];
        if (DBFileDecide == true)
        {
            //successful
            NSLog(@"***** create or open the file ok *****");
            addToFileDecide = [self InsertToRecord:ac];
            if (addToFileDecide == true)
            {
                //successful
                NSLog(@"***** add data to file ok *****");
                return true;
            }
            else
            {
                //fail
                NSLog(@"***** fail to add data to file *****");
                return false;
            }
            return true;
        }
        else
        {
            //fail
            NSLog(@"***** fail create or open file *****");
            return false;
        }
    }
}

//////////
- (void) deleteContact:(NSMutableArray*) dc //delete particular person contact information in file
{
    bool DBFileDecide;
    bool DBDeleteFile;
    NSMutableString* path = [NSMutableString stringWithString:[self getDBFilePath]];
    NSString* pathFile = [path stringByAppendingPathComponent:@"MyContacts.sqlite"];

    DBFileDecide = [self createOrOpenDataBaseFile:pathFile];
    if (DBFileDecide == true)
    {
        //successful
        NSLog(@"***** create or open the file ok *****");
        
        NSString* tempFirstName = [dc objectAtIndex:0];
        NSString* tempLastName = [dc objectAtIndex:1];
        
        DBDeleteFile = [self DeleteFirst:tempFirstName DeleteLast:tempLastName];
        if (DBDeleteFile == true)
        {
            NSLog(@"***** delete record ok *****");
        }
        else
        {
            NSLog(@"***** fail to delete record *****");
        }
    }
    else
    {
        NSLog(@"***** read file problem *****");
    }
}

//////////
- (NSMutableArray*) getContact: (NSString*) gc //read only particular person contact information
{
    NSLog(@"get one person contact information: %@", gc);
    NSArray *a = [gc componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];//split the string pass in by white space and store into array
    
    bool DBFileDecide;
    NSMutableString* path = [NSMutableString stringWithString:[self getDBFilePath]];
    NSString* pathFile = [path stringByAppendingPathComponent:@"MyContacts.sqlite"];
    NSMutableArray* myPersonalContact = [[NSMutableArray alloc]init];
    
    DBFileDecide = [self createOrOpenDataBaseFile:pathFile];
    if (DBFileDecide == true)
    {
        //successful
        NSLog(@"***** create or open the file ok *****");
        
        NSString* myLastName = [a objectAtIndex:1];
        NSString* myFirstName = [a objectAtIndex:0];
        
        NSString* sql;
        sql = [NSString stringWithFormat:@"SELECT FirstName, LastName, Phone, Email FROM Contacts WHERE LastName = '%@' AND FirstName = '%@'", myLastName, myFirstName];
        sqlite3_stmt* statement;
        
        if (sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            //loop thru all records return
            while (sqlite3_step(statement) == SQLITE_ROW)//for each row
            {
                char* field;
                
                //pick off cols
                field = (char*)sqlite3_column_text(statement, 0); //firstname
                NSString* fn = [[NSString alloc]initWithUTF8String:field];
                
                field = (char*)sqlite3_column_text(statement, 1); //lastname
                NSString* ln = [[NSString alloc]initWithUTF8String:field];
                
                field = (char*)sqlite3_column_text(statement, 2); //phone
                NSString* phone = [[NSString alloc]initWithUTF8String:field];
                
                field = (char*)sqlite3_column_text(statement, 3); //email
                NSString* email = [[NSString alloc]initWithUTF8String:field];
                
                [myPersonalContact addObject:ln];
                [myPersonalContact addObject:fn];
                [myPersonalContact addObject:email];
                [myPersonalContact addObject:phone];
                
                //NSLog(@"whole name is: %@", myPersonalContact);
            }
        }
        else
        {
            NSLog(@"***** get one person contact fail at prepare *****");
        }
    }
    else
    {
        NSLog(@"***** read file problem *****");
    }
    
    return myPersonalContact;// return the array contain one person all information
}

//////////
- (NSMutableArray*) getAllContact //read all contact names
{
    NSMutableArray* allContacts = [[NSMutableArray alloc]init];
    bool DBFileDecide;
    NSMutableString* path = [NSMutableString stringWithString:[self getDBFilePath]];
    NSString* pathFile = [path stringByAppendingPathComponent:@"MyContacts.sqlite"];
    NSFileManager* file = [NSFileManager defaultManager];
    
    if ([file fileExistsAtPath:pathFile])
    {
        NSLog(@"***** file exist in get all *****");
        DBFileDecide = [self createOrOpenDataBaseFile:pathFile];
        if (DBFileDecide == true)
        {
            //successful
            NSLog(@"***** create or open the file ok *****");
            
            NSString* sql;
            sql = [NSString stringWithFormat:@"SELECT FirstName, LastName FROM Contacts ORDER BY LastName, FirstName"];
            sqlite3_stmt* statement;
            
            if (sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                //loop thru all records return
                while (sqlite3_step(statement) == SQLITE_ROW)//for each row
                {
                    char* field;
                    
                    //pick off cols
                    field = (char*)sqlite3_column_text(statement, 0); //firstname
                    NSString* fn = [[NSString alloc]initWithUTF8String:field];
                    
                    field = (char*)sqlite3_column_text(statement, 1); //lastname
                    NSString* ln = [[NSString alloc]initWithUTF8String:field];
                    
                    NSString* wholeName = [[NSString alloc]initWithFormat:@"%@ %@", ln, fn];
                    [allContacts addObject:wholeName];
                    
                    //NSLog(@"whole name is: %@", wholeName);
                }
            }
            else
            {
                NSLog(@"***** get all contact fail at prepare *****");
            }
        }
        else
        {
            NSLog(@"***** read file problem *****");
        }
        
        //NSLog(@"allcontacts: %@", allContacts);
        NSLog(@"return all contacts");
        return allContacts;
    }
    else
    {
        NSLog(@"***** file not exist *****");
        return nil;
    }
}

//////////
- (void) updateContact:(NSMutableArray*) uc //update the contact information
{
    NSLog(@"updated contact infos: %@", uc);
    
    /*NSMutableArray* myNewDataArray = [[NSMutableArray alloc]init];
    
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
    [myNewDataArray writeToFile:filePath atomically:YES];//rewrite the changed dictionary array back to file*/
    
    bool DBFileDecide;
    bool DBUpdateFile;
    NSMutableString* path = [NSMutableString stringWithString:[self getDBFilePath]];
    NSString* pathFile = [path stringByAppendingPathComponent:@"MyContacts.sqlite"];
    
    DBFileDecide = [self createOrOpenDataBaseFile:pathFile];
    if (DBFileDecide == true)
    {
        //successful
        NSLog(@"***** create or open the file ok *****");
        
        NSString* testFirst = [uc objectAtIndex:1];//test first name
        NSString* testLast = [uc objectAtIndex:0];//test last name
        NSString* tempFirstName = [uc objectAtIndex:3];//new firstname
        NSString* tempLastName = [uc objectAtIndex:2];//new lastname
        NSString* tempPhone = [uc objectAtIndex:5];//new phone
        NSString* tempEmail = [uc objectAtIndex:4];//new email
        
        DBUpdateFile = [self UpdateFirst:tempFirstName UpdateLast:tempLastName UpdatePhone:tempPhone UpdateEmail:tempEmail myFirst:testFirst myLast:testLast];
        if (DBUpdateFile == true)
        {
            NSLog(@"***** update record ok *****");
        }
        else
        {
            NSLog(@"***** fail to update record *****");
        }
    }
    else
    {
        NSLog(@"***** read file problem *****");
    }
}

@end
