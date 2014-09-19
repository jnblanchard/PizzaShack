//
//  FoodOfTypeListViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/14/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "FoodOfTypeListViewController.h"
#import "DetailOrderViewController.h"
#import "MenuViewController.h"
#import "CartViewController.h"

@interface FoodOfTypeListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;

@end

@implementation FoodOfTypeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.foodTableView.backgroundColor = DARKBAYCOLOR;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.foodList.count-2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = BAYCOLOR;
    PFObject* object = [self.foodList objectAtIndex:indexPath.row];
    cell.textLabel.text = object[@"name"];
    NSNumber* price = object[@"price"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price.floatValue]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", numberAsString];
    cell.detailTextLabel.textColor = GREENCOLOR;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DetailOrderViewController class]]) {
        DetailOrderViewController* dvc = segue.destinationViewController;
        dvc.item = [self.foodList objectAtIndex:self.foodTableView.indexPathForSelectedRow.row];
        dvc.managedObjectContext = self.managedObjectContext;
        dvc.navigationItem.title = dvc.item[@"name"];
    }
    if ([segue.destinationViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController* mvc = segue.destinationViewController;
        mvc.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.destinationViewController isKindOfClass:[CartViewController class]]) {
        CartViewController* cvc = segue.destinationViewController;
        cvc.managedObjectContext = self.managedObjectContext;
    }
}

@end
