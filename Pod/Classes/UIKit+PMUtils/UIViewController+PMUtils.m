//
//  UIViewController+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 9/26/14.
//
//

#import "UIViewController+PMUtils.h"
#import "UINavigationController+PMUtils.h"

@implementation UIViewController (PMUtils)

+ (NSString *) defaultStoryboardName
{
    return NSStringFromClass(self);
}

+ (UIStoryboard *) defaultStoryboard
{
    // Cache storyboards to prevent unnecessary filesystem access
    static NSCache *storyboards = nil;
    static dispatch_once_t cacheToken;
    dispatch_once(&cacheToken, ^{
        storyboards = [NSCache new];
    });
    
    NSString *storyboardName = [self defaultStoryboardName];
    UIStoryboard *storyboard = [storyboards objectForKey:storyboardName];
    if (!storyboard) {
        storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        [storyboards setObject:storyboard?:[NSNull null]  forKey:storyboardName];
    }
    else if ([storyboard isEqual:[NSNull null]]) {
        storyboard = nil;
    }
    return storyboard;
}

+ (instancetype) controllerFromDefaultStoryboard
{
    UIStoryboard *storyboard = [self defaultStoryboard];
    if (storyboard) {
        UIViewController *controller = [storyboard instantiateInitialViewController];
        NSAssert ([controller isKindOfClass:self],
                  @"Initial view controller in storyboard '%@' was '%@'. Expected '%@'", [self defaultStoryboard], controller, self);
        return controller;
    }
    return nil;
}

- (NSArray *) popNavigationControllerToSelfAnimated:(BOOL)animate completion:(void (^)(void))completion
{
    return [self.navigationController popToViewController:self animated:animate completion:completion];
}

@end
