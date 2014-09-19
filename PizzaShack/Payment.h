//
//  Payment.h
//  PizzaShack
//
//  Created by John Blanchard on 9/16/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Payment : NSManagedObject

@property (nonatomic, retain) NSString * holder;
@property (nonatomic, retain) NSString * cardNumber;
@property (nonatomic, retain) NSDate * expDate;
@property (nonatomic, retain) NSNumber * favorite;

@end
