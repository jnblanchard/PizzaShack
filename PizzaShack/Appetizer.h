//
//  Appetizers.h
//  PizzaShack
//
//  Created by John Blanchard on 9/14/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Parse/Parse.h>

@interface Appetizer : PFObject <PFSubclassing>
@property NSString* name;
@property NSNumber* price;
@end
