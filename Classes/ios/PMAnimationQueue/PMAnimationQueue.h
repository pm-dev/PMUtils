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
//  PMAnimationQueue.h
//  Created by Peter Meyers on 6/21/13.
//

#import <Foundation/Foundation.h>

@interface PMAnimationQueue : NSObject

/**
 *  Returns the number of animations currently in the queue. The value returned by this method reflects the instantaneous number of animations
 *  enqueued and changes as animations are completed. As a result, by the time you use the returned value, the actual number of animations may be different. 
 *  You should therefore use this value only for approximate guidance and should not rely on it for enumerations or other precise calculations.
 *
 *  @return The number of animations in the queue.
 */
- (NSUInteger) animationCount;

/**
 *  Animate changes to one or more views using the specified delay, preanimation, delay, options, and completion handler.
 *  During an animation, user interactions are temporarily disabled for the views being animated. (Prior to iOS 5, user interactions 
 *  are disabled for the entire application.) If you want users to be able to interact with the views, include the 
 *  UIViewAnimationOptionAllowUserInteraction constant in the options parameter. The duration of the animation is returned by the preAnimation block. If that
 *  duration is 0, the animation block runs immediately, followed by the completion block.
 *
 *  @param delay        The amount of time (measured in seconds) to wait after the preAnimation completes but before the main animation begins.
 *  @param options      A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.
 *  @param preAnimation Because state may have changed between the time the animation is enqueued and when it executes, use this block to compute the duration of
 *  the main animation and perform any other necessary setup. If this parameter is NULL, the animation duration will default to zero.
 *  @param animation    A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of
 *  the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be NULL.
 *  @param completion   A block object to be executed when the animation sequence ends, but before this animation is removed from the queue. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be NULL.
 */
- (void) addAnimationWithDelay:(NSTimeInterval)delay
                       options:(UIViewAnimationOptions)options
                  preAnimation:(NSTimeInterval(^)())preAnimation
                     animation:(void(^)())animation
                    completion:(void (^)(BOOL finished))completion;

@end
