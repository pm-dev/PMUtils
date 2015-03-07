//
//  ViewController.m
//  PMInnerShadowView
//
//  Created by Peter Meyers on 3/7/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMInnerShadowView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PMInnerShadowView *innerShadowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.innerShadowView.cornerRadius = 4.0f;
    self.innerShadowView.shadowOffset = CGSizeZero;
    self.innerShadowView.shadowOpacity = 0.8f;
    self.innerShadowView.shadowRadius = 22.0f;
    self.innerShadowView.shadowColor = [UIColor redColor];
    self.innerShadowView.edges = UIRectEdgeLeft | UIRectEdgeRight;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
