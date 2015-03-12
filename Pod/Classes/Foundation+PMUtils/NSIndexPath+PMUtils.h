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
//  NSIndexPath+PMUtils.h
//  Created by Peter Meyers on 3/2/14.


#import <Foundation/Foundation.h>


extern NSInteger PMShortestCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange);
extern NSInteger PMReverseCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange);
extern NSInteger PMForwardCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange);

@interface NSIndexPath (PMUtils)

/**
 *  A copy of the receiver with the index at position 0 ommitted.
 */
@property (nonatomic, copy, readonly) NSIndexPath *indexPathByRemovingFirstIndex;

/**
 *  Creates a copy of the receiver and inserts an index at position 0. The current indexes' positions are incremented by 1.
 *
 *	@param index The index to append at position 0.
 *
 *  @return A new index path with index appended at position 0.
 */
- (NSIndexPath *) indexPathByAddingFirstIndex:(NSUInteger)index;

/**
 *  Creates a copy of the receiver, deletes the last index from the path, then appends a new index.
 *
 *	@param index The index that will replace the currently last position's index.
 *
 *  @return A new index path.
 */
- (NSIndexPath *) indexPathByReplacingLastIndex:(NSUInteger)index;

/**
 *  Creates a copy of the receiver, deletes the index at position 0, then inserts a new index at position 0.
 *
 *	@param index The index that will replace the currently first position's index.
 *
 *  @return A new index path.
 */
- (NSIndexPath *) indexPathByReplacingFirstIndex:(NSUInteger)index;

@end
