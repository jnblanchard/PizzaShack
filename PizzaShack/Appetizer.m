//
//  Appetizers.m
//  PizzaShack
//
//  Created by John Blanchard on 9/14/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "Appetizer.h"

@implementation Appetizer
@dynamic name;
@dynamic price;

+ (void)load {
    [self registerSubclass];
}



+ (NSString *)parseClassName {
    return @"Appetizers";
}
@end
