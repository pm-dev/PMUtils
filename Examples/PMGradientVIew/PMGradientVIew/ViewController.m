//
//  ViewController.m
//  PMGradientView
//
//  Created by Peter Meyers on 3/6/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMGradientView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PMGradientView *gradientView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gradientView.startColor = [UIColor blueColor];
    self.gradientView.endColor = [UIColor redColor];
    self.gradientView.startPoint = CGPointMake(0.0f, 0.0f);
    self.gradientView.endPoint = CGPointMake(1.0f, 1.0f);
    self.gradientView.locations = @[@0.1, @0.9];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
