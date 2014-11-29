//
//  PMTableViewSwipeCell.m
//  Pods
//
//  Created by Peter Meyers on 11/28/14.
//
//

#import "PMTableViewSwipeCell.h"
#import "UIScrollView+PMUtils.h"
#import "PMSwipeCellScrollView.h"

@interface PMTableViewSwipeCell() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end

@implementation PMTableViewSwipeCell
{
    UIScrollView *_scrollView;
    BOOL _delegateRespondsToDidMoveToPosition;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonPMTableViewSwipeCellInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonPMTableViewSwipeCellInit];
}


#pragma mark - Public Methods

- (void) setDelegate:(id<PMSwipeCellDelegate>)delegate
{
    _delegate = delegate;
    _delegateRespondsToDidMoveToPosition = [_delegate respondsToSelector:@selector(swipeCell:didMoveToPosition:)];
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
            [self.delegate swipeCell:self didMoveToPosition:_cellPosition];
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
    CGRect frame = self.contentView.frame;
    frame.origin.x = _scrollView.contentOffset.x;
    self.contentView.frame = frame;
}


- (void) commonPMTableViewSwipeCellInit
{
    _scrollView = [[PMSwipeCellScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    [_scrollView addSubview:self.contentView];
    [self addSubview:_scrollView];
    _cellPosition = -1;
}

@end
