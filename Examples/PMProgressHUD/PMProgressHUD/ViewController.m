//
//  ViewController.m
//  PMProgressHUD
//
//  Created by Peter Meyers on 3/7/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController
{
    PMProgressHUD *_HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _HUD = [PMProgressHUD progressHUD];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    sleep(4.0);
    [self connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) connect {
    _HUD.message = @"Connecting...";
    _HUD.progressHUDState = PMProgressHUDStatePending;
    [_HUD presentAfterDelay:0.0 completion:nil];
    [self performSelector:@selector(failed) withObject:nil afterDelay:3.0];
}

- (void) failed {
    _HUD.message = @"Failed.";
    _HUD.progressHUDState = PMProgressHUDStateFailed;
    [self performSelector:@selector(tryAgain) withObject:nil afterDelay:3.0];
}

- (void) tryAgain {
    _HUD.message = @"Trying Again...";
    _HUD.progressHUDState = PMProgressHUDStatePending;
    [self performSelector:@selector(complete) withObject:nil afterDelay:3.0];
}

- (void) complete {
    _HUD.message = @"Complete!";
    _HUD.progressHUDState = PMProgressHUDStateComplete;
    [_HUD dismissAfterDelay:2.0 completion:nil];
}

@end
