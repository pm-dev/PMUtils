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

/**
 *  The amount of time (measured in seconds) to wait before beginning the animations. A value of 0 
 *	will begin the animations immediately.
 */
@property (nonatomic) NSTimeInterval delay;

/**
 *  The total duration of the animations, measured in seconds. If you specify a negative value 
 *  or 0, the changes are made without animating them.
 */
@property (nonatomic) NSTimeInterval duration;

/**
 *  A mask of options indicating how you want to perform the animations. 
 *	For a list of valid constants, see UIViewAnimationOptions.
 */
@property (nonatomic) UIViewAnimationOptions options;

/**
 *  A block object to be executed before the animation sequence begins. This block has no return value
 *	and takes a single argument which is the object representing the current PMAnimationOperation. Because
 *	state may have changed by the time this operation begins executing, this block gives your application a chance
 *	to update any of its other properties.
 */
@property (nonatomic, copy) PMPreAnimationBlock preAnimation;

/**
 *  A block object containing the changes to commit to the views. This is where you programmatically change 
 *	any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value.
 *	If delay AND duration is 0 this block is performed immediately after the pre animation block is performed.
 */
@property (nonatomic, copy) PMAnimationBlock animation;

/**
 *  A block object to be executed when the animation sequence ends. This block has no return value
 *	and takes a single Boolean argument that indicates whether or not the animations actually finished before
 *	the completion handler was called. If delay AND duration is 0 this block is performed immediately after
 *	the animation block is performed, otherwise this block is performed at the beginning of the next run loop cycle.
 */
@property (nonatomic, copy) PMPostAnimationBlock postAnimation;


/**
 *  The designated initializer for creating a PMAnimationOperation.
 *
 *  @param delay         The amount of time (measured in seconds) to wait before beginning the animations. A value of 0
 *	will begin the animations immediately.
 *  @param duration      The total duration of the animations, measured in seconds. If you specify a negative value
 *  or 0, the changes are made without animating them.
 *  @param options       A mask of options indicating how you want to perform the animations.
 *	For a list of valid constants, see UIViewAnimationOptions.
 *  @param preAnimation  A block object to be executed before the animation sequence begins. This block has no return value
 *	and takes a single argument which is the object representing the current PMAnimationOperation. Because
 *	state may have changed by the time this operation begins executing, this block gives your application a chance
 *	to update any of its other properties.
 *  @param animation     A block object containing the changes to commit to the views. This is where you programmatically change
 *	any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value.
 *	If delay AND duration is 0 this block is performed immediately after the pre animation block is performed.
 *  @param postAnimation A block object to be executed when the animation sequence ends. This block has no return value
 *	and takes a single Boolean argument that indicates whether or not the animations actually finished before
 *	the completion handler was called. If delay AND duration is 0 this block is performed immediately after
 *	the animation block is performed, otherwise this block is performed at the beginning of the next run loop cycle.
 *
 *  @return The initialized PMAnimationOperation object.
 */
- (instancetype) initWithDelay:(NSTimeInterval)delay
                      duration:(NSTimeInterval)duration
                       options:(UIViewAnimationOptions)options
                  preAnimation:(PMPreAnimationBlock)preAnimation
                     animation:(PMAnimationBlock)animation
                 postAnimation:(PMPostAnimationBlock)postAnimation;
/**
 *  Returns an PMAnimationOperation instance.
 *
 *  @param delay         The amount of time (measured in seconds) to wait before beginning the animations. A value of 0
 *	will begin the animations immediately.
 *  @param duration      The total duration of the animations, measured in seconds. If you specify a negative value
 *  or 0, the changes are made without animating them.
 *  @param options       A mask of options indicating how you want to perform the animations.
 *	For a list of valid constants, see UIViewAnimationOptions.
 *  @param preAnimation  A block object to be executed before the animation sequence begins. This block has no return value
 *	and takes a single argument which is the object representing the current PMAnimationOperation. Because
 *	state may have changed by the time this operation begins executing, this block gives your application a chance
 *	to update any of its other properties.
 *  @param animation     A block object containing the changes to commit to the views. This is where you programmatically change
 *	any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value.
 *	If delay AND duration is 0 this block is performed immediately after the pre animation block is performed.
 *  @param postAnimation A block object to be executed when the animation sequence ends. This block has no return value
 *	and takes a single Boolean argument that indicates whether or not the animations actually finished before
 *	the completion handler was called. If delay AND duration is 0 this block is performed immediately after
 *	the animation block is performed, otherwise this block is performed at the beginning of the next run loop cycle.
 *
 *  @return An initialized PMAnimationOperation object.
 */
+ (instancetype) animationWithDelay:(NSTimeInterval)delay
                           duration:(NSTimeInterval)duration
                            options:(UIViewAnimationOptions)options
                       preAnimation:(PMPreAnimationBlock)preAnimation
                          animation:(PMAnimationBlock)animation
                      postAnimation:(PMPostAnimationBlock)postAnimation;

/**
 *  Adds the reciever to the operation queue associated with the main thread. Once added, the receiver remains in
 *	the queue until it finishes executing. The receiver should only ever be added to the main queue, so use this
 *	method to enqueue PMAnimationOperation instances. This method throws an NSInvalidArgumentException exception if
 *	the operation is currently executing or has already finished executing.
 */
- (void) enqueue;

@end
