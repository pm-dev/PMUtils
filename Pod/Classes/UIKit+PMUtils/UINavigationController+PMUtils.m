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
//  UINavigationController+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 10/16/14.
//
//

#import "UINavigationController+PMUtils.h"
#import "objc/runtime.h"
#import "PMProtocolInterceptor.h"


@interface PMNavigationControllerCompletionDelegate : NSObject <UINavigationControllerDelegate>
@property (nonatomic, strong, readonly) NSMutableArray *completionQueue;
@property (nonatomic, strong, readonly) PMProtocolInterceptor *interceptor;
@end

@implementation UINavigationController (PMUtils)

- (UIViewController *) rootViewController
{
    return self.viewControllers.firstObject;
}

- (void) setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.viewControllers.lastObject == viewControllers.lastObject && completion) {
        [self setViewControllers:viewControllers animated:animated];
        completion();
    }
    else {
        if (completion) {
            [self PM_addNavigationControllerDelegate:completion];
        }
        [self setViewControllers:viewControllers animated:animated];
    }
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (completion) {
        [self PM_addNavigationControllerDelegate:completion];
    }
    [self pushViewController:viewController animated:animated];
}

- (UIViewController *) popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.viewControllers.count > 1) {
        if (completion) {
            [self PM_addNavigationControllerDelegate:completion];
        }
        return [self popViewControllerAnimated:animated];
    }
    else if (completion) {
        completion();
    }
    return nil;
}

- (NSArray *) popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index != NSNotFound && index < self.viewControllers.count - 1) {
        if (completion) {
            [self PM_addNavigationControllerDelegate:completion];
        }
        return [self popToViewController:viewController animated:animated];
    }
    else if (completion) {
        completion();
    }
    return nil;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.viewControllers.count > 1) {
        if (completion) {
            [self PM_addNavigationControllerDelegate:completion];
        }
        return [self popToRootViewControllerAnimated:animated];
    }
    else if (completion) {
        completion();
    }
    return nil;
}


#pragma mark - Private

- (void) PM_addNavigationControllerDelegate:(void (^)(void))completion
{
    PMNavigationControllerCompletionDelegate *delegate = [self PM_navigationControllerCompletionDelegate];
    if (!delegate) {
        delegate = [[PMNavigationControllerCompletionDelegate alloc] init];
        [self PM_setNavigationControllerCompletionDelegate:delegate];
    }
    if (self.delegate != delegate.interceptor) {
        delegate.interceptor.receiver = self.delegate;
        self.delegate = (id)delegate.interceptor;
    }
    [delegate.completionQueue addObject:[completion copy]];
}

- (PMNavigationControllerCompletionDelegate *)PM_navigationControllerCompletionDelegate {
    return (PMNavigationControllerCompletionDelegate *)objc_getAssociatedObject(self, @selector(PM_navigationControllerCompletionDelegate));
}

- (void)PM_setNavigationControllerCompletionDelegate:(PMNavigationControllerCompletionDelegate *)completionDelegate {
    objc_setAssociatedObject(self, @selector(PM_navigationControllerCompletionDelegate), completionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation PMNavigationControllerCompletionDelegate

- (instancetype) init
{
    self = [super init];
    if (self) {
        _interceptor = [PMProtocolInterceptor interceptorWithMiddleMan:self forProtocol:@protocol(UINavigationControllerDelegate)];
        _completionQueue = [@[] mutableCopy];
    }
    return self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.delegate = self.interceptor.receiver;
    if ([navigationController.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [navigationController.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    
    if (_completionQueue.count) {
        dispatch_block_t completion = _completionQueue.firstObject;
        [_completionQueue removeObjectAtIndex:0];
        completion();
    }
    if (_completionQueue.count) {
        navigationController.delegate = (id)self.interceptor;
    }
    else {
        [navigationController PM_setNavigationControllerCompletionDelegate:nil];
    }
}

@end

