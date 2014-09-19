//
//  CartTableViewCell.h
//  PizzaShack
//
//  Created by John Blanchard on 9/17/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subTotal;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
