//
//  AddCardViewController.m
//  PizzaShack
//
//  Created by John Blanchard on 9/16/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

#import "AddCardViewController.h"
#import "WalletViewController.h"
#import "Payment.h"

@interface AddCardViewController () <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardHolder;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *datePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property NSArray* months;
@property NSArray* years;
@property UIActionSheet* sheet;
@property UIPickerView* picker;
@property NSDate* expiration;
@end

@implementation AddCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateView];
}

- (void)populateView
{
    UIColor *color = GREENCOLOR;
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.cardNumber.textColor = color;
    self.cardHolder.textColor = color;
    self.cardNumber.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Card Number"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.cardHolder.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Card Holder"
     attributes:@{NSForegroundColorAttributeName:color}];
    self.phoneNumber.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Only if there is a problem with an order."
     attributes:@{NSForegroundColorAttributeName:color}];
    self.view.backgroundColor = DARKBAYCOLOR;
    self.cardHolder.backgroundColor = BAYCOLOR;
    self.cardNumber.backgroundColor = BAYCOLOR;
    self.phoneNumber.backgroundColor = BAYCOLOR;
    self.datePickerButton.titleLabel.textColor = BAYCOLOR;
    self.addCardButton.titleLabel.textColor = BAYCOLOR;
    self.datePickerButton.backgroundColor = REDCOLOR;
    self.addCardButton.backgroundColor = REDCOLOR;
    self.datePickerButton.clipsToBounds = YES;
    self.datePickerButton.layer.cornerRadius = 10;
    self.addCardButton.clipsToBounds = YES;
    self.addCardButton.layer.cornerRadius = 10;
    self.months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    self.years = @[@"2014", @"2015", @"2016", @"2017", @"2018", @"2019", @"2020", @"2021", @"2022", @"2023", @"2024", @"2025", @"2026", @"2027", @"2028", @"2029", @"2030", @"2031", @"2032", @"2033"];
}

- (IBAction)datePickerButtonPressed:(id)sender
{
    [self.cardHolder resignFirstResponder];
    [self.cardNumber resignFirstResponder];
    self.sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:@"" otherButtonTitles: nil];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 68, 320, 320)];
    self.picker.backgroundColor = BAYCOLOR;
    self.picker.showsSelectionIndicator=YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
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
    lblPickerTitle.text=@"Provide expiration date";
    lblPickerTitle.backgroundColor=[UIColor clearColor];
    lblPickerTitle.textColor=[UIColor blackColor];
    lblPickerTitle.textAlignment=NSTextAlignmentCenter;
    lblPickerTitle.font=[UIFont boldSystemFontOfSize:18];
    [tools addSubview:lblPickerTitle];
    [self.sheet showFromRect:CGRectMake(0,480, 320,225) inView:self.view animated:YES];
    [self.sheet setBounds:CGRectMake(0,0, 320, 431)];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component < 1) {
        return self.months.count;
    } else {
        return self.years.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component < 1) {
        return [self.months objectAtIndex:row];
    } else {
        return [self.years objectAtIndex:row];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component < 1) {
        return 180;
    } else {
        return 140;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.datePickerButton.titleLabel.textColor = BAYCOLOR;
    self.addCardButton.titleLabel.textColor = BAYCOLOR;
    [actionSheet resignFirstResponder];
}

-(void) btnActinDoneClicked
{
    [self.sheet dismissWithClickedButtonIndex:0 animated:YES];
    NSString* month = [self.months objectAtIndex:[self.picker selectedRowInComponent:0]];
    NSString* year = [self.years objectAtIndex:[self.picker selectedRowInComponent:1]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    [components setMonth:[self.picker selectedRowInComponent:0]];
    [components setYear:[self.picker selectedRowInComponent:1]];
    self.expiration = [calendar dateFromComponents:components];
    [self.datePickerButton setTitle:[NSString stringWithFormat:@"%@, %@", month, year] forState:UIControlStateNormal];
    self.datePickerButton.titleLabel.textColor = BAYCOLOR;
    self.addCardButton.titleLabel.textColor = BAYCOLOR;
    self.datePickerButton.backgroundColor = REDCOLOR;
    self.addCardButton.backgroundColor = REDCOLOR;
}

- (IBAction)addCardButton:(id)sender
{
    if ([self checkValidCard]) {
        Payment* payment = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.managedObjectContext];
        payment.cardNumber = self.cardNumber.text;
        payment.holder = self.cardHolder.text;
        payment.expDate = self.expiration;
        [self.managedObjectContext save:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Please enter information about your card." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.datePickerButton.titleLabel.textColor = BAYCOLOR;
    self.addCardButton.titleLabel.textColor = BAYCOLOR;
}

-(BOOL) checkValidCard
{
    if ([self.cardNumber.text isEqualToString:@""] || [self.cardHolder.text isEqualToString:@""] || [self.datePickerButton.titleLabel.text isEqualToString:@"Expiration Date"]) {
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)doneEditing:(UITextField *)sender
{
    [sender resignFirstResponder];
}

- (IBAction)menuButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[WalletViewController class]]) {
        WalletViewController* wvc = segue.destinationViewController;
        wvc.managedObjectContext = self.managedObjectContext;
    }
}

@end
