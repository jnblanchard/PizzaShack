//
//  NonParseFood.m
//  PizzaShack
//
//  Created by John Blanchard on 9/20/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "NonParseFood.h"

@implementation NonParseFood

-(instancetype) initWithString:(NSString*)name withPrice:(NSNumber*) price withSegmentedControl:(NSArray *) segmentedControl withPriceControl:(NSArray*)priceControl withAddItem:(NSString*)addItem withaddItemPrice:(NSNumber*)addItemPrice withDetail:(NSString*)detail withImage:(UIImage*)photo
{
    self = [super init];
    if (self) {
        self.name = name;
        self.price = price;
        self.segmentedControl = segmentedControl;
        self.priceControl = priceControl;
        self.addItem = addItem;
        self.addItemPrice = addItemPrice;
        self.detail = detail;
        self.photo = photo;
    }
    return self;
}
@end
