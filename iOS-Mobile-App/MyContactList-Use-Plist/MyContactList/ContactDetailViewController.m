//
//  ContactDetailViewController.m
//  MyContactList
//
//  Created by Hanxin Sun on 10/24/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "StorageContact.h"
#import "Contact.h"
#import "ViewController.h"

@interface ContactDetailViewController ()

@property (nonatomic, weak) IBOutlet UITextField* lastNameText;
@property (nonatomic, weak) IBOutlet UITextField* firstNameText;
@property (nonatomic, weak) IBOutlet UITextField* emailText;
@property (nonatomic, weak) IBOutlet UITextField* phoneText;

@property (nonatomic, strong) ViewController* views;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"viewcontroller 2 - details");
    if (self.myNameInView2 != nil) //check if cell name tapped and send to this viewcontroller
    {
        //!!!TEST!!!// NSLog(@"display my personal infos into textfield");
        [self getPersonalInfos:self.myNameInView2];//call method to display personal information
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark dismiss keybroad when touch other places
//method to dismiss keybroad if user touch some else and not editing
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark edit and delete stuffs
- (void) getPersonalInfos:(NSString *)person
{
    NSArray* tempPerson = [person componentsSeparatedByString:@", "];
    NSString* newPerson = [[NSString alloc]initWithFormat:@"%@ %@", [tempPerson objectAtIndex:1], [tempPerson objectAtIndex:0]];
    NSMutableArray* myPerson = [[StorageContact sharedInstance]getContact:newPerson];//call method to get all personal infos
    
    //display all personal infos into textfield
    self.lastNameText.text = [myPerson objectAtIndex:0];
    self.firstNameText.text = [myPerson objectAtIndex:1];
    self.emailText.text = [myPerson objectAtIndex:2];
    self.phoneText.text = [myPerson objectAtIndex:3];
}

#pragma mark check my input values
- (BOOL) checkWhiteSpaceAndCharacter: (Contact*) checkContact
{
    //if user not entered all text field
    if ([checkContact.myLastName isEqualToString:@""] || [checkContact.myFirstName isEqualToString:@""] || [checkContact.myEmails isEqualToString:@""] || [checkContact.myPhones isEqualToString:@""])
    {
        //alert user to write to text field in order to save
        UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"All text fields are required!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                   {
                                       [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alertScreen addAction:okButton];
        [self presentViewController:alertScreen animated:YES completion:nil];
        return false;
    }
    else //if user entered all textfield
    {
        NSRange whiteSpaceAtLastName = [checkContact.myLastName rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        NSRange whiteSpaceAtFirstName = [checkContact.myFirstName rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        NSRange whiteSpaceAtEmail = [checkContact.myEmails rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        NSRange whiteSpaceAtPhone = [checkContact.myPhones rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (whiteSpaceAtLastName.location != NSNotFound || whiteSpaceAtFirstName.location != NSNotFound || whiteSpaceAtEmail.location != NSNotFound || whiteSpaceAtPhone.location != NSNotFound)//found white space
        {
            
            //alert user to no white space allowed at each text field
            UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Please no white space at text field!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                       {
                                           [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                       }];
            
            [alertScreen addAction:okButton];
            [self presentViewController:alertScreen animated:YES completion:nil];
            return false;
        }
        else //not found white space
        {
            NSLog(@"check for invalid char");
            NSCharacterSet* numberAndMyCharOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789()-"];
            for (NSUInteger i=0; i<[checkContact.myPhones length]; i++)//loop my phone characters
            {
                unichar characters = [checkContact.myPhones characterAtIndex:i];
                if (![numberAndMyCharOnly characterIsMember:characters])//myphone character not exist in character set
                {
                    //alert user invalid character used
                    UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Invalid characters in phone field!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                               {
                                                   [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                               }];
                    
                    [alertScreen addAction:okButton];
                    [self presentViewController:alertScreen animated:YES completion:nil];
                    return false;
                }
            }
            return true;
        }
    }
}

#pragma mark button actions
- (IBAction)saveEditButtonTapped:(id)sender
{
    NSLog(@"Save button tapped!");
    //take user typed or empty textfield into contact object which contain 4 fields
    Contact* mycontact = [[Contact alloc]init];
    mycontact.myLastName = self.lastNameText.text;
    mycontact.myFirstName = self.firstNameText.text;
    mycontact.myEmails = self.emailText.text;
    mycontact.myPhones = self.phoneText.text;
    
    if (self.myNameInView2 == nil)//if user tapped add sign
    {
        NSLog(@"add contact");
        
        ////test only
        //[[StorageContact sharedInstance]addContact:mycontact];
        /////////
        
        BOOL addResult = [self checkWhiteSpaceAndCharacter:mycontact];//check whatever user entered
        if (addResult == true)//user enter fits all the requirements
        {
            NSLog(@"add ok");
            [[StorageContact sharedInstance]addContact:mycontact];// call addcontact method to add information to file
        }
        else
        {
            NSLog(@"user entered doesn't fits all the requirements");
        }
    }
    else//user tapped cell on tableview
    {
        NSLog(@"edit contact");
        
        BOOL editResult = [self checkWhiteSpaceAndCharacter:mycontact];//check whatever user edited
        if (editResult == true)
        {
            NSLog(@"edit ok");
            NSMutableArray* updateMyContact = [[NSMutableArray alloc]init];
            NSArray* tempPerson = [self.myNameInView2 componentsSeparatedByString:@", "];//split the user full name into array of firstname and lastname
            [updateMyContact addObject:[tempPerson objectAtIndex:0]];//add last name to array
            [updateMyContact addObject:[tempPerson objectAtIndex:1]];//add first name to array
            [updateMyContact addObject:mycontact.myLastName];//add edited lastname
            [updateMyContact addObject:mycontact.myFirstName];//add edited firstname
            [updateMyContact addObject:mycontact.myEmails];//add edited email
            [updateMyContact addObject:mycontact.myPhones];//add edit phone number
            [[StorageContact sharedInstance]updateContact:updateMyContact];//call update method and pass the array into it
        }
        else
        {
            NSLog(@"user edited doesn't fits all the requirements");
        }
    }
    NSMutableArray* myAllContacts = [[StorageContact sharedInstance]getAllContact];//call method to get all contact names
    [self.cdfDelegate didReceiveInformations:myAllContacts];//send back the all contact names to first viewcontroller
    [self.navigationController popViewControllerAnimated:YES];//dismiss this controller and go back to where push from
}

- (IBAction)deleteButtonTapped:(id)sender
{
    NSLog(@"delete button tapped!");
    
    if (self.myNameInView2 != nil)//user tapped cell on tableview
    {
        NSMutableArray* deleteMyContact = [[NSMutableArray alloc]init];
        NSArray* tempPerson = [self.myNameInView2 componentsSeparatedByString:@", "];
        [deleteMyContact addObject:[tempPerson objectAtIndex:1]];
        [deleteMyContact addObject:[tempPerson objectAtIndex:0]];
        
        //alert user if want to delete contact
        UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"WAIT" message:@"Are you sure you want to delete this?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
                                   {
                                       [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                   }];// cancel delete button
        
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                       {
                                           NSLog(@"deleted");
                                           [[StorageContact sharedInstance]deleteContact:deleteMyContact];
                                           [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                           NSMutableArray* myAllContacts = [[StorageContact sharedInstance]getAllContact];
                                           [self.cdfDelegate didReceiveInformations:myAllContacts];
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];// yes delete button
        [alertScreen addAction:okButton];
        [alertScreen addAction:cancelButton];
        [self presentViewController:alertScreen animated:YES completion:nil];
    }
    else// user tapped on add sign
    {
        //!!!TEST!!!// NSLog(@"Nothing to delete");
        
        //alert user delete button not work while adding
        UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"You can't delete add!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                   {
                                       [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alertScreen addAction:okButton];
        [self presentViewController:alertScreen animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
