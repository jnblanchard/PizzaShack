//
//  FavoriteStore.h
//  PizzaShack
//
//  Created by John Blanchard on 9/17/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FavoriteStore : NSManagedObject

@property (nonatomic, retain) NSString * name;

@end
