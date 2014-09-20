//
//  Location.h
//  PizzaShack
//
//  Created by John Blanchard on 9/19/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * addressDetail;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSString * phone;

@end
