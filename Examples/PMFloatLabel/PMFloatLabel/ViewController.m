//
//  ViewController.m
//  PMFloatLabel
//
//  Created by Peter Meyers on 3/6/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMFloatTextField.h"


@interface ViewController () <PMFloatTextFieldDelegate, UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - PMFloatTextFieldDelegate


- (BOOL) floatTextField:(PMFloatTextField *)floatTextField shouldShowFloatLabelWithText:(BOOL)isText editing:(BOOL)isEditing
{
    return isText;
}

- (CGFloat) floatTextField:(PMFloatTextField *)floatTextField floatLabelVerticalSpacing:(BOOL)isEditing
{
    return 6.0f;
}

- (NSAttributedString *) floatTextField:(PMFloatTextField *)floatTextField floatLabelAttributedString:(BOOL)isEditing
{
    UIColor *color = isEditing? [UIColor colorWithRed:0.5f green:0.5f blue:0.9f alpha:1.0f] : [UIColor colorWithWhite:0.0f alpha:1.0f];
    return [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
}

@end
