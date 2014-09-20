//
//  WalletViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/15/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "WalletViewController.h"
#import "CardTableViewCell.h"
#import "StoreLocationTableViewCell.h"
#import "DeliveryLocationViewController.h"
#import "AddCardViewController.h"
#import "MenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "NonParseStore.h"
#import "Store.h"
#import "Payment.h"
#import "FavoriteStore.h"

@interface WalletViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *storeView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedStoreLocationImageView;
@property (weak, nonatomic) IBOutlet UILabel *selectedStoreLocationLabel;
@property (weak, nonatomic) IBOutlet UITableView *storeLocationTableView;

@property (weak, nonatomic) IBOutlet UIView *paymentView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *paymentMethodTableView;

@property FavoriteStore* favStore;

@property NSArray* paymentArray;
@property NSMutableArray* storeArray;

@property CLLocationManager* locationManager;
@property CLLocation* curLocation;
@property PFGeoPoint* curGeoPoint;
@end

@implementation WalletViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = REDCOLOR;
    [self updateLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self populatePaymentArray];
    if (self.paymentArray.count == 1) {
        Payment* payment = [self.paymentArray objectAtIndex:0];
        self.cardNumberLabel.text = payment.cardNumber;
        self.cardNameLabel.text = payment.holder;
    }
}

-(void) updateLocation
{
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.paymentMethodTableView.tag = 1;
    self.storeLocationTableView.tag = 2;
    self.paymentArray = [NSMutableArray new];
    self.storeArray = [NSMutableArray new];
    self.cardNameLabel.text = @"(Card Holder)";
    self.cardNumberLabel.text = @"(Card Number)";
    self.paymentView.backgroundColor = REDCOLOR;
    self.paymentView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.paymentView.layer.borderWidth = 2.0f;
    self.storeView.backgroundColor = REDCOLOR;
    self.storeView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.storeView.layer.borderWidth = 2.0f;
    self.selectedStoreLocationLabel.textColor = DARKBAYCOLOR;
    self.cardNameLabel.textColor = DARKBAYCOLOR;
    self.cardNumberLabel.textColor = DARKBAYCOLOR;
    self.paymentMethodTableView.backgroundColor = DARKBAYCOLOR;
    self.paymentMethodTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.paymentMethodTableView.layer.borderWidth = 2.0f;
    self.storeLocationTableView.backgroundColor = DARKBAYCOLOR;
    self.storeLocationTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.storeLocationTableView.layer.borderWidth = 2.0f;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.curLocation = locations.firstObject;
    self.curGeoPoint = [PFGeoPoint geoPointWithLatitude:self.curLocation.coordinate.latitude longitude:self.curLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    [self populateArrays];
}

-(void) populateArrays
{
    [self populateStoreArray];
    [self populatePaymentArray];
}

-(void) populatePaymentArray
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Payment"];
    self.paymentArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.paymentMethodTableView reloadData];
    for (Payment* payment in self.paymentArray) {
        if (payment.favorite) {
            self.cardNameLabel.text = payment.holder;
            self.cardNumberLabel.text = payment.cardNumber;
        }
    }
}

