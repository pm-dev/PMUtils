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
 *  This method finds the index path of the item whose frame is closest to the center of the rect returned by -[self visibleRect].
 *
 *	@see -[self visibleRect]
 *  @return The index path of the item closest to the center of the currently visible content. 
 *	If there are no items or the content size is CGSizeZero, nil is returned.
 */
- (NSIndexPath *) indexPathNearestToBoundsCenter;

/**
 *  Calculates the content offset if the supplied rect was centered within the currently visible rect.
 *
 *	@param rect A rect to base the contentOffset of off, if the rect was centered in the visible rect.
 *
 *  @return The point at which the origin of the content view is offset from the origin of the scroll view if rect was
 *	centered within the scroll view.
 */
- (CGPoint) contentOffsetForCenteredRect:(CGRect)rect;

/**
 *  Calculates the content offset at the center of the the bounds
 *
 *  @return The point at which the origin of the content view is offset from the center of the scroll view.
 */
- (CGPoint) contentOffsetInBoundsCenter;

/**
 *  Calculates the rect of the content view currently visible within the bounds of the scroll view.
 *
 *  @return The rect of the content view currently visible within the bounds of the scroll view.
 */
- (CGRect) visibleRect;

/**
 *  Reloads just the items at visible index paths. Call this method to selectively reload only items at currently visable index paths.
 */
- (void) reloadVisibleItems;

@end
