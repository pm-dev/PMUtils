//
//  PMKeyboardListener.m
//  Pods
//
//  Created by Peter Meyers on 10/21/14.
//
//

#import "PMKeyboardListener.h"

@interface PMKeyboardListener ()
@property (nonatomic) CGRect keyboardFrame;
@property (nonatomic) PMKeyboardState keyboardState;
@end

@implementation PMKeyboardListener

+ (PMKeyboardListener *)shared
{
    static PMKeyboardListener* shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[PMKeyboardListener alloc] init];
    });
    return shared;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(willShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(didShow:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(willChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [center addObserver:self selector:@selector(willHide:) name:UIKeyboardWillHideNotification object:nil];
        [center addObserver:self selector:@selector(didHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

+ (void) startListening
{
    [self shared];
}

+ (PMKeyboardState) keyboardState
{
    return [self shared].keyboardState;
}

+ (CGRect) keyboardFrame
{
    return [self shared].keyboardFrame;
}

- (void)willChangeFrame:(NSNotification *)notification
{
    NSValue *endFrame = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrame = endFrame.CGRectValue;
}

- (void)willShow:(NSNotification *)notification
{
    NSValue *endFrame = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrame = endFrame.CGRectValue;
    self.keyboardState = PMKeyboardStateAppearing;
}

- (void)didShow:(NSNotification *)notification
{
    self.keyboardState = PMKeyboardStateVisible;
}

- (void)willHide:(NSNotification *)notification
{
    NSValue *endFrame = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrame = endFrame.CGRectValue;
    self.keyboardState = PMKeyboardStateDisappearing;
}

- (void)didHide:(NSNotification *)notification
{
    self.keyboardState = PMKeyboardStateHidden;
}

@end
