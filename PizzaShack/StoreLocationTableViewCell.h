//
//  StoreLocationTableViewCell.h
//  PizzaShack
//
//  Created by John Blanchard on 9/15/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreLocationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeDistance;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;

@end
