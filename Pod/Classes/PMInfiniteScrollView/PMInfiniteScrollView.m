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
//  PMInfiniteScrollView.m
//  Pods
//
//  Created by Peter Meyers on 9/29/14.
//
//

#import "PMInfiniteScrollView.h"

static NSUInteger const ContentMultiplier = 4;

@implementation PMInfiniteScrollView
{
    BOOL _delegateRespondsToDidRecenter;
}

- (void) setDelegate:(id<PMInfiniteScrollViewDelegate>)delegate
{
    super.delegate = delegate;
    _delegateRespondsToDidRecenter = [delegate respondsToSelector:@selector(infiniteScrollView:didRecenterContentOffset:)];
}

- (void) setInfiniteDirection:(PMDirection)infiniteDirection
{
    if (_infiniteDirection != infiniteDirection) {
        _infiniteDirection = infiniteDirection;
        [self adjustContentSize];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self adjustContentSize];
    [self recenterIfNecessary];
}


#pragma mark - Private Methods


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) adjustContentSize
{
    CGSize contentSize = self.bounds.size;
    
    if (_infiniteDirection & PMDirectionHorizontal) {
        contentSize.width = self.bounds.size.width * ContentMultiplier;
        self.showsHorizontalScrollIndicator = NO;
    }
    if (_infiniteDirection & PMDirectionVertical) {
        contentSize.height = self.bounds.size.width * ContentMultiplier;
        self.showsVerticalScrollIndicator = NO;
    }
    
    self.contentSize = contentSize;
}

- (void) recenterIfNecessary
{
    CGPoint currentOffset = self.contentOffset;
    
    if (self.infiniteDirection & PMDirectionHorizontal) {
        CGFloat contentCenterX = (self.contentSize.width - self.bounds.size.width) / 2.0f;
        CGFloat horzDistanceFromCenter = fabsf(currentOffset.x - contentCenterX);
        CGFloat singleContentWidth = self.contentSize.width / ContentMultiplier;
        
        if (horzDistanceFromCenter >= singleContentWidth) {
            self.contentOffset = CGPointMake(contentCenterX, self.contentOffset.y);
        }
    }
    if (self.infiniteDirection & PMDirectionVertical) {
        CGFloat contentCenterY = (self.contentSize.height - self.bounds.size.height) / 2.0f;
        CGFloat vertDistanceFromCenter = fabsf(currentOffset.y - contentCenterY);
        CGFloat singleContentHeight = self.contentSize.height / ContentMultiplier;

        if (vertDistanceFromCenter >= singleContentHeight) {
            self.contentOffset = CGPointMake(self.contentOffset.x, contentCenterY);
        }
    }
    
    if (_delegateRespondsToDidRecenter && CGPointEqualToPoint(self.contentOffset, currentOffset) == NO) {
        CGPoint delta = CGPointMake(self.contentOffset.x - currentOffset.x, self.contentOffset.y - currentOffset.y);
        [self.delegate infiniteScrollView:self didRecenterContentOffset:delta];
    }
}

@end
