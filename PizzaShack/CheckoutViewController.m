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
#import "FavoriteStore.h"
#import "Location.h"

@interface CheckoutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deliveryLocationButton;
@property (weak, nonatomic) IBOutlet UIView *paymentView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *locationMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationSecondaryLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSegmentedControl;

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
}

- (void) populateCheckoutView
{
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.view.backgroundColor = DARKBAYCOLOR;
    self.paymentView.backgroundColor = BAYCOLOR;
    self.paymentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.paymentView.layer.borderWidth = 2.0f;
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
    self.locationSegmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.locationSegmentedControl.layer.borderWidth = 2.0f;
    self.deliveryLocationButton.backgroundColor = REDCOLOR;
    self.deliveryLocationButton.clipsToBounds = YES;
    self.deliveryLocationButton.layer.cornerRadius = 10;
    self.deliveryLocationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deliveryLocationButton.layer.borderWidth = 2.0f;

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
        self.locationMainLabel.text = [NSString stringWithFormat:@"  %@", self.aLocation.streetAddress];
        self.locationSecondaryLabel.text = [NSString stringWithFormat:@"  %@", self.aLocation.addressDetail];
    }
}


- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
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
}
@end
