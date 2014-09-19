//
//  DeliveryLocationViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/16/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "DeliveryLocationViewController.h"
#import "DeliveryLocationTableViewCell.h"
#import "Location.h"

@interface DeliveryLocationViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *customAlertView;
@property (weak, nonatomic) IBOutlet UITextField *streetAdressTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UITextField *detailStreetAddressTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* locations;

@end

@implementation DeliveryLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
    [self loadData];
}

- (void) setUpViews
{
    self.locations = [NSMutableArray new];
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.customAlertView.backgroundColor = GREENCOLOR;
    self.customAlertView.clipsToBounds = YES;
    self.customAlertView.layer.cornerRadius = 160;
    self.customAlertView.layer.masksToBounds = YES;
    self.customAlertView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.customAlertView.layer.borderWidth = 2.0f;
    self.streetAdressTextField.textColor = GREENCOLOR;
    self.streetAdressTextField.backgroundColor = BAYCOLOR;
    self.detailStreetAddressTextField.backgroundColor = BAYCOLOR;
    self.detailStreetAddressTextField.textColor = GREENCOLOR;
    self.phoneNumberTextField.backgroundColor = BAYCOLOR;
    self.phoneNumberTextField.textColor = GREENCOLOR;
    self.tableView.backgroundColor = DARKBAYCOLOR;
    self.tableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tableView.layer.borderWidth = 2.0f;
    self.dismissButton.clipsToBounds = YES;
    self.dismissButton.layer.cornerRadius = self.dismissButton.frame.size.height/2;
    self.dismissButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dismissButton.layer.borderWidth = 2.0f;
    self.enterButton.clipsToBounds = YES;
    self.enterButton.layer.cornerRadius = self.enterButton.frame.size.height/2;
    self.enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.enterButton.layer.borderWidth = 2.0f;
    self.dismissButton.backgroundColor = REDCOLOR;
    self.enterButton.backgroundColor = REDCOLOR;
    self.dismissButton.titleLabel.textColor = BAYCOLOR;
    self.enterButton.titleLabel.textColor = BAYCOLOR;
    UIColor *color = GREENCOLOR;
    self.streetAdressTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Street Address"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.phoneNumberTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Phone Number"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.detailStreetAddressTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"City, State"
     attributes:@{NSForegroundColorAttributeName:color}];
}

-(void)loadData
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    self.locations = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

- (IBAction)dismissButtonPressed:(id)sender
{
    [self.streetAdressTextField resignFirstResponder];
    [self.detailStreetAddressTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    self.streetAdressTextField.text = @"";
    self.detailStreetAddressTextField.text = @"";
    [UIView animateWithDuration:0.5 animations:^{
        self.customAlertView.alpha = 0;
    } completion:^(BOOL finished) {
        self.customAlertView.hidden = YES;
    }];
    self.customAlertView.alpha = 0;
}

- (IBAction)enterButtonPressed:(id)sender
{
    [self.streetAdressTextField resignFirstResponder];
    [self.detailStreetAddressTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    self.dismissButton.titleLabel.textColor = BAYCOLOR;
    self.enterButton.titleLabel.textColor = BAYCOLOR;
    if ([self validStreetAddress]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.customAlertView.alpha = 0;
        } completion:^(BOOL finished) {
            self.customAlertView.hidden = YES;
        }];
        Location* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
        location.streetAddress = self.streetAdressTextField.text;
        location.addressDetail = self.detailStreetAddressTextField.text;
        [self.managedObjectContext save:nil];
        [self loadData];
    } else {
        self.streetAdressTextField.text = @"";
        self.detailStreetAddressTextField.text = @"";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Correct address and/or phone number and re-submit." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        self.enterButton.titleLabel.textColor = BAYCOLOR;
        self.dismissButton.titleLabel.textColor = BAYCOLOR;
    }
    self.streetAdressTextField.text = @"";
    self.detailStreetAddressTextField.text = @"";
    self.phoneNumberTextField.text = @"";
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.enterButton.titleLabel.textColor = BAYCOLOR;
    self.dismissButton.titleLabel.textColor = BAYCOLOR;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (Location* location in self.locations) {
        if (location.favorite) {
            location.favorite = 0;
        }
    }
    Location* theFavorite = [self.locations objectAtIndex:indexPath.row];
    theFavorite.favorite = [NSNumber numberWithInt:1];
    [self.managedObjectContext save:nil];
    [self loadData];
}

- (BOOL) validStreetAddress
{
    if (![self.phoneNumberTextField.text isEqualToString:@""] && ![self.streetAdressTextField.text isEqualToString:@""] && ![self.detailStreetAddressTextField.text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location* location = [self.locations objectAtIndex:indexPath.row];
    DeliveryLocationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (location.favorite) {
        cell.checkImageView.image = [UIImage imageNamed:@"check"];
    } else {
        cell.checkImageView.image = nil;
    }
    cell.backgroundColor = BAYCOLOR;
    cell.addressLabel.text = location.streetAddress;
    cell.addressDetailLabel.text = location.addressDetail;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (IBAction)addButtonPressed:(id)sender
{
    if (self.customAlertView.hidden) {
        self.customAlertView.hidden = NO;
        self.dismissButton.titleLabel.textColor = BAYCOLOR;
        self.enterButton.titleLabel.textColor = BAYCOLOR;
        [self.view bringSubviewToFront:self.customAlertView];
        [UIView animateWithDuration:0.5 animations:^{
            self.customAlertView.alpha = 1;
        } completion:^(BOOL finished) {

        }];
    } else {
        [self.streetAdressTextField resignFirstResponder];
        [self.detailStreetAddressTextField resignFirstResponder];
        [self.phoneNumberTextField resignFirstResponder];
        self.streetAdressTextField.text = @"";
        self.detailStreetAddressTextField.text = @"";
        [UIView animateWithDuration:0.5 animations:^{
            self.customAlertView.alpha = 0;
        } completion:^(BOOL finished) {
            self.customAlertView.hidden = YES;
        }];
        self.customAlertView.alpha = 0;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location* location = [self.locations objectAtIndex:indexPath.row];
    [self.managedObjectContext deleteObject:location];
    [self.managedObjectContext save:nil];
    [self loadData];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (IBAction)textFieldDoneEditing:(UITextField *)sender
{
    [sender resignFirstResponder];
}


@end
