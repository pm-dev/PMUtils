//
//  ViewController.m
//  PMPlaceholderTextView
//
//  Created by Peter Meyers on 3/6/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMPlaceholderTextView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PMPlaceholderTextView *placeholderTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.placeholderTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Description"
                                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor redColor],
                                                                                                  NSFontAttributeName: [UIFont systemFontOfSize:16.0f]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
