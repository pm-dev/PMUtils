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

- (NSArray *) popNavigationControllerToSelfAnimated:(BOOL)animate completion:(void (^)(void))completion;

@end
