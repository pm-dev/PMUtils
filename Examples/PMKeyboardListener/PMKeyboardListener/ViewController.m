//
//  ViewController.m
//  PMKeyboardListener
//
//  Created by Peter Meyers on 3/7/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMKeyboardListener.h"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PMKeyboardListener startListening];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"Will Show. Keybaord State: %@", @([PMKeyboardListener keyboardState]).stringValue);
    NSLog(@"Will Show. Keyboard Rect: %@", NSStringFromCGRect([PMKeyboardListener keyboardFrame]));
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"Will Hide. Keybaord State: %@", @([PMKeyboardListener keyboardState]).stringValue);
    NSLog(@"Will Hide. Keyboard Rect: %@", NSStringFromCGRect([PMKeyboardListener keyboardFrame]));
    return YES;
}

- (IBAction)didTapDismiss:(id)sender {
    [self.view endEditing:YES];
}

@end
