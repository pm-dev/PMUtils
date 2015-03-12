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
//  UINavigationController+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 10/16/14.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PMUtils)

/**
 *  The first view controller currently in the navigation stack.
 */
@property (nonatomic, strong, readonly) UINavigationController *rootViewController;


/**
 *  Replaces the view controllers currently managed by the navigation controller with the specified items.
 Use this method to update or replace the current view controller stack without pushing or popping each controller explicitly. In addition, this method lets you update the set of controllers without animating the changes, which might be appropriate at launch time when you want to return the navigation controller to a previous state.
 If animations are enabled, this method decides which type of transition to perform based on whether the last item in the items array is already in the navigation stack. If the view controller is currently in the stack, but is not the topmost item, this method uses a pop transition; if it is the topmost item, no transition is performed. If the view controller is not on the stack, this method uses a push transition. Only one transition is performed, but when that transition finishes, the entire contents of the stack are replaced with the new view controllers. For example, if controllers A, B, and C are on the stack and you set controllers D, A, and B, this method uses a pop transition and the resulting stack contains the controllers D, A, and B.
 *
 *  @param viewControllers The view controllers to place in the stack. The front-to-back order of the controllers in this array represents the new bottom-to-top order of the controllers in the navigation stack. Thus, the last item added to the array becomes the top item of the navigation stack.
 *  @param animated        If YES, animate the pushing or popping of the top view controller. If NO, replace the view controllers without any animations.
 *  @param completion      The block to execute after the update finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 */
- (void) setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  Pushes a view controller onto the receiver’s stack and updates the display.
 The object in the viewController parameter becomes the top view controller on the navigation stack. Pushing a view controller causes its view to be embedded in the navigation interface. If the animated parameter is YES, the view is animated into position; otherwise, the view is simply displayed in its final location.
 In addition to displaying the view associated with the new view controller at the top of the stack, this method also updates the navigation bar and tool bar accordingly. For information on how the navigation bar is updated, see Updating the Navigation Bar.
 *
 *  @param viewController The view controller to push onto the stack. This object cannot be a tab bar controller. If the view controller is already on the navigation stack, this method throws an exception.
 *  @param animated       Specify YES to animate the transition or NO if you do not want the transition to be animated. You might specify NO if you are setting up the navigation controller at launch time.
 *  @param completion     The block to execute after the push finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 */
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  Pops the top view controller from the navigation stack and updates the display.
 This method removes the top view controller from the stack and makes the new top of the stack the active view controller. If the view controller at the top of the stack is the root view controller, this method does nothing. In other words, you cannot pop the last item on the stack.
 In addition to displaying the view associated with the new view controller at the top of the stack, this method also updates the navigation bar and tool bar accordingly. For information on how the navigation bar is updated, see Updating the Navigation Bar.
 *
 *  @param animated   Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 *  @param completion The block to execute after the pop finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 *
 *  @return The view controller that was popped from the stack.
 */
- (UIViewController *) popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  Pops view controllers until the specified view controller is at the top of the navigation stack.
 For information on how the navigation bar is updated, see Updating the Navigation Bar.
 *
 *  @param viewController The view controller that you want to be at the top of the stack. This view controller must currently be on the navigation stack.
 *  @param animated       Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 *  @param completion     The block to execute after the pop finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 *
 *  @return An array containing the view controllers that were popped from the stack.
 */
- (NSArray *) popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *  Pops all the view controllers on the stack except the root view controller and updates the display.
 The root view controller becomes the top view controller. For information on how the navigation bar is updated, see Updating the Navigation Bar.
 *
 *  @param animated   Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 *  @param completion The block to execute after the pop finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 *
 *  @return An array containing the view controllers that were popped from the stack.
 */
- (NSArray *) popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
