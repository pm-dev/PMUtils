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
//  UICollectionView+PMUtils.h
//  Created by Peter Meyers on 3/21/14.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (PMUtils)

/**
 *  This method finds the index path of the item whose frame is closest to a
 *	point specified relative to the content view. 
 *
 *	@param point A point relative to coordinates of the content view.
 *
 *  @return The index path of the item closest to the specified point. If there are no items or the content size is CGSizeZero, nil is returned.
 */
- (NSIndexPath *) indexPathNearestToPoint:(CGPoint)point;

/**
 *  This property returns the index path of the item whose frame is closest to the center of the rect returned by -[self visibleRect].
 *
 *	@see -[self visibleRect]
 *  @return The index path of the item closest to the center of the currently visible content. 
 *	If there are no items or the content size is CGSizeZero, nil is returned.
 */
@property (nonatomic, copy, readonly) NSIndexPath *indexPathNearestToBoundsCenter;

/**
 *  Reloads just the items at visible index paths. Call this method to selectively reload only items at currently visable index paths.
 */
- (void) reloadVisibleItems;

/**
 *  Scrolls the content offset of the reciever so that the top left corner of the content is visible.
 *
 *  @param animated YES if the scrolling should be animated, NO if it should be immediate.
 */
- (void) scrollToTopAnimated:(BOOL)animated;

/**
 *  Scrolls the content offset of the reciever so that the bottom right corner of the content is visible.
 *
 *  @param animated YES if the scrolling should be animated, NO if it should be immediate.
 */
- (void) scrollToBottomAnimated:(BOOL)animated;

@end
