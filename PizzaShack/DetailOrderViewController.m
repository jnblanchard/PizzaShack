//
//  DetailOrderViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/14/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "DetailOrderViewController.h"
#import "CartViewController.h"
#import "FoodOfTypeListViewController.h"
#import "Order.h"
#import "Item.h"

#define QuantityActionSheetTag 1
#define DressingActionSheetTag 2

@interface DetailOrderViewController () <UITextViewDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bigQuantityButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIButton *quantityButton;
@property (weak, nonatomic) IBOutlet UIButton *dressingButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UITextField *foodRequestTextField;
@property (weak, nonatomic) IBOutlet UISwitch *addSwitch;
@property  NSNumber* price;
@property int quantity;
@property NSArray* dressingArray;
@property UIPickerView* picker;
@property UIActionSheet* sheet;
@property NSNumber* addition;
@property NSString* addItem;
@end

@implementation DetailOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateDetailView];
}

-(void) correctSegmentControl
{
    NSArray* array = self.item[@"segmentedControl"];
    int count = (int)array.count;
    if (!count) {
        self.segmentedControl.hidden = YES;
    } else {
        self.segmentedControl.hidden = NO;
        if (count == 2) {
            [self.segmentedControl removeSegmentAtIndex:2 animated:YES];
            [self.segmentedControl setTitle:array[0] forSegmentAtIndex:0];
            [self.segmentedControl setTitle:array[1] forSegmentAtIndex:1];
        }
        if (count == 3) {
            [self.segmentedControl setTitle:array[0] forSegmentAtIndex:0];
            [self.segmentedControl setTitle:array[1] forSegmentAtIndex:1];
            [self.segmentedControl setTitle:array[2] forSegmentAtIndex:2];
        }
    }
}

- (IBAction)valueOfSwitchChanged:(UISwitch *)sender
{
    if (sender.on) {
        self.addition = self.item[@"addItemPrice"];
        [self calculatePriceSetLabel];
    } else {
        self.addition = 0;
        [self calculatePriceSetLabel];
    }
}

- (IBAction)sizeSegmentedControlChange:(UISegmentedControl *)sender
{
    NSArray* array = self.item[@"priceControl"];
    self.price = [array objectAtIndex:sender.selectedSegmentIndex];
    NSLog(@"price - %@", self.price);
    [self calculatePriceSetLabel];
}

- (void) populateAddItems
{
    self.addItem = self.item[@"addItem"];
    if (self.addItem) {
        self.addSwitch.hidden = NO;
        self.addLabel.hidden = NO;
        self.addSwitch.thumbTintColor = BAYCOLOR;
        self.addSwitch.onTintColor = GREENCOLOR;
        self.addition = self.item[@"addItemPrice"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.addition.floatValue]];
        self.addLabel.text = [NSString stringWithFormat:@"%@ for %@ via switch", self.addItem, numberAsString];
        self.addition = 0;
    } else {
        if (![self.navigationItem.title hasSuffix:@"Salad"] && ![self.navigationItem.title hasSuffix:@"Salad Combo"]) {
            NSLog(@"%@", self.navigationItem.title);
            self.quantityButton.hidden = YES;
            self.dressingButton.hidden = YES;
            self.priceLabel.hidden = YES;
            self.bigQuantityButton.hidden = NO;
            self.bigPriceLabel.hidden = NO;
        } else {
            self.quantityButton.hidden = NO;
            self.dressingButton.hidden = NO;
            self.priceLabel.hidden = YES;
            self.bigQuantityButton.hidden = YES;
            self.bigPriceLabel.hidden = NO;
        }
        self.addItem = @"";
        self.addLabel.hidden = YES;
        self.addSwitch.hidden = YES;
    }
}

-(void) calculatePriceSetLabel
{
    float price = (self.price.floatValue + self.addition.floatValue) * (float)self.quantity;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", numberAsString];
    self.bigPriceLabel.text = [NSString stringWithFormat:@"%@", numberAsString];
}

