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
+ (PMNavigationControllerCompletionDelegate *) delegateForController:(UINavigationController *)controller withCompletion:(void (^)(void))completion;
@end

@implementation UINavigationController (PMUtils)

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self PM_addNavigationControllerDelegate:completion];
    [self pushViewController:viewController animated:animated];
}

- (UIViewController *) popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self PM_addNavigationControllerDelegate:completion];
    return [self popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self PM_addNavigationControllerDelegate:completion];
    return [self popToRootViewControllerAnimated:animated];
}


#pragma mark - Private

- (void) PM_addNavigationControllerDelegate:(void (^)(void))completion
{
    PMNavigationControllerCompletionDelegate *delegate = [PMNavigationControllerCompletionDelegate delegateForController:self withCompletion:completion];
    [[UINavigationController PM_navigationControllerDelegates] addObject:delegate];
}

+ (NSMutableSet *) PM_navigationControllerDelegates
{
    static NSMutableSet *navigationControllerDelegates = nil;
    static dispatch_once_t cacheToken = 0;
    dispatch_once(&cacheToken, ^{
        navigationControllerDelegates = [NSMutableSet set];
    });
    return navigationControllerDelegates;
}

@end


@implementation PMNavigationControllerCompletionDelegate
{
    PMProtocolInterceptor *_interceptor;
    dispatch_block_t _completion;
    UINavigationController *_navigationController;
}

+ (PMNavigationControllerCompletionDelegate *) delegateForController:(UINavigationController *)controller withCompletion:(void (^)(void))completion
{
    return [[self alloc] initForController:controller withCompletion:completion];
}

- (instancetype) initForController:(UINavigationController *)controller withCompletion:(void (^)(void))completion
{
    self = [super init];
    if (self) {
        _interceptor = [PMProtocolInterceptor interceptorWithMiddleMan:self forProtocol:@protocol(UINavigationControllerDelegate)];
        _completion = [completion copy];
        _navigationController = controller;
        _interceptor.receiver = controller.delegate;
        controller.delegate = (id)_interceptor;
    }
    return self;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (_completion) {
        _completion();
    }
    _navigationController.delegate = _interceptor.receiver;
    if ([_navigationController.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [_navigationController.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    [[UINavigationController PM_navigationControllerDelegates] removeObject:self];
}

@end

