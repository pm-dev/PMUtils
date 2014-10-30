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
//  NSThread+PMUtils.h
//  Created by Peter Meyers on 3/2/14.
//
//

#import <Foundation/Foundation.h>

@interface NSThread (PMUtils)


/**
 *  Executes a block on the main thread. If this method is called from the main thread, the block is synchronously executed.
 *	If this method is called off the main thread, the block is asynchronously dispatched to the main queue.
 *	
 *	@param block The block to execute on the main thread. This parameter cannot be NULL.
 */
+ (void) dispatchMainThread:(void (^)(void))block;

/**
 *  Executes a block on the main thread. If this method is called from the main thread with delay set to 0, the block is synchronously executed.
 *	If this method is called off the main thread or delay is greater than zero, the block is asynchronously dispatched to the main queue.
 *
 *  @param delay The amount of time in seconds to delay before executing block.
 *  @param block The block to execute on the main thread. This parameter cannot be NULL.
 */
+ (void) dispatchMainThreadAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block;

/**
 *  Executes a block off the main thread. If this method is called off the main thread, the block is synchronously executed on the current thread.
 *	If this method is called on the main thread, the block is asynchronously dispatched to the global concurrent queue with default priority.
 *
 *	@param block The block to execute off the main thread. This parameter cannot be NULL.
 *  @see +[NSThread dispatchBackgroundThread:priority:]
 */
+ (void) dispatchBackgroundThread:(void (^)(void))block;

/**
 *  Executes a block off the main thread. If this method is called off the main thread, the block is synchronously executed on the current thread.
 *	If this method is called on the main thread, the block is asynchronously dispatched to a well-known global concurrent queue of a given priority level.
 *
 *  @param block    The block to execute off the main thread. This parameter cannot be NULL.
 *  @param priority The priority of the queue on which to execute the block.
 */
+ (void) dispatchBackgroundThread:(void (^)(void))block priority:(dispatch_queue_priority_t)priority;

/**
 *  Returns an object associated with the thread this method was called from. If no object exists with the specified name,
 *	optionally create the object with a supplied block.
 *
 *	@param name The name of the object.
 *
 *	@param creationBlock An optional block used to create an object to store on the current thread.
 */
+ (id) objectForCurrentThreadWithName:(NSString *)name creationBlock:(id (^)(void))creationBlock;

@end
