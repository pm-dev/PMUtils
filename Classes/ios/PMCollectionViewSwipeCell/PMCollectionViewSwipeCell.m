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
//  PMCollectionViewSwipeCell.m
//  Created by Peter Meyers on 8/21/14.
//
//

#import "PMCollectionViewSwipeCell.h"
#import "UIScrollView+PMUtils.h"
#import "UIView+PMUtils.h"

@interface PMSwipeCellScrollView : UIScrollView
@end

@interface PMCollectionViewSwipeCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end

@implementation PMCollectionViewSwipeCell
{
    UIScrollView *_scrollView;
    BOOL _delegateRespondsToDidMoveToPosition;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonPMSwipeCollectionViewCellInit];
    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
    [self commonPMSwipeCollectionViewCellInit];
}


#pragma mark - Public Methods

- (void) setDelegate:(id<PMCollectionViewSwipeCellDelegate>)delegate
{
    _delegate = delegate;
    _delegateRespondsToDidMoveToPosition = [_delegate respondsToSelector:@selector(swipeCollectionViewCell:didMoveToPosition:)];
}

- (void) setBouncesOpen:(BOOL)bounces
{
    _scrollView.bounces = bounces;
}

- (BOOL) bouncesOpen
{
    return _scrollView.bounces;
}

- (void) setCellPosition:(PMCellPosition)position animated:(BOOL)animated
{
    CGPoint offset = [self contentOffsetForPosition:position];
    [_scrollView setContentOffset:offset animated:animated];
}


#pragma mark Accessor Methods


- (void) setCellPosition:(PMCellPosition)cellPosition
{
    [self setCellPosition:cellPosition animated:NO];
}

- (void) setLeftUtilityView:(UIView *)leftUtilityView
{
    [_leftUtilityView removeFromSuperview];
    _leftUtilityView = leftUtilityView;
    _leftUtilityView.hidden = YES;
    [self insertSubview:_leftUtilityView belowSubview:_scrollView];
    [self resetScrollViewContentSizeAndOffset];
}

- (void) setRightUtilityView:(UIView *)rightUtilityView
{
    [_rightUtilityView removeFromSuperview];
    _rightUtilityView = rightUtilityView;
    _rightUtilityView.hidden = YES;
    [self insertSubview:_rightUtilityView belowSubview:_scrollView];
    [self resetScrollViewContentSizeAndOffset];
}


#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    PMCellPosition toCellPosition = _cellPosition;
    CGPoint centeredContentOffset = [self contentOffsetForPosition:PMCellPositionCentered];
    
    if (scrollView.contentOffset.x == centeredContentOffset.x) {
        toCellPosition = PMCellPositionCentered;
    }
    else if (scrollView.contentOffset.x <= [self contentOffsetForPosition:PMCellPositionLeftUtilityViewVisible].x) {
        toCellPosition = PMCellPositionLeftUtilityViewVisible;
        
    }
    else if (scrollView.contentOffset.x >= [self contentOffsetForPosition:PMCellPositionRightUtilityViewVisible].x) {
        toCellPosition = PMCellPositionRightUtilityViewVisible;
    }
    
    if (toCellPosition != _cellPosition) {
        _cellPosition = toCellPosition;
        if (_delegateRespondsToDidMoveToPosition) {
            [self.delegate swipeCollectionViewCell:self didMoveToPosition:_cellPosition];
        }
    }
    
    BOOL leftWasHidden = self.leftUtilityView.hidden;
    BOOL rightWasHidden = self.rightUtilityView.hidden;
    self.leftUtilityView.hidden = (scrollView.contentOffset.x >  centeredContentOffset.x);
    self.rightUtilityView.hidden = (scrollView.contentOffset.x < centeredContentOffset.x);
    
    if (leftWasHidden != self.leftUtilityView.hidden &&
        rightWasHidden != self.rightUtilityView.hidden) {
        
        [scrollView killScroll];
        scrollView.contentOffset = centeredContentOffset;
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    *targetContentOffset = [self contentOffsetForPosition:PMCellPositionCentered];
    
    if (!self.rightUtilityView.hidden && velocity.x > 0.0f) {
        *targetContentOffset = [self contentOffsetForPosition:PMCellPositionRightUtilityViewVisible];
    }
    else if (!self.leftUtilityView.hidden && velocity.x < 0.0f) {
        *targetContentOffset = [self contentOffsetForPosition:PMCellPositionLeftUtilityViewVisible];
    }
}


#pragma mark - Internal Methods


- (CGPoint) contentOffsetForPosition:(PMCellPosition)position
{
    CGPoint offset = CGPointZero;
    switch (position)
    {
        case PMCellPositionCentered:
            offset.x = self.leftUtilityView.frame.size.width;
            break;
        case PMCellPositionRightUtilityViewVisible:
            offset.x = self.leftUtilityView.frame.size.width + self.rightUtilityView.frame.size.width;
            break;
        case PMCellPositionLeftUtilityViewVisible:
            offset.x = 0.0f;
            break;
    }
    return offset;
}


- (void) resetScrollViewContentSizeAndOffset
{
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = self.leftUtilityView.frame.size.width + self.contentView.frame.size.width + self.rightUtilityView.frame.size.width;
    self.cellPosition = PMCellPositionCentered;
    _scrollView.contentSize = contentSize;
    [self.contentView setFX:_scrollView.contentOffset.x];
}


- (void) commonPMSwipeCollectionViewCellInit
{
    _scrollView = [[PMSwipeCellScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;    
    [_scrollView addSubview:self.contentView];
    [self addSubview:_scrollView];
    _cellPosition = -1;
}

@end


#pragma mark -


@implementation PMSwipeCellScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging){
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
    else {
        [super touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [self.nextResponder touchesEnded: touches withEvent:event];
    }
    else {
        [super touchesEnded: touches withEvent: event];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        CGPoint translation = [self.panGestureRecognizer translationInView:self.panGestureRecognizer.view];
        return fabsf(translation.y) <= fabsf(translation.x);
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}
/*
 * If the user is actively scrolling the collection view,
 * don't allow this scroll view's gesture recognizer to trigger.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view];
        return fabsf(velocity.y) <= 0.25f;
    }
    return YES;
}

@end
