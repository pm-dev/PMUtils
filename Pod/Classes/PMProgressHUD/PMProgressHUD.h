//
//  SpinnerViewController.h
//  OperatorIOS
//
//  Created by Peter Meyers on 10/15/14.
//  Copyright (c) 2014 Operator. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PMProgressHUDState)
{
    PMProgressHUDStatePending,
    PMProgressHUDStateComplete,
    PMProgressHUDStateFailed
};

@interface PMProgressHUD : UIView

+ (instancetype) progressHUD;

@property (nonatomic) PMProgressHUDState progressHUDState;
@property (nonatomic, copy) NSString *message;

- (void) presentAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;
- (void) dismissAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;

@end
