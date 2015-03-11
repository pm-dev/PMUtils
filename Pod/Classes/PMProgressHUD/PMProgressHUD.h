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

/**
 *  A new instance of a PMProgressHUD instantiated from the PMProgressHUD nib.
 *
 *  @return A new instance of PMProgressHUD
 */
+ (instancetype) progressHUD;

/**
 *  The state of the progressHUD. Setting the state to PMProgressHUDStatePending will
 *  animate the spinner, PMProgressHUDStateFailed will stop the spinner and PMProgressHUDStateCompleted
 *  will hide the spinner and show the check mark icon.
 */
@property (nonatomic) PMProgressHUDState progressHUDState;

/**
 *  The text to show to the right of the spinner.
 */
@property (nonatomic, copy) NSString *message;

/**
 *  If the reciever is not already in the view heirarchy, this method adds itself as a subview
 *  to the shared applications key window.
 *
 *  @param delay      A delay in seconds to wait before adding the receiver to the window.
 *  @param completion A block to run only after the reciever has been successfully added to the window.
 */
- (void) presentAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;

/**
 *  Removes the reciever from the view heirarchy.
 *
 *  @param delay      A delay in seconds to wait before removing the receiver from its superview
 *  @param completion A block to run only after the reciever has been successfully removed from its superview.
 */
- (void) dismissAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;

@end
