//
//  CartViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/17/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "MenuViewController.h"
#import "FoodOfTypeListViewController.h"
#import "DetailOrderViewController.h"
#import "CheckoutViewController.h"
#import "WalletViewController.h"
#import "Item.h"

@interface CartViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSNumber* total;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property NSMutableArray* items;
@property int selectedRowIndex;
@property int lastSelectedRowIndex;
@property BOOL willSegue;
@end

@implementation CartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = [NSMutableArray new];
    self.lastSelectedRowIndex = 3210123;
    self.view.backgroundColor = DARKBAYCOLOR;
    self.tableView.backgroundColor = DARKBAYCOLOR;
    self.tableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tableView.layer.borderWidth = 2.0f;
    self.checkoutButton.clipsToBounds = YES;
    self.checkoutButton.layer.cornerRadius = 10;
    self.checkoutButton.backgroundColor = REDCOLOR;
    self.checkoutButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.checkoutButton.layer.borderWidth = 2.0f;
    self.willSegue = NO;
    self.selectedRowIndex = 500;
    [self grabCurrentOrder];
}

- (void) viewDidAppear:(BOOL)animated
{
    self.willSegue = NO;
    self.selectedRowIndex = 500;
}

-(void)grabCurrentOrder
{
    self.total = [NSNumber numberWithInt:0];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    NSArray* temp = [self.managedObjectContext executeFetchRequest:request error:nil];
    for (Item* item in temp) {
        if (item.isCurOrder) {
            [self.items addObject:item];
            self.total = [NSNumber numberWithFloat:self.total.floatValue+item.price.floatValue];
        }
    }
    if (!self.total) {
        self.checkoutButton.hidden = YES;
        self.checkoutButton.userInteractionEnabled = NO;
    } else {
        self.checkoutButton.hidden = NO;
        self.checkoutButton.userInteractionEnabled = YES;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRowIndex = (int)indexPath.row;
    [tableView beginUpdates];
    [tableView endUpdates];
    CartTableViewCell* cell = (CartTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (self.selectedRowIndex == self.lastSelectedRowIndex) {
        self.lastSelectedRowIndex = 321310;
        cell.mainTextLabel.frame = CGRectMake(5, 4, 258, 21);
        cell.textView.frame = CGRectMake(5, 18, 233, 25);
        cell.subTotal.frame = CGRectMake(229, 0, 86, 45);
    } else {
        self.lastSelectedRowIndex = (int)indexPath.row;
        cell.mainTextLabel.frame = CGRectMake(cell.mainTextLabel.frame.origin.x, 3, cell.mainTextLabel.frame.size.width, 25);
        cell.textView.frame = CGRectMake(cell.textView.frame.origin.x, 18, cell.textView.frame.size.width, 78);
        cell.subTotal.frame = CGRectMake(cell.subTotal.frame.origin.x, 15, cell.subTotal.frame.size.width, 25);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int resize = 100;
    if(indexPath.row == self.selectedRowIndex && !self.willSegue && self.selectedRowIndex != self.lastSelectedRowIndex) {
        return resize;
    }
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    UIView* accView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 40, cell.frame.origin.y, 40, cell.frame.size.height)];
//    UILabel* label = [[UILabel alloc] initWithFrame:accView.frame];
//    [accView addSubview:label];
//    label.text = @"Delete";
//    label.textColor = BAYCOLOR;
//    label.backgroundColor = REDCOLOR;
//    label.layer.borderColor = [UIColor whiteColor].CGColor;
//    label.layer.borderWidth = 2.0f;
//    cell.accessoryView = accView;
    UIView* view = [UIView new];
    view.backgroundColor = BAYCOLOR;
    cell.selectedBackgroundView = view;
    cell.backgroundColor = BAYCOLOR;
    cell.mainTextLabel.textColor = [UIColor blackColor];
    cell.secondaryTextLabel.textColor = [UIColor blackColor];
    cell.subTotal.textColor = GREENCOLOR;
    UIColor* green = GREENCOLOR
    cell.layer.borderColor = green.CGColor;
    cell.layer.borderWidth = 2.0f;
    [self.tableView sendSubviewToBack:cell];
    if (indexPath.row < self.items.count) {
        cell.userInteractionEnabled = YES;
        cell.secondaryTextLabel.hidden = YES;
        cell.textView.hidden = NO;
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//        UIView* separatorLineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, 320, 1)];
        separatorLineView.alpha = 0.5f;
//        separatorLineViewTwo.alpha = 0.7f;
//        separatorLineViewTwo.backgroundColor = REDCOLOR;
        separatorLineView.backgroundColor = REDCOLOR;;
        [cell.contentView addSubview:separatorLineView];
//        [cell.contentView addSubview:separatorLineViewTwo];
        Item* item = [self.items objectAtIndex:indexPath.row];
        cell.layer.borderWidth = 0.0f;
        if (![item.size isEqualToString:@""] || item.size != nil) {
            cell.mainTextLabel.text = [NSString stringWithFormat:@"%@x %@ %@", item.quantity, item.size, item.name];
        } else {
            cell.mainTextLabel.text = [NSString stringWithFormat:@"%@ %@", item.quantity, item.name];
        }
        cell.mainTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.mainTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        if (![item.dressing isEqualToString:@""] || (item.dressing != nil && ![item.addItem isEqualToString:@""])) {
            cell.textView.text = [NSString stringWithFormat:@"W/ %@ dressing\n%@\n%@", item.dressing, item.addItem, item.request];
        }
        if (![item.dressing isEqualToString:@""] && [item.addItem isEqualToString:@""]) {
            cell.textView.text = [NSString stringWithFormat:@"W/ %@ dressing\n%@", item.dressing, item.request];
        }
        if ([item.dressing isEqualToString:@""] && ![item.addItem isEqualToString:@""]) {
            cell.textView.text = [NSString stringWithFormat:@"%@\n%@", item.addItem, item.request];
        }
        if ([item.dressing isEqualToString:@""] && [item.addItem isEqualToString:@""]) {
            cell.textView.text = [NSString stringWithFormat:@"%@", item.request];
        }
        cell.textView.textColor = [UIColor darkGrayColor];
        cell.textView.textAlignment = NSTextAlignmentLeft;
        cell.textView.font = [UIFont fontWithName:@"Helvetica" size:14];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:item.price.floatValue]];
        cell.subTotal.text = numberAsString;
        return cell;
    } else {
        cell.userInteractionEnabled = NO;
        cell.textView.hidden = YES;
        cell.secondaryTextLabel.hidden = NO;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.layer.borderWidth = 2.0f;
        cell.mainTextLabel.text = @"Total";
        cell.mainTextLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        cell.mainTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.secondaryTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        cell.secondaryTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.subTotal.textColor = REDCOLOR;
        self.checkoutButton.hidden = NO;
        self.checkoutButton.userInteractionEnabled = YES;
         if (self.items.count > 0) {
            cell.secondaryTextLabel.text = [NSString stringWithFormat:@"%lu items in your cart", (unsigned long)self.items.count];
        } else {
            cell.secondaryTextLabel.text = [NSString stringWithFormat:@"empty cart"];
            self.checkoutButton.hidden = YES;
            self.checkoutButton.userInteractionEnabled = NO;
        }
        if (self.items.count == 1) {
            cell.secondaryTextLabel.text = [NSString stringWithFormat:@"%lu item in your cart", (unsigned long)self.items.count];
        }
        if (self.total.intValue == 0) {
            cell.subTotal.text = [NSString stringWithFormat:@"$0.00"];
        } else {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.total.floatValue]];
            cell.subTotal.text = numberAsString;
        }
        return cell;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item* item = [self.items objectAtIndex:indexPath.row];
    [self.items removeObject:item];
    [self.managedObjectContext deleteObject:item];
    [self.managedObjectContext save:nil];
    [self grabCurrentOrder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count+1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.willSegue = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
//    if ([segue.destinationViewController isKindOfClass:[MenuViewController class]]) {
//        NSLog(@"here");
//        MenuViewController* mvc = segue.destinationViewController;
//        mvc.managedObjectContext = self.managedObjectContext;
//    }
    if ([segue.destinationViewController isKindOfClass:[CheckoutViewController class]]) {
        CheckoutViewController* cvc = segue.destinationViewController;
        cvc.managedObjectContext = self.managedObjectContext;
        cvc.items = self.items;
    }
    if ([segue.destinationViewController isKindOfClass:[WalletViewController class]]) {
        WalletViewController* wvc = segue.destinationViewController;
        wvc.managedObjectContext = self.managedObjectContext;
    }
}
@end
