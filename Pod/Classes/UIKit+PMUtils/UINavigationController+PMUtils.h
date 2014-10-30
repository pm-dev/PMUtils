//
//  UINavigationController+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 10/16/14.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PMUtils)

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (UIViewController *) popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray *) popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray *) popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (UIViewController *) rootViewController;

@end
