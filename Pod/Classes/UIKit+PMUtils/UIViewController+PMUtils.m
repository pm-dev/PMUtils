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
