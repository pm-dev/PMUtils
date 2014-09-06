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
//  PMAnimationOperation.m
//  Created by Peter Meyers on 9/5/14.
//
//

#import "PMAnimationOperation.h"

@implementation PMAnimationOperation
{
    BOOL _isExecuting;
    BOOL _isFinished;
}

- (instancetype) init
{
    return [self initWithDelay:0 duration:0 options:0 preAnimation:nil animation:^{} postAnimation:nil];
}

- (instancetype) initWithDelay:(NSTimeInterval)delay
                      duration:(NSTimeInterval)duration
                       options:(UIViewAnimationOptions)options
                  preAnimation:(PMPreAnimationBlock)preAnimation
                     animation:(PMAnimationBlock)animation
                 postAnimation:(PMPostAnimationBlock)postAnimation
{
    self = [super init];
    if (self) {
        self.delay = delay;
        self.duration = duration;
        self.options = options;
        self.preAnimation = preAnimation;
        self.animation = animation;
        self.postAnimation = postAnimation;
        self.queuePriority = NSOperationQueuePriorityVeryHigh;
    }
    return self;
}

+ (instancetype) animationWithDelay:(NSTimeInterval)delay
                           duration:(NSTimeInterval)duration
                            options:(UIViewAnimationOptions)options
                       preAnimation:(PMPreAnimationBlock)preAnimation
                          animation:(PMAnimationBlock)animation
                      postAnimation:(PMPostAnimationBlock)postAnimation
{
    return [[self alloc] initWithDelay:delay
                              duration:duration
                               options:options
                          preAnimation:preAnimation
                             animation:animation
                         postAnimation:postAnimation];
}


#pragma mark - Overridden Methods


- (void)main
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    if (self.preAnimation) {
        self.preAnimation(self);
    }
    
    if ((self.duration || self.delay) && self.animation) {
        [UIView animateWithDuration:self.duration
                              delay:self.delay
                            options:self.options
                         animations:self.animation
                         completion:^(BOOL finished) {
                             if (self.postAnimation) {
                                 self.postAnimation(finished);
                             }
                             [self willChangeValueForKey:@"isFinished"];
                             _isFinished = YES;
                             [self didChangeValueForKey:@"isFinished"];
                         }];
    }
    else {		
		if (self.animation) {
			self.animation();
		}
        if (self.postAnimation) {
            self.postAnimation(YES);
        }
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL) isExecuting
{
    return _isExecuting;
}

- (BOOL) isFinished
{
    return _isFinished;
}


#pragma mark - Public Methods


- (void) enqueue
{
    [[NSOperationQueue mainQueue] addOperation:self];
}


@end
