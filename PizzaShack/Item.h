//
//  Item.h
//  PizzaShack
//
//  Created by John Blanchard on 9/18/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * dressing;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * request;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * isCurOrder;
@property (nonatomic, retain) NSString * addItem;
@property (nonatomic, retain) Order *order;

@end
