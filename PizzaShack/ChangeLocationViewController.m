//
//  ChangeLocationViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/19/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "ChangeLocationViewController.h"
#import "CheckoutViewController.h"
#import "NonParseStore.h"
#import "StoreLocationTableViewCell.h"

@interface ChangeLocationViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *addDeliveryLocation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property NSMutableArray* storeArray;
@property NSMutableArray* locationArray;
@property CLLocation* curLocation;
@property CLLocationManager* locationManager;
@end

@implementation ChangeLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.isDelivery) {
        NSArray* temp = nonParseStoreArray;
        self.storeArray = [temp mutableCopy];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    [self fixView];
}

- (IBAction)resignTheResponders:(UITextField *)sender
{
    [sender resignFirstResponder];

    NSArray* array = @[
                       [[NonParseFood alloc] initWithString:@"Cobb Salad" withPrice:[NSNumber numberWithFloat:12.45] withSegmentedControl:@[] withPriceControl:@[] withAddItem:@"" withaddItemPrice:nil withDetail:@"Chicken, bacon, blue cheese, egg, avocado and marinated tomatoes on chopped lettuce." withImage:nil],
                       [[NonParseFood alloc] initWithString:@"Southwestern Shrimp Salad" withPrice:[NSNumber numberWithFloat:12.55] withSegmentedControl:@[] withPriceControl:@[] withAddItem:@"" withaddItemPrice:nil withDetail:@"Spicy seared shrimp on a bed of black beans, corn, green onions, crispy tortilla strips, fresh tomatoes and shredded lettuce tossed with cilantro-ranch dressing." withImage:nil],
                       [[NonParseFood alloc] initWithString:@"Italian Chopped Salad" withPrice:[NSNumber numberWithFloat:9.65] withSegmentedControl:@[] withPriceControl:@[] withAddItem:@"" withaddItemPrice:nil withDetail:@"Julienned salami and pepperoni, grated parmesan, sliced olives and garbanzo beans all tossed with shredded lettuce and our famous homemade Sonoma Italian dressing. Served with our fresh focaccia." withImage:nil],
                       [[NonParseFood alloc] initWithString:@"Spinach Salad" withPrice:[NSNumber numberWithFloat:9.15] withSegmentedControl:@[] withPriceControl:@[] withAddItem:@"Add chicken" withaddItemPrice:@3 withDetail:@"Fresh spinach tossed with walnuts, raisins, cranberries, red onions and crumbled blue cheese.  We recommend our tamari dressing." withImage:nil],
                       [[NonParseFood alloc] initWithString:@"Caesar Salad" withPrice:[NSNumber numberWithFloat:5.65] withSegmentedControl:@[@"Small", @"Large"] withPriceControl:@[@5.65, @9.15] withAddItem:@"" withaddItemPrice:nil withDetail:@"Romaine lettuce, fresh Sonoma sourdough croutons and grated parmesan cheese tossed with Mary’s special Caesar dressing." withImage:nil],
                       [[NonParseFood alloc] initWithString:@"Mary's Signature Salad" withPrice:[NSNumber numberWithFloat:5.75] withSegmentedControl:@[@"Small", @"Large"] withPriceControl:@[@5.75, @9.95] withAddItem:@"Add chicken" withaddItemPrice:@3 withDetail:@"Straight from the Original Shack. Sliced salami, grated mozzarella, marinated three-bean salad, hard-cooked eggs, sliced beets and fresh carrots, mushrooms, tomato and red onion on a bed of iceberg lettuce." withImage:[UIImage imageNamed:@"saladsoup"]],
                        [[NonParseFood alloc] initWithString:@"Soup & Salad Combo" withPrice:[NSNumber numberWithFloat:9.60] withSegmentedControl:@[] withPriceControl:@[] withAddItem:@"" withaddItemPrice:nil withDetail:@"A bowl of our homemade soup of the day and your choice of a small Mary’s or Caesar salad served with fresh sourdough bread." withImage:nil],
                       [[NonParseFood alloc] initWithString:@"Homemade Soup of the Day" withPrice:[NSNumber numberWithFloat:3] withSegmentedControl:@[@"Cup", @"Bowl"] withPriceControl:@[@3, @5.95] withAddItem:@"" withaddItemPrice:nil withDetail:@"Made from Mary’s own family recipes, and changing with the day and the season.  Served with fresh bread." withImage:nil]];




}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.curLocation = locations.firstObject;
    [self.storeArray sortUsingComparator:^NSComparisonResult(NonParseStore* obj1, NonParseStore* obj2) {
        int first  = [self.curLocation distanceFromLocation:obj1.location];
        int second = [self.curLocation distanceFromLocation:obj2.location];
        if (first <= second ) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    [self.tableView reloadData];
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)addLocation:(id)sender
{
    self.locationView.hidden = NO;
    self.locationView.alpha = 1;
    self.dismissButton.titleLabel.textColor = [UIColor whiteColor];
    self.addButton.titleLabel.textColor = [UIColor whiteColor];
    self.streetAddressTextField.text = @"";
    self.addressDetailTextField.text = @"";
    self.phoneNumberTextField.text = @"";
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isDelivery) {
        return self.locationArray.count;
    } else {
        return self.storeArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreLocationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIView* background = [[UIView alloc] initWithFrame:cell.frame];
    background.backgroundColor = BAYCOLOR;
    cell.selectedBackgroundView = background;
    cell.backgroundColor = BAYCOLOR;
    if (self.isDelivery) {
        Location* location = [self.locationArray objectAtIndex:indexPath.row];
        cell.storeName.text = [NSString stringWithFormat:@"%@, %@", location.streetAddress, location.addressDetail];
        cell.storeDistance.text = @"";
        return cell;
    } else {
        NonParseStore* store = [self.storeArray objectAtIndex:indexPath.row];
        cell.storeName.text = store.name;
        if (self.curLocation) {
            int distance = [self.curLocation distanceFromLocation:store.location];
            float miles = (float)distance * 0.000621371;
            cell.storeDistance.text = [NSString stringWithFormat:@"%.0fmi", miles];
        }
        return cell;
    }
}

- (void) fixView
{
    UIColor* color = GREENCOLOR;
    self.navigationItem.titleView.tintColor = color;
    self.streetAddressTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Street Address"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.streetAddressTextField.backgroundColor = BAYCOLOR;
    self.streetAddressTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.streetAddressTextField.layer.borderWidth = 2.0f;
    self.phoneNumberTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Phone Number"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.phoneNumberTextField.backgroundColor = BAYCOLOR;
    self.phoneNumberTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.phoneNumberTextField.layer.borderWidth = 2.0f;
    self.addressDetailTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"City, State"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.addressDetailTextField.backgroundColor = BAYCOLOR;
    self.addressDetailTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addressDetailTextField.layer.borderWidth = 2.0f;
    if (self.isDelivery) {
        self.addDeliveryLocation.hidden = NO;
        self.addDeliveryLocation.userInteractionEnabled = YES;
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
        self.locationArray = [[self.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
        [self.tableView reloadData];
        self.navigationItem.title = @"Delivery Location";
    } else {
        self.addDeliveryLocation.hidden = YES;
        self.addDeliveryLocation.userInteractionEnabled = NO;
        self.navigationItem.title = @"Pickup Location";
    }
    self.view.backgroundColor = DARKBAYCOLOR;
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.tableView.backgroundColor = DARKBAYCOLOR;
    self.tableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tableView.layer.borderWidth = 2.0f;
    self.locationView.backgroundColor = GREENCOLOR;
    self.locationView.clipsToBounds = YES;
    self.locationView.layer.cornerRadius = 160;
    self.locationView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.locationView.layer.borderWidth = 2.0f;
    self.streetAddressTextField.textColor = GREENCOLOR;
    self.addressDetailTextField.textColor = GREENCOLOR;
    self.phoneNumberTextField.textColor = GREENCOLOR;
    self.dismissButton.backgroundColor = REDCOLOR;
    self.dismissButton.titleLabel.textColor = [UIColor whiteColor];
    self.dismissButton.clipsToBounds = YES;
    self.dismissButton.layer.cornerRadius = 35;
    self.dismissButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dismissButton.layer.borderWidth = 2.0f;
    self.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addButton.layer.borderWidth = 2.0f;
    self.addButton.backgroundColor = REDCOLOR;
    self.addButton.titleLabel.textColor = [UIColor whiteColor];
    self.addButton.clipsToBounds = YES;
    self.addButton.layer.cornerRadius = 35;
    self.addButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.addButton.layer.borderWidth = 2.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckoutViewController* cvc = (CheckoutViewController *)[self.navigationController.viewControllers objectAtIndex:2];
    if (self.isDelivery) {
        Location* location = [self.locationArray objectAtIndex:indexPath.row];
        cvc.streetAddress.text = [NSString stringWithFormat:@"  %@", location.streetAddress];
        cvc.detailAddress.text = [NSString stringWithFormat:@"  %@", location.addressDetail];
    } else {
        NonParseStore* store = [self.storeArray objectAtIndex:indexPath.row];
        cvc.streetAddress.text = [NSString stringWithFormat:@"  %@", store.name];
        cvc.detailAddress.text = [NSString stringWithFormat:@"  %@", store.address];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonPressed:(id)sender
{
    [self.addressDetailTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.streetAddressTextField resignFirstResponder];
    if ([self validStreetAddress]) {
        self.locationView.hidden = YES;
        Location* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
        location.streetAddress = self.streetAddressTextField.text;
        location.addressDetail = self.addressDetailTextField.text;
        location.phone = self.phoneNumberTextField.text;
        [self.managedObjectContext save:nil];
        [self fixView];
    } else {
        self.streetAddressTextField.text = @"";
        self.addressDetailTextField.text = @"";
        self.phoneNumberTextField.text = @"";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Correct address and/or phone number and re-submit." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
    }
    self.dismissButton.titleLabel.textColor = [UIColor whiteColor];
    self.addButton.titleLabel.textColor = [UIColor whiteColor];
    self.streetAddressTextField.text = @"";
    self.addressDetailTextField.text = @"";
    self.phoneNumberTextField.text = @"";

}

- (BOOL) validStreetAddress
{
    if (![self.phoneNumberTextField.text isEqualToString:@""] && ![self.streetAddressTextField.text isEqualToString:@""] && ![self.addressDetailTextField.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)dismissButtonPressed:(id)sender
{
    self.dismissButton.titleLabel.textColor = [UIColor whiteColor];
    self.addButton.titleLabel.textColor = [UIColor whiteColor];
    self.locationView.hidden = YES;
    self.streetAddressTextField.text = @"";
    self.addressDetailTextField.text = @"";
    self.phoneNumberTextField.text = @"";
}



@end
