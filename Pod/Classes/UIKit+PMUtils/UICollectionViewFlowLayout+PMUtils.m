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
//  UICollectionViewFlowLayout+PMUtils.m
//  Created by Peter Meyers on 4/9/14.
//
//

#import "UICollectionViewFlowLayout+PMUtils.h"

@implementation UICollectionViewFlowLayout (PMUtils)

- (BOOL) requiresScrollAnimationToIndexPath:(NSIndexPath *)indexPath atPosition:(UICollectionViewScrollPosition)scrollPosition
{
    NSParameterAssert(indexPath);
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGPoint itemOrigin = attributes.frame.origin;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGSize collectionViewBoundsSize = self.collectionView.bounds.size;
    CGPoint targetOffset = itemOrigin;
    
    switch (self.scrollDirection)
    {
        case UICollectionViewScrollDirectionHorizontal:
        {
            if (scrollPosition & UICollectionViewScrollPositionCenteredHorizontally) {
                
                targetOffset.x += collectionViewBoundsSize.width/2.0f;
            }
            else if (scrollPosition & UICollectionViewScrollPositionRight) {
                
                targetOffset.x += collectionViewBoundsSize.width - attributes.frame.size.width;
            }
            
            CGFloat maxOffset = self.collectionViewContentSize.width - collectionViewBoundsSize.width;
            CGFloat scrollDelta = targetOffset.x - contentOffset.x;
            
            BOOL endOfScroll = ((scrollDelta > 0.0f && contentOffset.x == maxOffset) ||
                                (scrollDelta < 0.0f && contentOffset.x == 0.0f));
            
            return (scrollDelta != 0.0f && !endOfScroll);
        }
            
        case UICollectionViewScrollDirectionVertical:
        {
            if (scrollPosition & UICollectionViewScrollPositionCenteredVertically) {
                
                targetOffset.y -= (collectionViewBoundsSize.height - attributes.frame.size.height)/2.0f;
            }
            else if (scrollPosition & UICollectionViewScrollPositionBottom) {
                
                targetOffset.y -= (collectionViewBoundsSize.height - attributes.frame.size.height);
            }
            
            CGFloat maxOffset = self.collectionViewContentSize.height - collectionViewBoundsSize.height;
            CGFloat scrollDelta = targetOffset.y - contentOffset.y;
            
            BOOL endOfScroll = ((scrollDelta > 0.0f && contentOffset.y == maxOffset) ||
                                (scrollDelta < 0.0f && contentOffset.y == 0.0f));
            
            return (scrollDelta != 0.0f && !endOfScroll);
        }
    }
}


@end
