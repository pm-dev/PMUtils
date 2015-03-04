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
//  PMImageFilmstrip.m
//  Created by Peter Meyers on 9/6/14.
//

#import "PMImageFilmstrip.h"
#import "UICollectionView+PMUtils.h"
#import "UICollectionReusableView+PMUtils.h"
#import "UIView+PMUtils.h"
#import "PMCircularCollectionView.h"
#import "NSIndexPath+PMUtils.h"
#import "FXPageControl.h"

static CGFloat const PMPageControlHeight = 37.0f;


@interface PMImageFilmstripCollectionView : PMCircularCollectionView
@end

@implementation PMImageFilmstripCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer &&
        [self ancestorOfClass:[UIScrollView class]]) {
        CGPoint velocity = [self.panGestureRecognizer velocityInView:self.panGestureRecognizer.view];
        switch (self.collectionViewLayout.scrollDirection) {
            case UICollectionViewScrollDirectionVertical:
                return (fabsf(velocity.y) > fabsf(velocity.x));
                break;
            case UICollectionViewScrollDirectionHorizontal:
                return (fabsf(velocity.y) < fabsf(velocity.x));
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end


@interface PMImageFilmstripCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PMImageFilmstripCell

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end


@interface PMZoomableImageFilmstripCell : PMImageFilmstripCell
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation PMZoomableImageFilmstripCell

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self.scrollView addSubview:self.imageView];
        self.scrollView.scrollsToTop = NO;
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

- (void)dealloc
{
    self.scrollView.delegate = nil;
}

@end



@interface PMImageFilmstrip () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PMImageFilmstripCollectionView *collectionView;
@property (nonatomic, strong, readwrite) FXPageControl *pageControl;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *singleTap;

- (Class) imageCellClass;
- (NSString *) imageCellReuseIdentifier;

@end

@implementation PMImageFilmstrip
{
    UICollectionViewFlowLayout *_collectionViewFlowLayout;
    BOOL _delegateRespondsToDidScroll;
    BOOL _delegateRespondsToWillScroll;
    BOOL _delegateRespondsToTap;
}


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self PM_commonPMImageFilmstripInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self PM_commonPMImageFilmstripInit];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    _collectionViewFlowLayout.itemSize = frame.size;
    [self invalidateIntrinsicContentSize];
    super.frame = frame;
    [self PM_updateContentOffset];
}

- (void) setBounds:(CGRect)bounds
{
    _collectionViewFlowLayout.itemSize = bounds.size;
    [self invalidateIntrinsicContentSize];
    super.bounds = bounds;
    [self PM_updateContentOffset];
}

- (CGSize)intrinsicContentSize
{
    return _collectionViewFlowLayout.itemSize;
}

- (void) setDelegate:(id<PMImageFilmstripDelegate>)delegate
{
    _delegate = delegate;
    _delegateRespondsToDidScroll = [_delegate respondsToSelector:@selector(imageFilmstrip:didScrollToImageView:atIndex:)];
    _delegateRespondsToWillScroll = [_delegate respondsToSelector:@selector(imageFilmstrip:willScrollToImageView:atIndex:)];
    _delegateRespondsToTap = [delegate respondsToSelector:@selector(imageFilmstrip:didTapImageView:atIndex:)];
}

- (void)setCircularDisabled:(BOOL)circularDisabled
{
    self.collectionView.circularDisabled = circularDisabled;
}

- (BOOL)circularDisabled
{
    return self.collectionView.circularDisabled;
}

- (void)reloadImages;
{
    [self.collectionView reloadData];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
    if (indexPath) {
        NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
        if (self.pageControl.currentPage != normalizedIndexPath.item) {
            self.pageControl.currentPage = normalizedIndexPath.item;
            [self.collectionView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
        }
    }
    self.collectionView.frame = self.bounds;
    
}

- (void) scrollToImageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSUInteger items = self.pageControl.numberOfPages;
    if (index < items) {
        NSIndexPath *currentIndexPath = [self.collectionView indexPathNearestToBoundsCenter];
        NSIndexPath *currentNormalizedIndexPath = [self.collectionView normalizedIndexPath:currentIndexPath];
        NSInteger distanceToIndex = PMShortestCircularDistance(currentNormalizedIndexPath.item, index, NSMakeRange(0, items));
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item+distanceToIndex inSection:0];
        self.pageControl.currentPage = [self.collectionView normalizedIndexPath:toIndexPath].item;
        [self.collectionView scrollToItemAtIndexPath:toIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally
                                            animated:animated];
    }
}

