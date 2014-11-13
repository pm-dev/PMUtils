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

static CGFloat const PMPageControlHeight = 37.0f;

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
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
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
        self.doubleTap = [[UITapGestureRecognizer alloc] init];
        self.doubleTap.numberOfTapsRequired = 2;
        [self.scrollView addGestureRecognizer:self.doubleTap];
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

@end



@interface PMImageFilmstrip () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;
- (Class) imageCellClass;
- (NSString *) imageCellReuseIdentifier;

@end

@implementation PMImageFilmstrip
{
	UICollectionViewFlowLayout *_collectionViewFlowLayout;
	BOOL _delegateRespondsToDidScrollToImageAtIndex;
}


- (instancetype) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self PM_commonPMImageFilmstripInit];
	}
	return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self PM_commonPMImageFilmstripInit];
}

- (void) setFrame:(CGRect)frame
{
	_collectionViewFlowLayout.itemSize = frame.size;
	super.frame = frame;
	NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
	UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
	[self.collectionView setContentOffset:attributes.frame.origin];
}

- (void) setBounds:(CGRect)bounds
{
	_collectionViewFlowLayout.itemSize = bounds.size;
	super.bounds = bounds;
	NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
	UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
	[self.collectionView setContentOffset:attributes.frame.origin];
}

- (void) setDelegate:(id<PMImageFilmstripDelegate>)delegate
{
	_delegate = delegate;
	_delegateRespondsToDidScrollToImageAtIndex = [_delegate respondsToSelector:@selector(imageFilmstrip:didScrollToImageAtIndex:)];
}

- (void)reloadImages;
{
    [self.collectionView reloadData];
}

- (void) scrollToImageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    self.pageControl.currentPage = index;
    
    if (_delegateRespondsToDidScrollToImageAtIndex) {
        [_delegate imageFilmstrip:self didScrollToImageAtIndex:index];
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath
                            atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally
                                    animated:animated];
}


#pragma mark - UICollectionViewDataSource


- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section
{
    NSInteger imageCount = [self.dataSource numberOfImagesInImageFilmstrip:self];
    self.pageControl.numberOfPages = imageCount;
    return imageCount;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMImageFilmstripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self imageCellReuseIdentifier] forIndexPath:indexPath];
	[self.delegate imageFilmstrip:self
	  configureFilmstripImageView:cell.imageView
						  atIndex:indexPath.item];
	return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
        self.pageControl.currentPage = indexPath.item;
        
        if(_delegateRespondsToDidScrollToImageAtIndex) {
            [_delegate imageFilmstrip:self didScrollToImageAtIndex:indexPath.item];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.collectionView) {
        if (decelerate == NO) {
            
            NSIndexPath *indexPath = [self.collectionView indexPathNearestToBoundsCenter];
            self.pageControl.currentPage = indexPath.item;
            
            if (_delegateRespondsToDidScrollToImageAtIndex) {
                [_delegate imageFilmstrip:self didScrollToImageAtIndex:indexPath.item];
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

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_collectionViewFlowLayout];
	self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.collectionView registerClass:[self imageCellClass] forCellWithReuseIdentifier:[self imageCellReuseIdentifier]];
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	self.collectionView.allowsSelection = NO;
	self.collectionView.pagingEnabled = YES;
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.backgroundColor = [UIColor whiteColor];
	[self addSubview:_collectionView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, self.bounds.size.height - PMPageControlHeight, self.bounds.size.width, PMPageControlHeight);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.enabled = NO;
    [self addSubview:self.pageControl];
}

@end
    
@implementation PMZoomableImageFilmstrip
{
    BOOL _delegateRespondsToWillZoom;
    BOOL _delegateRespondsToDidZoom;
    BOOL _delegateRespondsToDidPinchToClose;
    CGFloat _pinchStartScale;
}


- (void)setDelegate:(id<PMZoomableImageFilmstripDelegate>)delegate
{
    [super setDelegate:delegate];
    _delegateRespondsToWillZoom = [delegate respondsToSelector:@selector(imageFilmstrip:willZoomImageView:)];
    _delegateRespondsToDidZoom = [delegate respondsToSelector:@selector(imageFilmstrip:didZoomImageView:toScale:)];
    _delegateRespondsToDidPinchToClose = [delegate respondsToSelector:@selector(imageFilmstrip:didPinchToCloseImageView:)];
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
    cell.scrollView.zoomScale = 1.0f;
    cell.scrollView.maximumZoomScale = self.maximumZoomScale;
    cell.scrollView.delegate = self;
    [cell.doubleTap addTarget:self action:@selector(didDoubleTap:)];
    [cell.scrollView.pinchGestureRecognizer addTarget:self action:@selector(handlePinch:)];
    return cell;
}

- (void) didDoubleTap:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    [scrollView setZoomScale:(scrollView.zoomScale == 1.0f)? scrollView.maximumZoomScale : 1.0f animated:YES];
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
            UIScrollView *scrollView = (UIScrollView *)pinch.view;
            if (_pinchStartScale == 1.0f && scrollView.zoomScale <= 1.0f && _delegateRespondsToDidPinchToClose) {
                NSParameterAssert([scrollView.subviews.firstObject isKindOfClass:[UIImageView class]]);
                [self.delegate imageFilmstrip:self didPinchToCloseImageView:scrollView.subviews.firstObject];
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
        [self.delegate imageFilmstrip:self willZoomImageView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIImageView *)view atScale:(CGFloat)scale
{
    self.collectionView.scrollEnabled = (scale == 1.0f);
    if (_delegateRespondsToDidZoom) {
        [self.delegate imageFilmstrip:self didZoomImageView:view toScale:scale];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSParameterAssert([scrollView.subviews.firstObject isKindOfClass:[UIImageView class]]);
    return scrollView.subviews.firstObject;
}

@end
