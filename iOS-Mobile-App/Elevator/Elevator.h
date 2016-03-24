//
//  Elevator.h
//  Elevator
//
//  Created by Hanxin Sun on 9/14/15.
//  Copyright (c) 2015 james. All rights reserved.
//

#import <Foundation/Foundation.h>

/*@interface Elevator : NSObject
{
    //ivars
    int floor;
    int maxFloors;
    int maxWeight;
    NSString* elevatorColor;
    NSString* lastInspectionDate;
    NSString* lastInpsector;
    NSString* song;
    NSString* elevatorName;
    NSString* elevatorBrand;
}

//method prototypes
-(id)initWithName:(NSString*)n;

-(int)getFloor;
-(int)getMaxFloors;
-(int)getMaxWeight;

-(NSString*)getElevatorName;
-(void)setElevatorName: (NSString*) en;
-(void)setMaxFloors: (int)f;
-(NSString*)getElevatorColor;
-(void)setElevatorColor: (NSString*)color;
-(NSString*)getLastInspectionDate;
-(void)setLastInspectionDate: (NSString*)d;
-(NSString*)getLastInpsector;
-(void)setLastInpsector: (NSString*)insp;
-(NSString*)getSong;
-(void)setSong: (NSString*)s;
-(void)setMaxWeight: (int)mw;
-(NSString*)getElevatorBrand;
-(void)setElevatorBrand: (NSString*)s;
-(void)moveElevator: (int) toFloor;
-(void)Log;
@end*/

@interface Elevator : NSObject
{
    @private
    int floor;
}

@property(nonatomic, strong)NSString* elevatorName;
@property(nonatomic, assign)int maxFloors;
@property(nonatomic, strong)NSString* elevatorColor;
@property(nonatomic, strong)NSString* lastInspectionDate;
@property(nonatomic, strong)NSString* lastInpsector;
@property(nonatomic, strong)NSString* song;
@property(nonatomic, assign)int maxWeight;
@property(nonatomic, strong)NSString* elevatorBrand;


-(id)initWithName:(NSString*)n;
-(int)getFloor;
-(void)moveElevator: (int) toFloor;
-(void)Log;

@end
