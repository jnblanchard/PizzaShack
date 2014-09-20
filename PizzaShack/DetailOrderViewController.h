//
//  DetailOrderViewController.h
//  PizzaShack
//
//  Created by John Blanchard on 9/14/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOrderViewController : UIViewController
@property NonParseFood* item;
@property NSManagedObjectContext* managedObjectContext;
@end
