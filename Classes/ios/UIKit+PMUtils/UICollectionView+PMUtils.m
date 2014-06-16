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

static inline CGFloat PMSquaredDistanceFromRectToPoint(CGRect rect, CGPoint point)
{
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

@implementation UICollectionView (PMUtils)

- (NSIndexPath *) visibleIndexPathNearestToPoint:(CGPoint)point
{
    NSIndexPath *nearestIndexPath = nil;
    CGFloat closestDistance = MAXFLOAT;
    
	if (CGSizeEqualToSize(CGSizeZero, self.contentSize) == NO) {
		
		for (NSIndexPath *indexPath in self.indexPathsForVisibleItems) {
			
			CGFloat distance = [self _squaredDistanceFromItemAtIndexPath:indexPath toPoint:point];
			
			if (distance < closestDistance) {
				closestDistance = distance;
				nearestIndexPath = indexPath;
			}
		}
	}
	
    return nearestIndexPath;
}

- (NSIndexPath *) indexPathNearestToPoint:(CGPoint)point
{
    NSIndexPath *nearestIndexPath = nil;
    CGFloat closestDistance = MAXFLOAT;
    
    for (NSInteger section = 0; section < self.numberOfSections; section++) {

        NSInteger items = [self numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < items; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            CGFloat distance = [self _squaredDistanceFromItemAtIndexPath:indexPath toPoint:point];
            
            if (distance < closestDistance) {
                closestDistance = distance;
                nearestIndexPath = indexPath;
            }
        }
    }
    return nearestIndexPath;
}

- (CGPoint) contentOffsetForCenteredRect:(CGRect)rect
{
    CGFloat offsetX = rect.origin.x - (self.bounds.size.width - rect.size.width) / 2.0f;
    CGFloat offsetY = rect.origin.y - (self.bounds.size.height - rect.size.height) / 2.0f;
    return CGPointMake(offsetX, offsetY);
}


- (CGPoint) contentOffsetInBoundsCenter
{
    CGPoint middlePoint = self.contentOffset;
    middlePoint.x += self.bounds.size.width / 2.0f;
    middlePoint.y += self.bounds.size.height / 2.0f;
    return middlePoint;
}

- (NSIndexPath *) indexPathNearestToBoundsCenter
{
	CGPoint contentOffsetInBoundsCenter = [self contentOffsetInBoundsCenter];
	return [self visibleIndexPathNearestToPoint:contentOffsetInBoundsCenter];
}

- (void) reloadVisibleItems
{
	[self reloadItemsAtIndexPaths:[self indexPathsForVisibleItems]];
}

#pragma mark - Private Methods

- (CGFloat) _squaredDistanceFromItemAtIndexPath:(NSIndexPath *)indexPath toPoint:(CGPoint)point
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attributes.frame;
    
    if (CGRectContainsPoint(frame, point)) {
        return 0.0f;
    }
    
    return PMSquaredDistanceFromRectToPoint(frame, point);
}

@end