-(void) populateDetailView
{
    self.quantity = 1;
    self.dressingArray = @[@"Sonoma Italian", @"Thousand Island", @"Blue Cheese", @"Ranch", @"Tamari", @"Raspberry Vinaigrette"];
    PFFile* file = self.item[@"photo"];
    [self correctSegmentControl];
    [self populateAddItems];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.itemImageView.image = [UIImage imageWithData:data];
        }
    }];
    if ([self.navigationItem.title hasSuffix:@"Salad"] || [self.navigationItem.title hasSuffix:@"Salad Combo"]) {
        self.dressingButton.hidden = NO;
        self.dressingButton.enabled = YES;
    } else {
        self.dressingButton.hidden = YES;
        self.dressingButton.enabled = NO;
    }
    self.view.backgroundColor = BAYCOLOR;
    UIColor *color = GREENCOLOR;
    self.foodRequestTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Write your food request here."
     attributes:@{NSForegroundColorAttributeName:color}];
    self.addToCartButton.backgroundColor = REDCOLOR;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.tintColor = REDCOLOR;
    self.foodRequestTextField.backgroundColor = DARKBAYCOLOR;
    self.addToCartButton.titleLabel.textColor = [UIColor whiteColor];
    self.addToCartButton.clipsToBounds = YES;
    self.addToCartButton.layer.cornerRadius = 10;
    self.quantityButton.backgroundColor = REDCOLOR;
    self.quantityButton.clipsToBounds = YES;
    self.quantityButton.layer.cornerRadius = 10;
    self.bigQuantityButton.backgroundColor = REDCOLOR;
    self.bigQuantityButton.clipsToBounds = YES;
    self.bigQuantityButton.layer.cornerRadius = 15;
    self.dressingButton.backgroundColor = REDCOLOR;
    self.dressingButton.clipsToBounds = YES;
    self.dressingButton.layer.cornerRadius = 10;
    self.priceLabel.backgroundColor = REDCOLOR;
    self.priceLabel.clipsToBounds = YES;
    self.priceLabel.layer.cornerRadius = 10;
    self.bigPriceLabel.backgroundColor = REDCOLOR;
    self.bigPriceLabel.clipsToBounds = YES;
    self.bigPriceLabel.layer.cornerRadius = 22;
    self.quantityButton.titleLabel.textColor = [UIColor whiteColor];
    self.bigQuantityButton.titleLabel.textColor = [UIColor whiteColor];
    self.priceLabel.textColor = [UIColor whiteColor];
    self.bigPriceLabel.textColor = [UIColor whiteColor];
    self.dressingButton.titleLabel.textColor = [UIColor whiteColor];
    self.price = self.item[@"price"];
    [self calculatePriceSetLabel];
    self.detailTextView.text = self.item[@"detail"];
    [self.detailTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
}

