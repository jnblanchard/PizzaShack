//
//  CheckoutViewController.h
//  PizzaShack
//
//  Created by John Blanchard on 9/18/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface CheckoutViewController : UIViewController
@property NSManagedObjectContext* managedObjectContext;
@property NSMutableArray* items;
@property Location* aLocation;
@property (weak, nonatomic) IBOutlet UILabel *streetAddress;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property NonParseStore* store;
@end
