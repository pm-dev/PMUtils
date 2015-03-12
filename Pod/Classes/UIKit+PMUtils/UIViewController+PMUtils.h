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
//  UIViewController+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 9/26/14.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (PMUtils)

/**
 *  The default storyboard name is simply the name of the class. Override this method to change the default storyboard name.
 *
 *  @return The default name of the storyboard, which defaults to the name of the receiver's class.
 */
+ (NSString *) defaultStoryboardName;

/**
 *  Creates and returns a storyboard object for the specified storyboard file in the main bundle with the
 *  name from +[UIViewController defaultStoryboardName].
 *
 *  @return The initialized UIStoryboard object or nil if there were errors during initialization or the storyboard file could not be located.
 */
+ (UIStoryboard *) defaultStoryboard;

/**
 *  Instantiates and returns the initial view controller of [UIViewController defaultStoryboard]. Every storyboard file 
 *  must have an initial view controller that represents the starting point for the corresponding user interface. This method
 *  creates a new instance of the reciever each time you call it.
 *
 *  @return An instance of the initial view controller in the default storyboard file.
 */
+ (instancetype) controllerFromDefaultStoryboard;

/**
 *  Pops view controllers from the reciever's navigation controller until the receiver is at the top of the navigation stack. For information on how the navigation bar is updated, see Updating the Navigation Bar.
 *
 *  @param animate    Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 *
 *  @param completion The block to execute after the pop finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
 *
 *  @return An array containing the view controllers that were popped from the stack.
 */
- (NSArray *) popNavigationControllerToSelfAnimated:(BOOL)animate completion:(void (^)(void))completion;

@end
