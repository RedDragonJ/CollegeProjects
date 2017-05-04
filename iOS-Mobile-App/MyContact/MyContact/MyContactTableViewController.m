//
//  MyContactTableViewController.m
//  MyContact
//
//  Created by James H Layton on 5/3/17.
//  Copyright © 2017 james. All rights reserved.
//

#import "MyContactTableViewController.h"
#import "MyContactDetailViewController.h"

@interface MyContactTableViewController ()

@property (nonatomic, strong) UIView* coverView;

//Data
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) NSMutableDictionary* oneDictData;
@property (nonatomic, strong) NSMutableArray* names;
@property (nonatomic, strong) NSMutableArray* smallImages;
@property (nonatomic, strong) NSMutableArray* phones;

@end

@implementation MyContactTableViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"All Contact";
    
    self.data = [[NSMutableArray alloc]init];
    self.oneDictData = [[NSMutableDictionary alloc]init];
    self.names = [[NSMutableArray alloc]init];
    self.smallImages = [[NSMutableArray alloc]init];
    self.phones = [[NSMutableArray alloc]init];
    
    if (!self.names || !self.names.count)
    {
        self.coverView = [[UIView alloc]initWithFrame:self.view.frame];
        self.coverView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:self.coverView];
        [self.view bringSubviewToFront:self.coverView];
        [self ShowProgressSpinner];
    }
    [self performSelectorInBackground:@selector(doNetworkWrapper) withObject:nil];//call network connection and download data in background
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark receive data from background thread
- (void) didReceiveDataKey:(NSArray *)newArr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.data addObjectsFromArray:newArr];
        
        [self ParseForContacts:newArr]; //receive data from background and retrive data to display on view
    });
    
}

#pragma mark - Table Views
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.names != NULL)
    {
        return self.names.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TableViewCell"];
    }
    
    cell.textLabel.text = [self.names objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.phones objectAtIndex:indexPath.row];
    cell.imageView.image = [self.smallImages objectAtIndex:indexPath.row];
    cell.imageView.clipsToBounds = true;
    cell.imageView.layer.cornerRadius = 30;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.oneDictData addEntriesFromDictionary:[self.data objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"GoToDetails" sender:self];
}


#pragma mark - Parse
- (void) LoadImageDataToSave: (NSString*) imageString
{
    
    ///////
    //I seperate the image data process away from the loading of tableview so it may not slow down the UI process
    //////////
    UIImage* photo = [[UIImage alloc]init];
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
    photo = [UIImage imageWithData:imageData];
    if (photo != NULL)
    {
        [self.smallImages addObject:photo];
    }
    else
    {
        UIImage* noImage = [[UIImage alloc]init];
        noImage = [UIImage imageNamed:@"noimage"];
        [self.smallImages addObject:noImage];
    }
}

- (void) ParseForContacts: (NSArray*) myArr
{
    //Parse Name, home phone, and small image
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    NSString* name = [[NSString alloc]init];
    NSString* smallImage = [[NSString alloc]init];
    NSDictionary* phoneDict = [[NSDictionary alloc]init];
    NSString* phone = [[NSString alloc]init];
    
    for (int i=0; i<myArr.count; i++)
    {
        dict = myArr[i];
        
        name = [dict objectForKey:@"name"];
        [self.names addObject:name];
        
        smallImage = [dict objectForKey:@"smallImageURL"];
        [self LoadImageDataToSave:smallImage];
        
        phoneDict = [dict objectForKey:@"phone"];
        if (phone != NULL)
        {
            phone = [phoneDict objectForKey:@"home"];
            [self.phones addObject:phone];
        }
    }
    
    [self.tableview reloadData];
    [self CheckTableViewData];
}

#pragma mark network wrapper
- (void) doNetworkWrapper
{
    ConnectionHandler* chhandler;
    chhandler = [[ConnectionHandler alloc]init];
    chhandler.ch = self;
    //send control to background process main loop pause
    
    //call networking connection method
    [chhandler netWorkConnection];
}

#pragma mark - Helper
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToDetails"])
    {
        MyContactDetailViewController* mdvc = [segue destinationViewController];
        mdvc.detailsInfoDict = self.oneDictData;
    }
}

- (void) CheckTableViewData
{
    if (self.names)
    {
        [self HideProgressSpinner];
        [UIView animateWithDuration:1.0 animations:^{
            self.coverView.alpha = 0;
        }];
    }
}


@end
