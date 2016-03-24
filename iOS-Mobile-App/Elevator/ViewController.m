//
//  ViewController.m
//  Elevator
//
//  Created by Hanxin Sun on 9/14/15.
//  Copyright (c) 2015 james. All rights reserved.
//

#import "ViewController.h"
#import "Elevator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Elevator* e1 = [[Elevator alloc]initWithName:@"Elevator 1"];
    
    [e1 setElevatorColor:@"blue"];
    
    [e1 setMaxWeight:500];
    
    [e1 setLastInpsector:@"Bob"];
    
    [e1 setSong:@"Girl From Ipanema"];
    
    [e1 setElevatorBrand:@"ACME"];
    
    [e1 setLastInspectionDate:@"7/12/2013"];
    
    [e1 setMaxFloors:20];
    
    Elevator* e2 = [[Elevator alloc]initWithName:@"Elevator 2"];
    
    [e2 setElevatorColor:@"Red"];
    
    [e2 setMaxWeight:500];
    
    [e2 setLastInpsector:@"Ricky"];
    
    [e2 setSong:@"Don't Tell Ashley"];
    
    [e2 setElevatorBrand:@"Fender"];
    
    [e2 setLastInspectionDate:@"4/5/2013"];
    
    [e2 setMaxFloors:8];
    
    
    
    [e1 Log];
    
    [e2 Log];
    
    [e1 moveElevator:5];
    
    [e1 moveElevator:5];
    
    [e2 moveElevator:5];
    
    [e1 moveElevator:3];
    
    [e2 moveElevator:2];
    
    [e1 moveElevator:25];
    
    [e2 moveElevator:2];
    
    [e1 moveElevator:18];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
