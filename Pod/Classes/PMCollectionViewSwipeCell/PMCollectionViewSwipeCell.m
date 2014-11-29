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

@interface PMSwipeCellScrollView : UIScrollView

+ (instancetype) scrollViewWithCell:(UICollectionViewCell *)cell;

@end


@interface PMCollectionViewSwipeCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, getter=isEditing) BOOL editing;
@end

@implementation PMCollectionViewSwipeCell
{
    PMSwipeCellScrollView *_scrollView;
    BOOL _delegateRespondsToDidMoveToPosition;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonPMCollectionViewSwipeCellInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonPMCollectionViewSwipeCellInit];
}


#pragma mark - Public Methods


- (void) setDelegate:(id<PMSwipeCellDelegate>)delegate
{
    _delegate = delegate;
    _delegateRespondsToDidMoveToPosition = [_delegate respondsToSelector:@selector(swipeCell:didMoveToPosition:)];
}

- (void) setSwipeEnabled:(BOOL)swipeEnabled
{
    _scrollView.scrollEnabled = swipeEnabled;
}

- (BOOL) swipeEnabled
{
    return _scrollView.scrollEnabled;
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
    switch (position) {
        case PMCellPositionCentered:
            self.editing = NO;
            break;
        case PMCellPositionLeftUtilityViewVisible:
        case PMCellPositionRightUtilityViewVisible:
            self.editing = YES;
            break;
    }
    UIEdgeInsets inset = [self contentInsetForPosition:position];
    [_scrollView setContentInset:inset];
    [_scrollView setContentOffset:CGPointZero animated:animated];
}

- (void) setCellPosition:(PMCellPosition)cellPosition
{
    [self setCellPosition:cellPosition animated:NO];
}

- (PMCellPosition) cellPosition
{
    UIEdgeInsets inset = _scrollView.contentInset;
    if (UIEdgeInsetsEqualToEdgeInsets(inset, [self contentInsetForPosition:PMCellPositionCentered])) {
        return PMCellPositionCentered;
    }
    else if (UIEdgeInsetsEqualToEdgeInsets(inset, [self contentInsetForPosition:PMCellPositionRightUtilityViewVisible])) {
        return PMCellPositionRightUtilityViewVisible;
    }
    else if (UIEdgeInsetsEqualToEdgeInsets(inset, [self contentInsetForPosition:PMCellPositionLeftUtilityViewVisible])){
        return PMCellPositionLeftUtilityViewVisible;
    }
    else {
        return PMCellPositionCentered;
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (_editing != editing) {
        if (_delegateRespondsToDidMoveToPosition) {
            [self.delegate swipeCell:self didMoveToPosition:self.cellPosition];
        }
    }
}

- (void) setLeftUtilityView:(UIView *)leftUtilityView
{
    if (_leftUtilityView != leftUtilityView) {
        [_leftUtilityView removeFromSuperview];
        _leftUtilityView = leftUtilityView;
        _leftUtilityView.hidden = YES;
        [self insertSubview:_leftUtilityView belowSubview:_scrollView];
    }
}

- (void) setRightUtilityView:(UIView *)rightUtilityView
{
    if (_rightUtilityView != rightUtilityView) {
        [_rightUtilityView removeFromSuperview];
        _rightUtilityView = rightUtilityView;
        _rightUtilityView.hidden = YES;
        [self insertSubview:_rightUtilityView belowSubview:_scrollView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.contentSize = self.bounds.size;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.bouncesOpen = YES;
    self.delegate = nil;
    self.leftUtilityView = nil;
    self.rightUtilityView = nil;
    self.cellPosition = PMCellPositionCentered;
    self.swipeEnabled = YES;
}


#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(PMSwipeCellScrollView *)scrollView
{
    if ((!self.leftUtilityView.hidden && scrollView.contentOffset.x <= 0.0f) ||
        (!self.rightUtilityView.hidden && scrollView.contentOffset.x <= 0.0f)) {
        [self setCellPosition:PMCellPositionCentered animated:NO];
    }
    
    if (CGPointEqualToPoint(scrollView.contentOffset, CGPointZero) &&
        UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsetsZero)) {
        self.leftUtilityView.hidden = YES;
        self.rightUtilityView.hidden = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView.panGestureRecognizer.view];
    if (scrollView.contentOffset.x >= 0.0f && velocity.x < 0.0f) {
        self.rightUtilityView.hidden = NO;
        scrollView.contentInset = [self contentInsetForPosition:PMCellPositionRightUtilityViewVisible];
    }
    else if (scrollView.contentOffset.x <= 0.0f && velocity.x > 0.0f) {
        self.leftUtilityView.hidden = NO;
        scrollView.contentInset = [self contentInsetForPosition:PMCellPositionLeftUtilityViewVisible];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        self.editing = !UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsetsZero);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.editing = !UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsetsZero);
}


#pragma mark - Internal Methods


- (UIEdgeInsets) contentInsetForPosition:(PMCellPosition)position
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch (position) {
        case PMCellPositionCentered:
            break;
        case PMCellPositionRightUtilityViewVisible:
            insets.right = self.rightUtilityView.frame.size.width;
            break;
        case PMCellPositionLeftUtilityViewVisible:
            insets.left = self.leftUtilityView.frame.size.width;
            break;
    }
    return insets;
}

- (void) commonPMCollectionViewSwipeCellInit
{
    _scrollView = [PMSwipeCellScrollView scrollViewWithCell:self];
    _scrollView.delegate = self;
    self.cellPosition = PMCellPositionCentered;
    self.swipeEnabled = YES;
}

@end


#pragma mark - PMSwipeCellScrollView


@implementation PMSwipeCellScrollView
{
    __weak PMCollectionViewSwipeCell *_cell;
}

+ (instancetype)scrollViewWithCell:(PMCollectionViewSwipeCell *)cell
{
    return [[self alloc] initWithCell:cell];
}

- (instancetype) initWithCell:(PMCollectionViewSwipeCell *)cell
{
    
    self = [self initWithFrame:cell.bounds];
    if (self) {
        [self addSubview:cell.contentView];
        [cell addSubview:self];
        _cell = cell;
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.scrollEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.alwaysBounceHorizontal = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

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
    [super touchesBegan:touches withEvent:event];
    if (!_cell.isEditing) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.canCancelContentTouches) {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent:event];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint velocity = [self.panGestureRecognizer velocityInView:self.panGestureRecognizer.view];
        return (fabsf(velocity.y) < fabsf(velocity.x));
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}


@end

