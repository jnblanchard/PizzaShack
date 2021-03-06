//
//  MenuViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/13/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "MenuViewController.h"
#import "FoodOfTypeListViewController.h"
#import "MenuTableViewCell.h"
#import "WalletViewController.h"
#import "CartViewController.h"
#import "Appetizer.h"
#import "SoupSalad.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property NSMutableArray* foodTypes;
@property NSMutableArray* foodArrayToPass;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.typeTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.typeTableView.layer.borderWidth = 2.0f;
    [self populateFoodTypeArray];
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)populateFoodTypeArray
{
    self.foodTypes = [NSMutableArray new];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = DARKBAYCOLOR;
    self.navigationController.navigationBar.barTintColor = REDCOLOR;
    self.navigationController.navigationBar.translucent = NO;
    self.typeTableView.backgroundColor = DARKBAYCOLOR;

    NSArray* array = nonParseAppetizersArray;
    NSMutableArray* temp = [[NSMutableArray alloc] initWithArray:array];
    [temp addObject:@"Appetizers"];
    [temp addObject:[UIImage imageNamed:@"bread"]];
    [self.foodTypes addObject:temp];

    array = nonParseSoupSaladdArray;
    temp = [[NSMutableArray alloc] initWithArray:array];
    [temp addObject:@"Soups & Salads"];
    [temp addObject:[UIImage imageNamed:@"salad"]];
    [self.foodTypes addObject:temp];

//    PFQuery* appetizersQuery = [Appetizer query];
//    [appetizersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSMutableArray* temp = [[NSMutableArray alloc] initWithArray:objects];
//        [temp addObject:@"Appetizers"];
//        [temp addObject:[UIImage imageNamed:@"bread"]];
//        [self.foodTypes addObject:temp];
//        [self.typeTableView reloadData];
//    }];
//    PFQuery* soupSaladQuery = [SoupSalad query];
//    [soupSaladQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSMutableArray* temp = [[NSMutableArray alloc] initWithArray:objects];
//        [temp addObject:@"Soups & Salads"];
//        [temp addObject:[UIImage imageNamed:@"salad"]];
//        [self.foodTypes addObject:temp];
//        [self.typeTableView reloadData];
//    }];
}

-(void) fixArrayOrder
{

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.foodTypes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1.0f;
    UIView* view = [UIView new];
    view.backgroundColor = BAYCOLOR;
    cell.selectedBackgroundView = view;
    cell.backgroundColor = BAYCOLOR;
    cell.numberLabel.textColor = GREENCOLOR;
    cell.numberLabel.backgroundColor = BAYCOLOR;
    NSMutableArray* temp = [self.foodTypes objectAtIndex:indexPath.row];
    cell.itemLabel.text = [temp objectAtIndex:temp.count-2];
    cell.numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)temp.count-2];
    cell.detailImageView.image = [temp objectAtIndex:temp.count-1];
    cell.detailImageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[FoodOfTypeListViewController class]]) {
        FoodOfTypeListViewController* fvc = segue.destinationViewController;
        self.foodArrayToPass = [self.foodTypes objectAtIndex:self.typeTableView.indexPathForSelectedRow.row];
        fvc.managedObjectContext = self.managedObjectContext;
        fvc.navigationItem.title = [self.foodArrayToPass objectAtIndex:self.foodArrayToPass.count-2];
        fvc.foodList = self.foodArrayToPass;
    }
    if ([segue.destinationViewController isKindOfClass:[WalletViewController class]]) {
        WalletViewController* wvc = segue.destinationViewController;
        wvc.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.destinationViewController isKindOfClass:[CartViewController class]]) {
        CartViewController* cvc = segue.destinationViewController;
        cvc.managedObjectContext = self.managedObjectContext;
    }
}

@end
