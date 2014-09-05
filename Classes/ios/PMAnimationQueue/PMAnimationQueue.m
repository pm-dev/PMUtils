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
//  PMAnimationQueue.m
//  Created by Peter Meyers on 6/21/13.
//

#import "PMAnimationQueue.h"
#import "PMUtils.h"

@interface PMAnimationQueue ()

@property (nonatomic, strong) NSOperationQueue *animations;

@end

@implementation PMAnimationQueue


- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _animations = [NSOperationQueue new];
        _animations.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void) addAnimationWithDelay:(NSTimeInterval)delay
						  options:(UIViewAnimationOptions)options
					 preAnimation:(NSTimeInterval(^)())preAnimation
						animation:(void(^)())animation
					   completion:(void (^)(BOOL finished))completion
{
    /* If nothing is currently animating, start the animation.
     * If something is currently animating the passed in animation
     * will execute in the completion block of the current animation.
     */
    NSParameterAssert(animation);

    DEF_weak(self, weakSelf);
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSTimeInterval duration = 0.0;
		if (preAnimation) {
			duration = preAnimation();
        }
        
		if (duration <= 0.0) {
			if (animation) {
				animation();
            }
			if (completion) {
				completion(YES);
            }
		}
        else {
            DEF_strong(weakSelf, strongSelf);
            [strongSelf.animations setSuspended:YES];
            [UIView animateWithDuration:duration
                                  delay:delay
                                options:options
                             animations:animation
                             completion:^(BOOL finished) {
                                 DEF_strong(weakSelf, strongSelf);
                                 [strongSelf.animations setSuspended:NO];
                                 if(completion) {
                                     completion(finished);
                                 }
                             }];
        }
    }]
    
    [self.animations addOperationWithBlock:^{
        

    }];
}

- (NSUInteger) animationCount
{
	return self.animations.operationCount;
}

@end
