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
//  PMCenteredCircularCollectionView.m
//  Created by Peter Meyers on 3/23/14.
//
//

#import "PMCenteredCircularCollectionView.h"
#import "UICollectionView+PMUtils.h"
#import "NSIndexPath+PMUtils.h"

@implementation PMCenteredCircularCollectionView
{
    __weak id<PMCenteredCircularCollectionViewDelegate> _originalDelegate;
    BOOL _delegateRespondsToWillCenterItemAtIndex;
    BOOL _delegateRespondsToDidSelectItemAtIndexPath;
    BOOL _delegateRespondsToScrollViewDidEndDecelerating;
}

+ (instancetype) collectionViewWithFrame:(CGRect)frame collectionViewLayout:(PMCenteredCollectionViewFlowLayout *)layout
{
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(PMCenteredCollectionViewFlowLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

    }
    return self;
}


- (void) reloadData
{
	[super reloadData];
	[self setCenteredIndex:_centeredIndex animated:NO];
}

#pragma mark - Accessors


- (void) setDelegate:(id<PMCenteredCircularCollectionViewDelegate>)delegate
{
    [super setDelegate:delegate];
    _originalDelegate = delegate;
    _delegateRespondsToScrollViewDidEndDecelerating = [delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
    _delegateRespondsToDidSelectItemAtIndexPath = [delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)];
    _delegateRespondsToWillCenterItemAtIndex = [delegate respondsToSelector:@selector(collectionView:willCenterItemAtIndex:)];
}


#pragma mark - Public Methods


- (void) setCenteredCell:(UICollectionViewCell *)cell animated:(BOOL)animated;
{
	NSIndexPath *indexPath = [self indexPathForCell:cell];

	if (indexPath) {
		[self setCenteredIndex:indexPath.item animated:animated];
	}
}

- (void) setCenteredIndex:(NSUInteger)centeredIndex
{
	[self setCenteredIndex:centeredIndex animated:NO];
}

- (void) setCenteredIndex:(NSUInteger)centeredIndex animated:(BOOL)animated
{	
    if ([self circularActive]) {

		[self layoutIfNeeded];
		
		if (centeredIndex < self.itemCount) {
				
			NSIndexPath *indexPathNearestToBoundsCenter = [self indexPathNearestToBoundsCenter];
			
			if (indexPathNearestToBoundsCenter) {
				
				NSIndexPath *normalizedIndexPathAtMiddle = [self normalizedIndexPath:indexPathNearestToBoundsCenter];
				
				NSRange range = NSMakeRange(0, self.itemCount);

				NSInteger delta = PMShortestCircularDistance(normalizedIndexPathAtMiddle.item, centeredIndex, range);
				
				NSInteger toItem = indexPathNearestToBoundsCenter.item + delta;
				
				NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
				
				[self PM_centerIndexPath:toIndexPath animated:animated notifyDelegate:YES];
			}
		}
	}
}


#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPathNearestToBoundsCenter = [self indexPathNearestToBoundsCenter];
    [self PM_centerIndexPath:indexPathNearestToBoundsCenter animated:YES notifyDelegate:YES];

    if (_delegateRespondsToScrollViewDidEndDecelerating) {
        [_originalDelegate scrollViewDidEndDecelerating:scrollView];
    }
}


#pragma mark - UICollectionViewDelegate Methods


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self PM_centerIndexPath:indexPath animated:YES notifyDelegate:YES];
    
    if (_delegateRespondsToDidSelectItemAtIndexPath) {
        [_originalDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}


#pragma mark - Private Methods


- (void) PM_centerIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated notifyDelegate:(BOOL)notifyDelegate
{
	NSParameterAssert(indexPath);
	
    if ([self circularActive]) {
		
        NSIndexPath *normalizedIndexPath = [self normalizedIndexPath:indexPath];
        _centeredIndex = normalizedIndexPath.item;
		
		[self scrollToItemAtIndexPath:indexPath
					 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically
							 animated:animated];
		
		if (notifyDelegate && _delegateRespondsToWillCenterItemAtIndex) {
			[_originalDelegate collectionView:self willCenterItemAtIndex:_centeredIndex];
		}
    }
}

- (CGPoint) PM_contentOffsetForCenteredOffset:(CGPoint)centeredOffset
{
	centeredOffset.x = floorf(centeredOffset.x - self.bounds.size.width/2.0f);
	centeredOffset.y = floorf(centeredOffset.y - self.bounds.size.height/2.0f);
	return centeredOffset;
}

@end
