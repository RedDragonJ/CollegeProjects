//
//  ViewController.m
//  TipCalculator
//
//  Created by Hanxin Sun on 9/28/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ViewController.h"
#import "CheckingMethods.h"

@interface ViewController ()

//IBOutlets
@property (nonatomic, weak) IBOutlet UITextField* dinnerBillTextField;
@property (nonatomic, weak) IBOutlet UITextField* totalBillTextField;
@property (nonatomic, weak) IBOutlet UILabel* tipDisplay;

//IBActions
-(IBAction)tenPercentTouched:(id)sender;
-(IBAction)fifteenPercentTouched:(id)sender;
-(IBAction)twentyPercentTouched:(id)sender;

@end

@implementation ViewController

#pragma mark - methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dinnerBillTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(IBAction)tenPercentTouched:(id)sender //10% touch button
{
    //NSLog(@"10 TOUCHED!");
    NSString* inputPrice, *outputTotal, *displayTips;
    
    inputPrice = self.dinnerBillTextField.text;
    
    if (isNumeric(inputPrice) == NO)//check if input are numerics, if not send out alert
    {
        //NSLog(@"WRONG INPUT!");
        UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Error with inpiut." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
            {
                    [alertScreen dismissViewControllerAnimated:YES completion:nil];
            }];
        
        [alertScreen addAction:okButton];
        [self presentViewController:alertScreen animated:YES completion:nil];
    }
    else //do the tips math
    {
        NSDecimalNumber* tipRate = [NSDecimalNumber decimalNumberWithString:@"0.1"];
        NSDecimalNumber* dinnerPrice = [NSDecimalNumber decimalNumberWithString:inputPrice];
        //NSLog(@"the number is %@", dinnerPrice);
        NSDecimalNumber* tipMoney = [tipRate decimalNumberByMultiplyingBy:dinnerPrice];
        NSDecimalNumber* totalPrice = [tipMoney decimalNumberByAdding:dinnerPrice];
        
        //rounding the total price
        NSDecimalNumberHandler* behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber* roundedPrice = [totalPrice decimalNumberByRoundingAccordingToBehavior:behavior];
        
        //NSDecimalFormater
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc]init];
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString* totalAmount_1 = [numberFormatter stringFromNumber:roundedPrice];
        NSString* tipAmount_1 = [numberFormatter stringFromNumber:tipMoney];
        
        //display the total price
        displayTips = [NSString stringWithFormat:@"Tips: $%@", tipAmount_1];
        self.tipDisplay.text = displayTips;
        outputTotal = [NSString stringWithFormat:@"$%@", totalAmount_1];
        self.totalBillTextField.text = outputTotal;
    }
}

-(IBAction)fifteenPercentTouched:(id)sender//15% touch button
{
    //NSLog(@"15 TOUCHED!");
    NSString* inputPrice, *outputTotal, *displayTips;
    
    inputPrice = self.dinnerBillTextField.text;
    
    if (isNumeric(inputPrice) == NO)//check if input are numerics, if not send out alert
    {
        //NSLog(@"WRONG INPUT!");
        UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Error with inpiut." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                   {
                                       [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alertScreen addAction:okButton];
        [self presentViewController:alertScreen animated:YES completion:nil];
    }
    else //do the tips math
    {
        NSDecimalNumber* tipRate = [NSDecimalNumber decimalNumberWithString:@"0.15"];
        NSDecimalNumber* dinnerPrice = [NSDecimalNumber decimalNumberWithString:inputPrice];
        //NSLog(@"the number is %@", dinnerPrice);
        NSDecimalNumber* tipMoney = [tipRate decimalNumberByMultiplyingBy:dinnerPrice];
        NSDecimalNumber* totalPrice = [tipMoney decimalNumberByAdding:dinnerPrice];
        
        //rounding the total price
        NSDecimalNumberHandler* behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber* roundedPrice = [totalPrice decimalNumberByRoundingAccordingToBehavior:behavior];
        
        //NSDecimalFormater
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc]init];
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString* totalAmount_2 = [numberFormatter stringFromNumber:roundedPrice];
        NSString* tipAmount_2 = [numberFormatter stringFromNumber:tipMoney];
        
        //display the total price
        displayTips = [NSString stringWithFormat:@"Tips: $%@", tipAmount_2];
        self.tipDisplay.text = displayTips;
        outputTotal = [NSString stringWithFormat:@"$%@", totalAmount_2];
        self.totalBillTextField.text = outputTotal;
    }
}

-(IBAction)twentyPercentTouched:(id)sender//20% touch button
{
    //NSLog(@"20 TOUCHED!");
    NSString* inputPrice, *outputTotal, *displayTips;
    
    inputPrice = self.dinnerBillTextField.text;
    
    if (isNumeric(inputPrice) == NO)//check if input are numerics, if not send out alert
    {
        //NSLog(@"WRONG INPUT!");
        UIAlertController* alertScreen = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Error with inpiut." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                                   {
                                       [alertScreen dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alertScreen addAction:okButton];
        [self presentViewController:alertScreen animated:YES completion:nil];
    }
    else //do the tips math
    {
        NSDecimalNumber* tipRate = [NSDecimalNumber decimalNumberWithString:@"0.20"];
        NSDecimalNumber* dinnerPrice = [NSDecimalNumber decimalNumberWithString:inputPrice];
        //NSLog(@"the number is %@", dinnerPrice);
        NSDecimalNumber* tipMoney = [tipRate decimalNumberByMultiplyingBy:dinnerPrice];
        NSDecimalNumber* totalPrice = [tipMoney decimalNumberByAdding:dinnerPrice];
        
        //rounding the total price
        NSDecimalNumberHandler* behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber* roundedPrice = [totalPrice decimalNumberByRoundingAccordingToBehavior:behavior];
        
        //NSDecimalFormater
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc]init];
        [numberFormatter setMinimumFractionDigits:2];
        [numberFormatter setMaximumFractionDigits:2];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString* totalAmount_3 = [numberFormatter stringFromNumber:roundedPrice];
        NSString* tipAmount_3 = [numberFormatter stringFromNumber:tipMoney];
        
        //display the total price
        displayTips = [NSString stringWithFormat:@"Tips: $%@", tipAmount_3];
        self.tipDisplay.text = displayTips;
        outputTotal = [NSString stringWithFormat:@"$%@", totalAmount_3];
        self.totalBillTextField.text = outputTotal;
    }
}




@end
