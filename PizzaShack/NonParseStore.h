//
//  NonParseStore.h
//  PizzaShack
//
//  Created by John Blanchard on 9/19/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NonParseStore : NSObject
@property NSString* name;
@property CLLocation* location;
@property NSString* phone;
@property NSString* address;

-(instancetype)initWithString:(NSString*)name withLocation:(CLLocation*)location withPhone:(NSString*)phone withAddress:(NSString*)address;

@end
