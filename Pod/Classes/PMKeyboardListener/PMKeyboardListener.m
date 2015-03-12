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
