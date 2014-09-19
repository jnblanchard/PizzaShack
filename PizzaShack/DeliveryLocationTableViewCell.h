//
//  DeliveryLocationTableViewCell.h
//  PizzaShack
//
//  Created by John Blanchard on 9/16/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryLocationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end
