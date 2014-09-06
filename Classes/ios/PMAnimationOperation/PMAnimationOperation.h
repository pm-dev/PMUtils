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
//  PMAnimationOperation.h
//  Created by Peter Meyers on 9/5/14.
//
//

#import <UIKit/UIKit.h>

@class PMAnimationOperation;

typedef void(^PMPreAnimationBlock)(PMAnimationOperation *operation);
typedef void(^PMAnimationBlock)();
typedef void(^PMPostAnimationBlock)(BOOL finished);

@interface PMAnimationOperation : NSOperation

@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) UIViewAnimationOptions options;
@property (nonatomic, copy) PMPreAnimationBlock preAnimation;
@property (nonatomic, copy) PMAnimationBlock animation;
@property (nonatomic, copy) PMPostAnimationBlock postAnimation;

- (instancetype) initWithDelay:(NSTimeInterval)delay
                      duration:(NSTimeInterval)duration
                       options:(UIViewAnimationOptions)options
                  preAnimation:(PMPreAnimationBlock)preAnimation
                     animation:(PMAnimationBlock)animation
                 postAnimation:(PMPostAnimationBlock)postAnimation;

+ (instancetype) animationWithDelay:(NSTimeInterval)delay
                           duration:(NSTimeInterval)duration
                            options:(UIViewAnimationOptions)options
                       preAnimation:(PMPreAnimationBlock)preAnimation
                          animation:(PMAnimationBlock)animation
                      postAnimation:(PMPostAnimationBlock)postAnimation;

- (void) enqueue;

@end
