//
//  CardTableViewCell.h
//  PizzaShack
//
//  Created by John Blanchard on 9/15/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end