-(void) populateStoreArray
{
    NSArray* temp = nonParseStoreArray;
    self.storeArray = [temp mutableCopy];
    [self.storeArray sortUsingComparator:^NSComparisonResult(NonParseStore* obj1, NonParseStore* obj2) {
        int first  = [self.curLocation distanceFromLocation:obj1.location];
        int second = [self.curLocation distanceFromLocation:obj2.location];
        if (first <= second ) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"FavoriteStore"];
    FavoriteStore* fav = [self.managedObjectContext executeFetchRequest:request error:nil].firstObject;
    self.favStore = fav;
    if (fav) {
        for (NonParseStore* store in self.storeArray) {
            if ([store.name isEqualToString:fav.name]) {
                int favIndex = [self.storeArray indexOfObject:store];
                [self.storeArray addObject:[NSNumber numberWithInt:favIndex]];
                break;
            }
        }
    } else {
        self.favStore = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteStore" inManagedObjectContext:self.managedObjectContext];
        [self.managedObjectContext save:nil];
    }
    [self.storeLocationTableView reloadData];
//    PFQuery* query = [Store query];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSArray* temp = objects;
//        self.storeArray = [temp mutableCopy];
//        [self.storeArray sortUsingComparator:^NSComparisonResult(Store* obj1, Store* obj2) {
//            double first  = [self.curGeoPoint distanceInMilesTo:obj1.location];
//            double second = [self.curGeoPoint distanceInMilesTo:obj2.location];
//            if (first <= second ) {
//                return NSOrderedAscending;
//            } else {
//                return NSOrderedDescending;
//            }
//        }];
//        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"FavoriteStore"];
//        FavoriteStore* fav = [self.managedObjectContext executeFetchRequest:request error:nil].firstObject;
//        self.favStore = fav;
//        if (fav) {
//            for (Store* store in self.storeArray) {
//                if ([store.name isEqualToString:fav.name]) {
//                    int favIndex = [self.storeArray indexOfObject:store];
//                    [self.storeArray addObject:[NSNumber numberWithInt:favIndex]];
//                    break;
//                }
//            }
//        } else {
//            self.favStore = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteStore" inManagedObjectContext:self.managedObjectContext];
//            [self.managedObjectContext save:nil];
//        }
//        [self.storeLocationTableView reloadData];
//    }];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return true;
    }
    return false;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Payment* payment = [self.paymentArray objectAtIndex:indexPath.row];
    if (payment.favorite || self.paymentArray.count < 2) {
        NSLog(@"here");
        self.cardNameLabel.text = @"(Card Holder)";
        self.cardNumberLabel.text = @"(Card Number)";
    }
    [self.managedObjectContext deleteObject:payment];
    [self.managedObjectContext save:nil];
    [self populatePaymentArray];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        for (Payment* payment in self.paymentArray) {
            if (payment.favorite) {
                payment.favorite = 0;
            }
        }
        Payment* theFavorite = [self.paymentArray objectAtIndex:indexPath.row];
        theFavorite.favorite = [NSNumber numberWithInt:1];
        [self.managedObjectContext save:nil];
        [self populatePaymentArray];
    } else {
        NonParseStore* store = [self.storeArray objectAtIndex:indexPath.row];
        self.favStore.name = store.name;
        self.favStore.address = store.address;
        [self.managedObjectContext save:nil];
        if ([[self.storeArray objectAtIndex:self.storeArray.count-1] isKindOfClass:[NSNumber class]]) {
            [self.storeArray replaceObjectAtIndex:self.storeArray.count-1 withObject:[NSNumber numberWithInteger:indexPath.row]];
        } else {
            [self.storeArray addObject:[NSNumber numberWithInt:[self.storeArray indexOfObject:store]]];
        }
        [self.storeLocationTableView reloadData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        Payment* payment = [self.paymentArray objectAtIndex:indexPath.row];
        CardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.editingAccessoryView.backgroundColor = REDCOLOR;
        if (payment.favorite || self.paymentArray.count == 1) {
            cell.checkImageView.image = [UIImage imageNamed:@"check"];
            cell.checkImageView.contentMode = UIViewContentModeScaleToFill;
            self.cardNameLabel.text = payment.holder;
            self.cardNumberLabel.text = payment.cardNumber;
        } else {
            cell.checkImageView.image = nil;
        }
        cell.backgroundColor = BAYCOLOR;
        cell.cardNumberLabel.text = payment.cardNumber;
        cell.nameLabel.text = payment.holder;
        return cell;
    } else {
        NonParseStore* store = [self.storeArray objectAtIndex:indexPath.row];
        StoreLocationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.checkMarkImageView.image = nil;
        cell.backgroundColor = BAYCOLOR;
        if ([[self.storeArray objectAtIndex:self.storeArray.count-1] isKindOfClass:[NSNumber class]]) {
            NSNumber* num = (NSNumber*)[self.storeArray objectAtIndex:self.storeArray.count-1];
            if (indexPath.row == num.intValue) {
                cell.checkMarkImageView.image = [UIImage imageNamed:@"check"];
                cell.checkMarkImageView.contentMode = UIViewContentModeScaleToFill;
                self.selectedStoreLocationLabel.text = store.name;
            }
        }
        cell.storeName.text = store.name;
        cell.storeDistance.text = [NSString stringWithFormat:@"%.0fmi", ([self.curLocation distanceFromLocation:store.location] * 0.000621371)];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.paymentArray.count;
    } else {
        if (self.storeArray.count > 0) {
            if ([[self.storeArray objectAtIndex:self.storeArray.count-1] isKindOfClass:[NSNumber class]]) {
                return self.self.storeArray.count-1;
            } else {
                return self.storeArray.count;
            }
        } else {
            return 0;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DeliveryLocationViewController class]]) {
        DeliveryLocationViewController* dvc = segue.destinationViewController;
        dvc.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.destinationViewController isKindOfClass:[AddCardViewController class]]) {
        AddCardViewController* avc = segue.destinationViewController;
        avc.managedObjectContext = self.managedObjectContext;
    }
    if  ([segue.destinationViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController* mvc = segue.destinationViewController;
        mvc.managedObjectContext = self.managedObjectContext;
    }
}

@end