- (void) didSingleTap:(UITapGestureRecognizer *)tap
{
    if (_delegateRespondsToTap) {
        NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
        PMImageFilmstripCell *cell = (PMImageFilmstripCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
        [self.delegate imageFilmstrip:self didTapImageView:cell.imageView atIndex:normalizedIndexPath.item];
    }
}


#pragma mark - UICollectionViewDataSource


- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section
{
    NSInteger images = [self.delegate numberOfImagesInImageFilmstrip:self];
    self.pageControl.numberOfPages = images;
    return images;
}

- (UICollectionViewCell *) collectionView:(PMImageFilmstripCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *normalizedIndexPath = [collectionView normalizedIndexPath:indexPath];
    PMImageFilmstripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self imageCellReuseIdentifier] forIndexPath:indexPath];
    [self.delegate imageFilmstrip:self
      configureFilmstripImageView:cell.imageView
                          atIndex:normalizedIndexPath.item];
    return cell;
}


#pragma mark - UICollectionViewDelegate


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == self.collectionView) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:*targetContentOffset];
        NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
        self.pageControl.currentPage = normalizedIndexPath.item;
        
        if (_delegateRespondsToWillScroll) {
            PMImageFilmstripCell *cell = (PMImageFilmstripCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            [_delegate imageFilmstrip:self willScrollToImageView:cell.imageView atIndex:normalizedIndexPath.item];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
        NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
        self.pageControl.currentPage = normalizedIndexPath.item;
        
        if(_delegateRespondsToDidScroll) {
            PMImageFilmstripCell *cell = (PMImageFilmstripCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            [_delegate imageFilmstrip:self didScrollToImageView:cell.imageView atIndex:normalizedIndexPath.item];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.collectionView) {
        if (decelerate == NO) {
            
            NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
            NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
            self.pageControl.currentPage = normalizedIndexPath.item;
            
            if (_delegateRespondsToDidScroll) {
                PMImageFilmstripCell *cell = (PMImageFilmstripCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                [_delegate imageFilmstrip:self didScrollToImageView:cell.imageView atIndex:normalizedIndexPath.item];
            }
        }
    }
}

- (Class) imageCellClass
{
    return [PMImageFilmstripCell class];
}

- (NSString *) imageCellReuseIdentifier
{
    return [PMImageFilmstripCell defaultReuseIdentifier];
}


#pragma mark - Private Methods


- (void) PM_commonPMImageFilmstripInit
{
    _collectionViewFlowLayout = [UICollectionViewFlowLayout new];
    _collectionViewFlowLayout.minimumLineSpacing = 0.0f;
    _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionViewFlowLayout.itemSize = self.bounds.size;
    
    self.collectionView = [[PMImageFilmstripCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_collectionViewFlowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.collectionView registerClass:[self imageCellClass] forCellWithReuseIdentifier:[self imageCellReuseIdentifier]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsSelection = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollsToTop = NO;
    [self addSubview:_collectionView];
    
    self.pageControl = [[FXPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, self.bounds.size.height - PMPageControlHeight, self.bounds.size.width, PMPageControlHeight);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.enabled = NO;
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pageControl];
    
    self.singleTap = [[UITapGestureRecognizer alloc] init];
    self.singleTap.numberOfTapsRequired = 1;
    [_singleTap addTarget:self action:@selector(didSingleTap:)];
    [self addGestureRecognizer:self.singleTap];
}

- (void) PM_updateContentOffset
{
    NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
    if (indexPath) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
        [self.collectionView setContentOffset:attributes.frame.origin];
    }
}

@end


@implementation PMZoomableImageFilmstrip
{
    UITapGestureRecognizer *_doubleTap;
    BOOL _delegateRespondsToWillZoom;
    BOOL _delegateRespondsToDidZoom;
    BOOL _delegateRespondsToDidPinchToClose;
    CGFloat _pinchStartScale;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self PM_commonZoomableImageFilmstripInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self PM_commonZoomableImageFilmstripInit];
    }
    return self;
}

- (void) PM_commonZoomableImageFilmstripInit
{
    _doubleTap = [[UITapGestureRecognizer alloc] init];
    _doubleTap.numberOfTapsRequired = 2;
    [_doubleTap addTarget:self action:@selector(didDoubleTap:)];
    [self addGestureRecognizer:_doubleTap];
    [self.singleTap requireGestureRecognizerToFail:_doubleTap];
}

- (void)setDelegate:(id<PMZoomableImageFilmstripDelegate>)delegate
{
    [super setDelegate:delegate];
    _delegateRespondsToWillZoom = [delegate respondsToSelector:@selector(imageFilmstrip:willZoomImageView:atIndex:)];
    _delegateRespondsToDidZoom = [delegate respondsToSelector:@selector(imageFilmstrip:didZoomImageView:atIndex:toScale:)];
    _delegateRespondsToDidPinchToClose = [delegate respondsToSelector:@selector(imageFilmstrip:didPinchToCloseImageView:atIndex:)];
}


- (Class)imageCellClass
{
    return [PMZoomableImageFilmstripCell class];
}

- (NSString *)imageCellReuseIdentifier
{
    return [PMZoomableImageFilmstripCell defaultReuseIdentifier];
}

- (PMImageFilmstripCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMZoomableImageFilmstripCell *cell = (PMZoomableImageFilmstripCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.scrollView.delegate = self;
    cell.scrollView.zoomScale = 1.0f;
    cell.scrollView.maximumZoomScale = self.maximumZoomScale;
    [cell.scrollView.pinchGestureRecognizer addTarget:self action:@selector(handlePinch:)];
    return cell;
}

- (void) didDoubleTap:(UITapGestureRecognizer *)tap
{
    NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
    PMZoomableImageFilmstripCell *cell = (PMZoomableImageFilmstripCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.scrollView setZoomScale:(cell.scrollView.zoomScale == 1.0f)? cell.scrollView.maximumZoomScale : 1.0f animated:YES];
}

- (void) handlePinch:(UIPinchGestureRecognizer *)pinch
{
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
        {
            _pinchStartScale = ((UIScrollView *)pinch.view).zoomScale;
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            NSParameterAssert([pinch.view isKindOfClass:[UIScrollView class]]);
            UIScrollView *scrollView = (UIScrollView *)pinch.view;
            if (_pinchStartScale == 1.0f && scrollView.zoomScale <= 1.0f && _delegateRespondsToDidPinchToClose) {
                NSParameterAssert([scrollView.subviews.firstObject isKindOfClass:[UIImageView class]]);
                NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
                NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
                [self.delegate imageFilmstrip:self didPinchToCloseImageView:scrollView.subviews.firstObject atIndex:normalizedIndexPath.item];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIImageView *)view
{
    self.collectionView.scrollEnabled = NO;
    if (_delegateRespondsToWillZoom) {
        NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
        NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
        [self.delegate imageFilmstrip:self willZoomImageView:view atIndex:normalizedIndexPath.item];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIImageView *)view atScale:(CGFloat)scale
{
    self.collectionView.scrollEnabled = (scale == 1.0f);
    if (_delegateRespondsToDidZoom) {
        NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
        NSIndexPath *normalizedIndexPath = [self.collectionView normalizedIndexPath:indexPath];
        [self.delegate imageFilmstrip:self didZoomImageView:view atIndex:normalizedIndexPath.item toScale:scale];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSParameterAssert([scrollView.subviews.firstObject isKindOfClass:[UIImageView class]]);
    return scrollView.subviews.firstObject;
}

@end
