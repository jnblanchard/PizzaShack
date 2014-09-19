//
//  FoodOfTypeListViewController.h
//  PizzaShack
//
//  Created by John Blanchard on 9/14/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodOfTypeListViewController : UIViewController
@property NSMutableArray* foodList;
@property NSManagedObjectContext* managedObjectContext;
@end
