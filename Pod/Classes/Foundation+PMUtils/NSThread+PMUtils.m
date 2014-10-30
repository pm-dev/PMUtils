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
//  NSThread+PMUtils.m
//  Created by Peter Meyers on 3/2/14.
//
//

#import "NSThread+PMUtils.h"

@implementation NSThread (PMUtils)

+ (void) dispatchMainThread:(void (^)(void))block
{
    [self dispatchMainThreadAfterDelay:0.0 block:block];
}

+ (void) dispatchMainThreadAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block
{
    if (block) {
        if (delay > 0.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), block);
        }
        else if ([NSThread isMainThread]) {
            block();
        }
        else {
           dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

+ (void) dispatchBackgroundThread:(void (^)(void))block
{
    [self dispatchBackgroundThread:block priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

+ (void) dispatchBackgroundThread:(void (^)(void))block priority:(dispatch_queue_priority_t)priority
{
	if (block) {
		if (![NSThread isMainThread]) {
			block();
		}
		else {
			dispatch_async(dispatch_get_global_queue(priority, 0), block);
		}
	}
}

+ (id) objectForCurrentThreadWithName:(NSString *)name creationBlock:(id (^)(void))creationBlock
{
    NSMutableDictionary *dict = [[self currentThread] threadDictionary];
    id obj = dict[name];
	
	if (!obj && creationBlock) {
		obj = creationBlock();
		if (obj) {
			dict[name] = obj;
        }
	}
	return obj;
}

@end
