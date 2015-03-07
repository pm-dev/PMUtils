//
//  ViewController.m
//  PMRoundedBorderView
//
//  Created by Peter Meyers on 3/7/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMRoundedBorderView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PMRoundedBorderView *topView;
@property (weak, nonatomic) IBOutlet PMRoundedBorderView *bottomView;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.cornerRadii = CGSizeMake(10.0f, 10.0f);
    self.bottomView.cornerRadii = CGSizeMake(10.0f, 10.0f);
    
    self.topView.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    self.bottomView.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    
    self.topView.borderWidth = 2.0f;
    self.bottomView.borderWidth = 2.0f;
    
    self.topView.borderColor = [UIColor blackColor];
    self.bottomView.borderColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
