//
//  CheckingMethods.m
//  TipCalculator
//
//  Created by Hanxin Sun on 9/29/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "CheckingMethods.h"

@implementation CheckingMethods

#pragma mark - booleans
BOOL isNumeric(NSString *s)
{
    NSScanner *sc = [NSScanner scannerWithString: s];
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}

@end
