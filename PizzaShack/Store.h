//
//  Store.h
//  PizzaShack
//
//  Created by John Blanchard on 9/15/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Parse/Parse.h>

@interface Store : PFObject <PFSubclassing>
@property NSString* name;
@property PFGeoPoint* location;
@property NSString* phone;
@property NSString* address;
@end
