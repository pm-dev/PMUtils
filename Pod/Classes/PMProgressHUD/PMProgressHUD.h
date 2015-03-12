// Copyright (c) 2013-2014 Peter Meyers
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//
//  Created by Peter Meyers on 10/15/14.
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
