//
//  NonParseFood.h
//  PizzaShack
//
//  Created by John Blanchard on 9/20/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NonParseFood : NSObject
@property NSString* name;
@property NSNumber* price;
@property UIImage* photo;
@property NSArray* segmentedControl;
@property NSArray* priceControl;
@property NSString* addItem;
@property NSNumber* addItemPrice;
@property NSString* detail;
-(instancetype) initWithString:(NSString*)name withPrice:(NSNumber*) price withSegmentedControl:(NSArray *) segmentedControl withPriceControl:(NSArray*)priceControl withAddItem:(NSString*)addItem withaddItemPrice:(NSNumber*)addItemPrice withDetail:(NSString*)detail withImage:(UIImage*)photo;
@end
