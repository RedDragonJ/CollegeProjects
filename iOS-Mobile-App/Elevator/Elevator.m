//
//  Elevator.m
//  Elevator
//
//  Created by Hanxin Sun on 9/14/15.
//  Copyright (c) 2015 james. All rights reserved.
//

#import "Elevator.h"

@interface Elevator()
{
    
}


@end

@implementation Elevator

-(id)initWithName:(NSString*) n
{
    self = [super init];
    if (self)
    {
        _elevatorName = [[NSString alloc]initWithString:n];
        floor = 1;
    }
    return self;
}
-(int)getFloor
{
    return floor;
}
/*-(int)getMaxFloors
{
    return maxFloors;
}
-(int)getMaxWeight
{
    return maxWeight;
}
-(NSString*)getElevatorName
{
    return elevatorName;
}
-(void)setElevatorName: (NSString*) en
{
    elevatorName = [[NSString alloc]initWithString:en];
}
-(void)setMaxFloors: (int)f
{
    maxFloors = f;
}
-(NSString*)getElevatorColor
{
    return elevatorColor;
}
-(void)setElevatorColor: (NSString*)color
{
    elevatorColor = [[NSString alloc]initWithString:color];
}
-(NSString*)getLastInspectionDate
{
    return lastInspectionDate;
}
-(void)setLastInspectionDate: (NSString*)d
{
    lastInspectionDate = [[NSString alloc]initWithString:d];
}
-(NSString*)getLastInpsector
{
    return lastInpsector;
}
-(void)setLastInpsector: (NSString*)insp
{
    lastInpsector = [[NSString alloc]initWithString:insp];
}
-(NSString*)getSong
{
    return song;
}
-(void)setSong: (NSString*)s
{
    song = [[NSString alloc]initWithString:s];
}
-(void)setMaxWeight: (int)mw
{
    maxWeight = mw;
}
-(NSString*)getElevatorBrand
{
    return elevatorBrand;
}
-(void)setElevatorBrand: (NSString*)s
{
    elevatorBrand = [[NSString alloc]initWithString:s];
}
*/
-(void)moveElevator: (int) toFloor
{
    if (floor == toFloor)//on same floor
    {
        NSLog(@"You already on floor %i on %@", floor, _elevatorName);
    }
    else if (floor > toFloor)//go down
    {
        NSLog(@"%@ going down to floor %i", _elevatorName, toFloor);
        for (int j=floor; floor>toFloor; j--)
        {
            NSLog(@"%@ on floor %i", _elevatorName, j);
            floor = j;
        }
    }
    else if (toFloor > _maxFloors)//over max floor
    {
        NSLog(@"%@ cannot go to floor %i", _elevatorName, toFloor);
    }
    else { //go up
        NSLog(@"%@ going up to floor %i", _elevatorName, toFloor);
        for (int i=floor; i<=toFloor; i++)
        {
            NSLog(@"%@ on floor %i", _elevatorName, i);
            floor = i;
        }
    }
}
-(void)Log
{
    NSLog(@"Name: %@", _elevatorName);
    NSLog(@"Floor: %i", floor);
    NSLog(@"Max floor: %i", _maxFloors);
    NSLog(@"Elevator color: %@", _elevatorColor);
    NSLog(@"Last inspection date: %@", _lastInspectionDate);
    NSLog(@"Last inspector: %@", _lastInpsector);
    NSLog(@"Song: %@", _song);
    NSLog(@"Max weight: %i", _maxWeight);
    NSLog(@"Elevator brand: %@", _elevatorBrand);
    NSLog(@"------------------------------");
}


@end
