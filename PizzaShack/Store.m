//
//  Store.m
//  PizzaShack
//
//  Created by John Blanchard on 9/15/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "Store.h"

@implementation Store
@dynamic name;
@dynamic phone;
@dynamic location;
@dynamic address;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Stores";
}
@end
