//
//  NonParseStore.m
//  PizzaShack
//
//  Created by John Blanchard on 9/19/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "NonParseStore.h"

@implementation NonParseStore

-(instancetype)initWithString:(NSString*)name withLocation:(CLLocation*)location withPhone:(NSString*)phone withAddress:(NSString*)address
{
    self = [super init];
    if (self) {
        self.name = name;
        self.location = location;
        self.phone = phone;
        self.address = address;
    }
    return self;
}
@end