- (IBAction)addToCartButtonPressed:(id)sender
{
    [self.foodRequestTextField resignFirstResponder];
    [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.quantityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bigQuantityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([self checkForValidOrder]) {
        Item* item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        item.name = self.navigationItem.title;
        item.request = self.foodRequestTextField.text;
        NSString* sepparate = [self.priceLabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        item.price = [NSNumber numberWithFloat:sepparate.floatValue];
        NSLog(@"price %@", item.price);
        NSLog(@"request - %@", item.request);
        item.quantity = [NSNumber numberWithInt:self.quantity];
        NSLog(@"quantity - %@", item.quantity);
        item.size = [self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
        NSLog(@"size - %@", item.size);
        item.addItem = self.addItem;
        NSLog(@"add item - %@", item.addItem);
        item.isCurOrder = [NSNumber numberWithInt:1];
        if (self.dressingButton.hidden == NO) {
            item.dressing = self.dressingButton.titleLabel.text;
        } else {
            item.dressing = @"";
        }
        [self.managedObjectContext save:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing information" message:@"Provide information regarding this order" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }

}

-(BOOL) checkForValidOrder
{
    if (self.dressingButton.hidden) {
        return YES;
    } else {
        if (![self.dressingButton.titleLabel.text isEqualToString:@"Dressing"] ) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (IBAction)quantityButtonHit:(id)sender
{
    [self.foodRequestTextField resignFirstResponder];
    self.sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:@"" otherButtonTitles: nil];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 68, 320, 320)];
    self.picker.backgroundColor = BAYCOLOR;
    self.picker.showsSelectionIndicator=YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.tag = QuantityActionSheetTag;
    [self.sheet addSubview:self.picker];
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20,320,60)];
    tools.barTintColor = DARKBAYCOLOR;
    [self.sheet addSubview:tools];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(btnActinDoneClicked)];
    doneButton.tintColor = REDCOLOR;
    doneButton.imageInsets=UIEdgeInsetsMake(200, -6, 50, 25);
    UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array = [[NSArray alloc]initWithObjects:flexSpace,doneButton,nil];
    [tools setItems:array];
    UILabel *lblPickerTitle=[[UILabel alloc]initWithFrame:CGRectMake(5,24, 260, 25)];
    lblPickerTitle.text=[NSString stringWithFormat:@"Select quantity of %@", self.navigationItem.title];
    lblPickerTitle.backgroundColor=[UIColor clearColor];
    lblPickerTitle.textColor=[UIColor blackColor];
    lblPickerTitle.textAlignment=NSTextAlignmentCenter;
    lblPickerTitle.font=[UIFont boldSystemFontOfSize:14];
    [tools addSubview:lblPickerTitle];
    [self.sheet showFromRect:CGRectMake(0,480, 320,225) inView:self.view animated:YES];
    [self.sheet setBounds:CGRectMake(0,0, 320, 431)];
//    [self.view addSubview:picker];
//    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Select quantity of %@", self.navigationItem.title] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
//    sheet.tag = QuantityActionSheetTag;
//    [sheet showInView:self.view];
}

- (void) btnActinDoneClicked
{
    [self.sheet dismissWithClickedButtonIndex:0 animated:YES];
    [self.quantityButton setTitle:[NSString stringWithFormat:@"Quantity - %ld", (long)[self.picker selectedRowInComponent:0]+1] forState:UIControlStateNormal];
    [self.bigQuantityButton setTitle:[NSString stringWithFormat:@"Quantity - %ld", (long)[self.picker selectedRowInComponent:0]+1] forState:UIControlStateNormal];
    [self setLabelForPrice:[self.picker selectedRowInComponent:0]+1];
    [self.bigQuantityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.quantityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [actionSheet resignFirstResponder];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", (long)row+1];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == QuantityActionSheetTag) {
        switch (buttonIndex) {
            case 0:
                [self.quantityButton setTitle:@"Quantity - 1" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 1" forState:UIControlStateNormal];
                [self setLabelForPrice:1];
                break;
            case 1:
                [self.quantityButton setTitle:@"Quantity - 2" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 2" forState:UIControlStateNormal];
                [self setLabelForPrice:2];
                break;
            case 2:
                [self.quantityButton setTitle:@"Quantity - 3" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 3" forState:UIControlStateNormal];
                [self setLabelForPrice:3];
                break;
            case 3:
                [self.quantityButton setTitle:@"Quantity - 4" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 4" forState:UIControlStateNormal];
                [self setLabelForPrice:4];
                break;
            case 4:
                [self.quantityButton setTitle:@"Quantity - 5" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 5" forState:UIControlStateNormal];
                [self setLabelForPrice:5];
                break;
            case 5:
                [self.quantityButton setTitle:@"Quantity - 6" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 6" forState:UIControlStateNormal];
                [self setLabelForPrice:6];
                break;
            case 6:
                [self.quantityButton setTitle:@"Quantity - 7" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 7" forState:UIControlStateNormal];
                [self setLabelForPrice:7];
                break;
            case 7:
                [self.quantityButton setTitle:@"Quantity - 8" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 8" forState:UIControlStateNormal];
                [self setLabelForPrice:8];
                break;
            case 8:
                [self.quantityButton setTitle:@"Quantity - 9" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 9" forState:UIControlStateNormal];
                [self setLabelForPrice:9];
                break;
            case 9:
                [self.quantityButton setTitle:@"Quantity - 10" forState:UIControlStateNormal];
                [self.bigQuantityButton setTitle:@"Quantity - 10" forState:UIControlStateNormal];
                [self setLabelForPrice:10];
                break;
            default:
                [self setLabelForPrice:1];
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                [self.dressingButton setTitle:@"Sonoma Italian" forState:UIControlStateNormal];
                [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            case 1:
                [self.dressingButton setTitle:@"Thousand Island" forState:UIControlStateNormal];
                [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            case 2:
                [self.dressingButton setTitle:@"Blue Cheese" forState:UIControlStateNormal];
                [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            case 3:
                [self.dressingButton setTitle:@"Ranch" forState:UIControlStateNormal];
                [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            case 4:
                [self.dressingButton setTitle:@"Tamari" forState:UIControlStateNormal];
                [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            case 5:
                [self.dressingButton setTitle:@"Raspberry Vinaigrette" forState:UIControlStateNormal];
                [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (void) setLabelForPrice:(int)multiplier
{
    self.quantity = multiplier;
    float thePrice = (float)multiplier * (self.price.floatValue + self.addition.floatValue);
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:thePrice]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", numberAsString];
    self.bigPriceLabel.text = [NSString stringWithFormat:@"%@", numberAsString];
    [self.quantityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bigQuantityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dressingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)dressingButtonHit:(id)sender
{
    [self.foodRequestTextField resignFirstResponder];
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Select dressing for %@", self.navigationItem.title] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sonoma Italian", @"Thousand Island", @"Blue Cheese", @"Ranch", @"Tamari", @"Raspberry Vinaigrette", nil];
    sheet.tag = DressingActionSheetTag;
    [sheet showInView:self.view];
}

- (IBAction)touchDown:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -210);
    } completion:^(BOOL finished) {

    }];
}


- (IBAction)didFinishEditing:(id)sender
{
    [self.foodRequestTextField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {

    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CartViewController class]]) {
        CartViewController* cvc = segue.destinationViewController;
        cvc.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.destinationViewController isKindOfClass:[FoodOfTypeListViewController class]]) {
        FoodOfTypeListViewController* fvc = segue.destinationViewController;
        fvc.managedObjectContext = self.managedObjectContext;
    }
}

@end
