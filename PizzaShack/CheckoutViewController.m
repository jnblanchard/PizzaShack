//
//  CheckoutViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/18/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CartViewController.h"
#import "ChangeLocationViewController.h"
#import "AddCardViewController.h"
#import "Order.h"
#import "FavoriteStore.h"
#import "Location.h"
#import "Item.h"

@interface CheckoutViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *deliveryLocationButton;
@property (weak, nonatomic) IBOutlet UIView *paymentView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *locationMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationSecondaryLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSegmentedControl;

@property (weak, nonatomic) IBOutlet UIButton *paymentButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardHolderLabel;
@property NSString* orderType;
@end

@implementation CheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateCheckoutView];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.locationSegmentedControl.selectedSegmentIndex == 1) {
        self.locationSegmentedControl.selectedSegmentIndex = 0;
        self.locationSegmentedControl.selectedSegmentIndex = 1;
    } else {
        self.locationSegmentedControl.selectedSegmentIndex = 1;
        self.locationSegmentedControl.selectedSegmentIndex = 0;
    }
    [self fillOutPaymentBoxes];
}

- (void) populateCheckoutView
{
    self.orderType = @"Delivery";
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.view.backgroundColor = DARKBAYCOLOR;
    self.paymentView.backgroundColor = BAYCOLOR;
    self.paymentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.paymentView.layer.borderWidth = 2.0f;
    self.cardHolderLabel.backgroundColor = GREENCOLOR;
    self.cardHolderLabel.textColor = DARKBAYCOLOR;
    self.cardHolderLabel.clipsToBounds = YES;
    self.cardHolderLabel.layer.cornerRadius = 10;
    self.cardHolderLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cardHolderLabel.layer.borderWidth = 2.0f;
    self.cardNumberLabel.backgroundColor = GREENCOLOR;
    self.cardNumberLabel.textColor = DARKBAYCOLOR;
    self.cardNumberLabel.clipsToBounds = YES;
    self.cardNumberLabel.layer.cornerRadius = 10;
    self.cardNumberLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cardNumberLabel.layer.borderWidth = 2.0f;
    self.paymentSegmentedControl.tintColor = REDCOLOR;
    self.paymentButton.backgroundColor = REDCOLOR;
    self.paymentButton.clipsToBounds = YES;
    self.paymentButton.layer.cornerRadius = 10;
    self.paymentButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.paymentButton.layer.borderWidth = 2.0f;
    self.locationView.backgroundColor = BAYCOLOR;
    self.locationView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.locationView.layer.borderWidth = 2.0f;
    self.placeOrderButton.backgroundColor = REDCOLOR
    self.placeOrderButton.clipsToBounds = YES;
    self.placeOrderButton.layer.cornerRadius = 10;
    self.placeOrderButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.placeOrderButton.layer.borderWidth = 2.0f;
    self.locationMainLabel.backgroundColor = GREENCOLOR;
    self.locationSecondaryLabel.backgroundColor = GREENCOLOR;
    self.locationSegmentedControl.tintColor = REDCOLOR;
    self.locationMainLabel.textColor = DARKBAYCOLOR;
    self.locationSecondaryLabel.textColor = DARKBAYCOLOR;
    self.locationMainLabel.clipsToBounds = YES;
    self.locationSecondaryLabel.clipsToBounds = YES;
    self.locationMainLabel.layer.cornerRadius = 10;
    self.locationSecondaryLabel.layer.cornerRadius = 10;
    self.locationMainLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.locationMainLabel.layer.borderWidth = 2.0f;
    self.locationSecondaryLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.locationSecondaryLabel.layer.borderWidth = 2.0f;
    self.deliveryLocationButton.backgroundColor = REDCOLOR;
    self.deliveryLocationButton.clipsToBounds = YES;
    self.deliveryLocationButton.layer.cornerRadius = 10;
    self.deliveryLocationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deliveryLocationButton.layer.borderWidth = 2.0f;

    [self fillOutPaymentBoxes];

    if (!self.aLocation) {
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
        NSArray* temp = [self.managedObjectContext executeFetchRequest:request error:nil];
        for (Location* location in temp) {
            if (location.favorite) {
                self.locationMainLabel.text = [NSString stringWithFormat:@"  %@",location.streetAddress];
                self.locationSecondaryLabel.text = [NSString stringWithFormat:@"  %@",location.addressDetail];
            }
        }
    } else {
        NSLog(@"here");
        self.locationMainLabel.text = [NSString stringWithFormat:@"  %@", self.aLocation.streetAddress];
        self.locationSecondaryLabel.text = [NSString stringWithFormat:@"  %@", self.aLocation.addressDetail];
    }
}

-(void) fillOutPaymentBoxes
{
    if (!self.aPayment) {
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Payment"];
        NSArray* tempTwo = [self.managedObjectContext executeFetchRequest:request error:nil];
        for (Payment* payment in tempTwo) {
            if (payment.favorite) {
                self.cardHolderLabel.text = [NSString stringWithFormat:@"  %@", payment.holder];
                self.cardNumberLabel.text = [NSString stringWithFormat:@"  %@", payment.cardNumber];
            }
        }
    } else {
        self.cardHolderLabel.text = [NSString stringWithFormat:@"  %@", self.aPayment.holder];
        self.cardNumberLabel.text = [NSString stringWithFormat:@"  %@", self.aPayment.cardNumber];
    }
}

- (IBAction)paymentSegmentedControlValueChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.paymentButton.hidden = NO;
        self.cardHolderLabel.hidden = NO;
        self.cardNumberLabel.textAlignment = NSTextAlignmentLeft;
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Payment"];
        NSArray* temp = [self.managedObjectContext executeFetchRequest:request error:nil];
        BOOL flag = NO;
        for (Payment* payment in temp) {
            if (payment.favorite) {
                self.cardHolderLabel.text = [NSString stringWithFormat:@"  %@", payment.holder];
                self.cardNumberLabel.text = [NSString stringWithFormat:@"  %@", payment.cardNumber];
                flag = YES;
            }
        }
        if (!flag) {
            self.cardNumberLabel.text = [NSString stringWithFormat:@"  Card Number"];
            self.cardHolderLabel.text = [NSString stringWithFormat:@"  Card Holder"];
        }
        if (self.aPayment) {
            self.cardNumberLabel.text = [NSString stringWithFormat:@"  %@", self.aPayment.cardNumber];
            self.cardHolderLabel.text = [NSString stringWithFormat:@"  %@", self.aPayment.holder];
        }
    } else {
        self.paymentButton.hidden = YES;
        self.cardHolderLabel.hidden = YES;
        self.cardNumberLabel.textAlignment = NSTextAlignmentCenter;
        self.cardNumberLabel.text = [NSString stringWithFormat:@"Cash"];
    }
}

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.orderType = @"Delivery";
        [self.deliveryLocationButton setTitle:@"Change Delivery Location" forState:UIControlStateNormal];
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
        NSArray* temp = [self.managedObjectContext executeFetchRequest:request error:nil];
        BOOL flag = NO;
        for (Location* location in temp) {
            if (location.favorite) {
                self.locationMainLabel.text = [NSString stringWithFormat:@"  %@",location.streetAddress];
                self.locationSecondaryLabel.text = [NSString stringWithFormat:@"  %@",location.addressDetail];
                flag = YES;
            }
        }
        if (!flag) {
            self.locationMainLabel.text = [NSString stringWithFormat:@"  Street Address"];
            self.locationSecondaryLabel.text = [NSString stringWithFormat:@"  City, State"];
        }
    } else {
        self.orderType = @"Pickup";
        [self.deliveryLocationButton setTitle:@"Change Pickup Location" forState:UIControlStateNormal];
        self.locationMainLabel.text = [NSString stringWithFormat:@"  Shack"];
        self.locationSecondaryLabel.text = [NSString stringWithFormat:@"  Shack Address"];
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"FavoriteStore"];
        NSArray* temp = [self.managedObjectContext executeFetchRequest:request error:nil];
        FavoriteStore* fav = temp.firstObject;
        if (fav) {
            self.locationMainLabel.text = [NSString stringWithFormat:@"  %@", fav.name];
            self.locationSecondaryLabel.text = [NSString stringWithFormat:@"  %@", fav.address];
        }
    }
}

- (IBAction)placeOrderButtonPressed:(id)sender
{
    NSString* message = [NSString stringWithFormat:@"%@  -%@\n", self.orderType, self.locationMainLabel.text];
    NSNumber* total = @0;
    for (Item* item in self.items) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:item.price.floatValue]];
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@ - %@ \n", item.name, numberAsString]];
        total = [NSNumber numberWithFloat:total.floatValue+item.price.floatValue];
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total.floatValue]];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"Total - %@", numberAsString]];
    if ([self checkForValidOrder]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Place order?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Confirm", nil];
        alert.tag = 1;
        [alert show];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing information" message:@"missing delivery/pickup information\n or missing payment information" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        alert.tag = 2;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSSet* set = [[NSSet alloc] initWithArray:self.items];
            Order* order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:self.managedObjectContext];
            [order addItems:set];
            [self.managedObjectContext save:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(BOOL) checkForValidOrder
{
    if (![self.cardNumberLabel.text isEqualToString:@"  Card Number"] && (![self.locationMainLabel.text isEqualToString:@"  Street Address"] || ![self.locationMainLabel.text isEqualToString:@"  Shack Address"]) && (![self.locationSecondaryLabel.text isEqualToString:@"  City, State"] || [self.locationSecondaryLabel.text isEqualToString:@"  Shack Address"])) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)changeDeliveryLocationButtonPressed:(id)sender
{

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ChangeLocationViewController class]]) {
        ChangeLocationViewController* cvc = segue.destinationViewController;
        if ([self.deliveryLocationButton.titleLabel.text isEqualToString:@"Change Delivery Location"]) {
            cvc.isDelivery = YES;
        } else {
            cvc.isDelivery = NO;
        }
        cvc.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.destinationViewController isKindOfClass:[CartViewController class]]) {
        CartViewController* cvc = segue.destinationViewController;
        cvc.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.destinationViewController isKindOfClass:[AddCardViewController class]]) {
        AddCardViewController* avc = segue.destinationViewController;
        avc.managedObjectContext = self.managedObjectContext;
    }
}
@end
