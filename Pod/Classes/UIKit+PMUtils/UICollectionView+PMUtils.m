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
//  UICollectionView+PMUtils.m
//  Created by Peter Meyers on 3/21/14.
//
//

#import "UICollectionView+PMUtils.h"
#import "UIScrollView+PMUtils.h"

static inline CGFloat PMSquaredDistanceFromRectToPoint(CGRect rect, CGPoint point)
{
	if (CGRectContainsPoint(rect, point)) {
        return 0.0f;
    }
	else {
		CGPoint closestPoint = rect.origin;
		
		if (point.x > CGRectGetMaxX(rect)) {
			closestPoint.x += rect.size.width;
		}
		else if (point.x > CGRectGetMinX(rect)) {
			closestPoint.x = point.x;
		}
		
		if (point.y > CGRectGetMaxY(rect)) {
			closestPoint.y += rect.size.height;
		}
		else if (point.y > CGRectGetMinY(rect)) {
			closestPoint.y = point.y;
		}
		
		CGFloat dx = point.x - closestPoint.x;
		CGFloat dy = point.y - closestPoint.y;
		
		return dx*dx + dy*dy;
	}
}

@implementation UICollectionView (PMUtils)

- (NSIndexPath *) indexPathNearestToPoint:(CGPoint)point
{
	CGRect visibleRect = [self visibleRect];
	NSIndexPath *nearestIndexPath = nil;
    CGFloat closestDistance = MAXFLOAT;
	
	if (CGRectContainsPoint(visibleRect, point)) {
		
		if (CGSizeEqualToSize(CGSizeZero, self.contentSize) == NO) {
			
			for (NSIndexPath *indexPath in self.indexPathsForVisibleItems) {
				
				CGFloat distance = [self PM_squaredDistanceFromItemAtIndexPath:indexPath toPoint:point];
				
				if (distance < closestDistance) {
					closestDistance = distance;
					nearestIndexPath = indexPath;
				}
			}
		}
	}
	else {
		for (NSInteger section = 0; section < self.numberOfSections; section++) {
			
			NSInteger items = [self numberOfItemsInSection:section];
			
			for (NSInteger item = 0; item < items; item++) {
				
				NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
				
				CGFloat distance = [self PM_squaredDistanceFromItemAtIndexPath:indexPath toPoint:point];
				
				if (distance < closestDistance) {
					closestDistance = distance;
					nearestIndexPath = indexPath;
				}
			}
		}
	}
    return nearestIndexPath;
}

- (NSIndexPath *) indexPathNearestToBoundsCenter
{
	CGPoint contentOffsetInBoundsCenter = [self contentOffsetInBoundsCenter];
	return [self indexPathNearestToPoint:contentOffsetInBoundsCenter];
}

- (void) reloadVisibleItems
{
	[self reloadItemsAtIndexPaths:[self indexPathsForVisibleItems]];
}

- (void) scrollToTopAnimated:(BOOL)animated
{
    if (self.contentSize.height >= 1.0f && self.contentSize.width >= 1.0f) {
        CGRect top = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        [self scrollRectToVisible:top animated:animated];
    }
}

- (void) scrollToBottomAnimated:(BOOL)animated
{
    if (self.contentSize.height >= 1.0f && self.contentSize.width >= 1.0f) {
        CGRect bottom = CGRectMake(self.contentSize.width - 1.0f, self.contentSize.height - 1.0f, 1.0f, 1.0f);
        [self scrollRectToVisible:bottom animated:animated];
    }
}

#pragma mark - Internal Methods

- (CGFloat) PM_squaredDistanceFromItemAtIndexPath:(NSIndexPath *)indexPath toPoint:(CGPoint)point
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    return PMSquaredDistanceFromRectToPoint(frame, point);
}

@end
