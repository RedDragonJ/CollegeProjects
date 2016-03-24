//
//  ViewController.m
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ViewController.h"
#import "StorageContact.h"
#import "ContactDetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString* myName;

@property (nonatomic, strong) NSMutableDictionary* dictAlphabet;
@property (nonatomic, strong) NSArray* dictAlphabetSectionTitles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"viewcontroller 1 - tableview");
    
    self.contactNames = [[StorageContact sharedInstance]getAllContact]; //read all contact names from file
    if (self.contactNames == nil)// check if array of contact is null
    {
        self.contactNames = [[NSMutableArray alloc]init];// just init a new array or do something
    }
    else // if contact array have data
    {
        [self sortMyArray:self.contactNames];// sort the array into dictionary contain array with same first letter
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark display alphabetically
- (void) sortMyArray: (NSArray*) sma
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    NSDictionary* myDict;
    for (NSString* obj in sma)
    {
        NSString* tempName = [sma objectAtIndex:[sma indexOfObject:obj]];//get object at surrent index
        NSArray* tempNameArray = [tempName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        //splite the string into array by white space
        
        myDict = [NSDictionary dictionaryWithObjectsAndKeys:[tempNameArray objectAtIndex:0], @"lastname", [tempNameArray objectAtIndex:1], @"firstname", nil];//insert splitstring array into dictionary
        [array addObject:myDict];
        //add the dictionary to new array ready for sort
    }
    
    //////////
    //create descriptor for array sorting
    NSSortDescriptor* lastDescriptor = [[NSSortDescriptor alloc]initWithKey:@"lastname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* firstDescriptor = [[NSSortDescriptor alloc]initWithKey:@"firstname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    /////////
    
    
    NSArray* descriptorArray = [NSArray arrayWithObjects:lastDescriptor, firstDescriptor, nil];//sort the array with those descriptor
    NSArray* sortedArray = [array sortedArrayUsingDescriptors:descriptorArray];//sorted dictionary array
    //!!!TEST!!!//NSLog(@"sorted dictionary array is: %@", sortedArray);
    
    
    //take out sorted value into a new array
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary* dict in sortedArray)
    {
        NSString* tempname = [dict objectForKey:@"lastname"];
        tempname = [tempname stringByAppendingFormat:@", %@", [dict objectForKey:@"firstname"]];
        [tempArray addObject:tempname];
    }
    //!!!TEST!!!// NSLog(@"sorted array is: %@", tempArray);
    
    
    NSArray* myNewSortedArray = [NSArray arrayWithArray:tempArray];//new sorted array of contacts
    //NSLog(@"nsarray: %@", myNewSortedArray);
    ///////////////////
    
    
    ////////////
    //write the sorted array into a dictionary where rearrange array object by there first letter
    self.dictAlphabet = [NSMutableDictionary dictionary];
    NSCharacterSet* letterCharacters = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    NSCharacterSet* notLetters = [letterCharacters invertedSet];
    for (NSString* value in myNewSortedArray)
    {
        NSString* firstLetter = [value substringWithRange:NSMakeRange(0, 1)];
        NSString* myUpperCaseFirstLetter = [firstLetter uppercaseString];
        NSRange badCharacters = [firstLetter rangeOfCharacterFromSet:notLetters];
        
        if (badCharacters.location != NSNotFound)
        {
            //!!!TEST!!!// NSLog(@"non alpabetic character");
            NSMutableArray* arrayForNonLetter = [self.dictAlphabet objectForKey:@"#"];
            if (arrayForNonLetter == nil)
            {
                arrayForNonLetter = [NSMutableArray array];
                [self.dictAlphabet setObject:arrayForNonLetter forKey:@"#"];
            }
            [arrayForNonLetter addObject:value];
        }
        else
        {
            //!!!TEST!!!// NSLog(@"english letter character");
            NSMutableArray* arrayForLetter = [self.dictAlphabet objectForKey:myUpperCaseFirstLetter];
            if (arrayForLetter == nil)
            {
                arrayForLetter = [NSMutableArray array];
                [self.dictAlphabet setObject:arrayForLetter forKey:myUpperCaseFirstLetter];
            }
            [arrayForLetter addObject:value];
        }
    }
    //!!!TEST!!!// NSLog(@"dictionary: %@", self.dictAlphabet);
    
    //put exist first letter into new array
    self.dictAlphabetSectionTitles = [[self.dictAlphabet allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //NSLog(@"titles: %@", self.dictAlphabetSectionTitles);
    ////////////
}

#pragma mark receive data from delegate
- (void)didReceiveInformations:(NSMutableArray *)userInfos
{
    [self.contactNames removeAllObjects];
    [self.contactNames addObjectsFromArray:userInfos];
    NSArray* tempArray = [NSArray arrayWithArray:self.contactNames];
    [self sortMyArray:tempArray];
    [self.myNewTableView reloadData];
}

#pragma mark letter scroller

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.dictAlphabetSectionTitles;
}

#pragma mark table view stuffs
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dictAlphabetSectionTitles count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dictAlphabetSectionTitles objectAtIndex:section];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* sectionTitle = [self.dictAlphabetSectionTitles objectAtIndex:section];
    NSArray* sectionDict = [self.dictAlphabet objectForKey:sectionTitle];
    return [sectionDict count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* tableIdentifier = @"mystyle";
    UITableViewCell* cells = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cells == nil)
    {
        cells = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    NSString* sectionTitle = [self.dictAlphabetSectionTitles objectAtIndex:indexPath.section];
    NSArray* sectionDict = [self.dictAlphabet objectForKey:sectionTitle];
    NSString* dict = [sectionDict objectAtIndex:indexPath.row];
    
    cells.textLabel.text = dict;
    
    return cells;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"did select: %@", [self.contactNames objectAtIndex:indexPath.row]);
    
    NSString* sectionTitle = [self.dictAlphabetSectionTitles objectAtIndex:indexPath.section];
    NSArray* sectionDict = [self.dictAlphabet objectForKey:sectionTitle];
    NSString* dict = [sectionDict objectAtIndex:indexPath.row];
    
    self.myName = dict;
    
    NSLog(@"myName: %@", self.myName);
    
    //self.myName = [self.contactNames objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailView" sender:self];
}

#pragma mark send segue to delegate
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ContactDetailViewController* cdvc;
    cdvc = segue.destinationViewController;
    cdvc.cdfDelegate = self;
    
    if ([segue.identifier isEqualToString:@"detailView"])
    {
        ContactDetailViewController* cdvc = (ContactDetailViewController*) [segue destinationViewController];
        cdvc.myNameInView2 = self.myName;
    }
}

@end
