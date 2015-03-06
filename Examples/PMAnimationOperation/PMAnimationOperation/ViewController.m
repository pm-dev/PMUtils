//
//  ViewController.m
//  PMAnimationOperation
//
//  Created by Peter Meyers on 3/6/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMAnimationOperation.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIView *_block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _block = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    _block.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_block];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (NSUInteger i = 1; i <= 2; i++) {
        [[PMAnimationOperation animationWithDelay:0.0
                                         duration:i
                                          options:UIViewAnimationOptionCurveLinear
                                     preAnimation:^(PMAnimationOperation *operation) {
                                         _block.backgroundColor = [UIColor redColor];
                                     } animation:^{
                                         _block.frame = CGRectMake(0.0, self.view.bounds.size.height - 50.0f, 50.0, 50.0f);
                                     } postAnimation:^(BOOL finished) {
                                         NSLog(@"Completed animation 1");
                                     }] enqueue];
        
        [[PMAnimationOperation animationWithDelay:0.0
                                         duration:i * 2.0
                                          options:UIViewAnimationOptionCurveLinear
                                     preAnimation:^(PMAnimationOperation *operation) {
                                         _block.backgroundColor = [UIColor greenColor];
                                     } animation:^{
                                         _block.frame = CGRectMake(self.view.bounds.size.width - 50.0f, self.view.bounds.size.height - 50.0f, 50.0, 50.0f);
                                     } postAnimation:^(BOOL finished) {
                                         NSLog(@"Completed animation 2");
                                     }] enqueue];
        
        [[PMAnimationOperation animationWithDelay:0.0
                                         duration:i * 3.0
                                          options:UIViewAnimationOptionCurveLinear
                                     preAnimation:^(PMAnimationOperation *operation) {
                                         _block.backgroundColor = [UIColor blueColor];
                                     } animation:^{
                                         _block.frame = CGRectMake(self.view.bounds.size.width - 50.0f, 0.0, 50.0, 50.0f);
                                     } postAnimation:^(BOOL finished) {
                                         NSLog(@"Completed animation 3");
                                     }] enqueue];
        
        [[PMAnimationOperation animationWithDelay:0.0
                                         duration:i * 4.0
                                          options:UIViewAnimationOptionCurveLinear
                                     preAnimation:^(PMAnimationOperation *operation) {
                                         _block.backgroundColor = [UIColor purpleColor];
                                     } animation:^{
                                         _block.frame = CGRectMake(0.0, 0.0, 50.0, 50.0f);
                                     } postAnimation:^(BOOL finished) {
                                         NSLog(@"Completed animation 4");
                                     }] enqueue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
