//
//  SoupSalad.h
//  PizzaShack
//
//  Created by John Blanchard on 9/14/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Parse/Parse.h>

@interface SoupSalad : PFObject <PFSubclassing>
@property NSString* name;
@property NSNumber* price;
@end
