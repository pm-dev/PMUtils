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
//  PMCenteredCollectionViewFlowLayout.m
//  Created by Peter Meyers on 3/25/14.
//
//

#import "PMCenteredCollectionViewFlowLayout.h"
#import "PMCenteredCircularCollectionView.h"
#import "UICollectionView+PMUtils.h"
#import "UIScrollView+PMUtils.h"

@implementation PMCenteredCollectionViewFlowLayout


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
	if ( !_centeringDisabled ) {
		
		BOOL targetFirstIndexPath = CGPointEqualToPoint(proposedContentOffset, CGPointZero);
		BOOL targetLastIndexPath = (proposedContentOffset.x == self.collectionViewContentSize.width - self.collectionView.bounds.size.width &&
									proposedContentOffset.y == self.collectionViewContentSize.height - self.collectionView.bounds.size.height);
		
		if (!targetFirstIndexPath && !targetLastIndexPath) {
			
			proposedContentOffset.x += self.collectionView.bounds.size.width / 2.0f;
			proposedContentOffset.y += self.collectionView.bounds.size.height / 2.0f;
			
			NSIndexPath *targetedIndexPath = [self.collectionView indexPathNearestToPoint:proposedContentOffset];
			
			UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:targetedIndexPath];
			
			proposedContentOffset = [self.collectionView contentOffsetForCenteredRect:attributes.frame];
			
			return proposedContentOffset;
		}
	}

    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

@end
