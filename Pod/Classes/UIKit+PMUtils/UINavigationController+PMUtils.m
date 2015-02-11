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
@property (nonatomic, copy) dispatch_block_t completion;
@property (nonatomic, strong, readonly) PMProtocolInterceptor *interceptor;
@end

@implementation UINavigationController (PMUtils)


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

- (UIViewController *) rootViewController
{
    return self.viewControllers.firstObject;
}


#pragma mark - Private

- (void) PM_addNavigationControllerDelegate:(void (^)(void))completion
{
    PMNavigationControllerCompletionDelegate *existingDelegate = [self PM_navigationControllerCompletionDelegate];
    if (existingDelegate.completion) {
        existingDelegate.completion();
    }
    PMNavigationControllerCompletionDelegate *delegate = [[PMNavigationControllerCompletionDelegate alloc] init];
    delegate.interceptor.receiver = existingDelegate.interceptor.receiver?: self.delegate;
    self.delegate = (id)delegate.interceptor;
    delegate.completion = completion;
    [self PM_setNavigationControllerCompletionDelegate:delegate];
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
    }
    return self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.completion) {
        self.completion();
    }
    navigationController.delegate = self.interceptor.receiver;
    if ([navigationController.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [navigationController.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    
    [navigationController PM_setNavigationControllerCompletionDelegate:nil];
}

@end

