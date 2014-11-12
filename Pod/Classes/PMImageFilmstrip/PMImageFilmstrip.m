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
#import "UIView+PMUtils.h"


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


@interface PMImageFilmstrip () <UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation PMImageFilmstrip
{
	UICollectionView *_collectionView;
	UICollectionViewFlowLayout *_collectionViewFlowLayout;
	BOOL _delegateRespondsToWillScrollToImageAtIndex;
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
	NSIndexPath *indexPath = [_collectionView indexPathNearestToBoundsCenter];
	UICollectionViewLayoutAttributes *attributes = [_collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
	[_collectionView setContentOffset:attributes.frame.origin];
}

- (void) setBounds:(CGRect)bounds
{
	_collectionViewFlowLayout.itemSize = bounds.size;
	super.bounds = bounds;
	NSIndexPath *indexPath = [_collectionView indexPathNearestToBoundsCenter];
	UICollectionViewLayoutAttributes *attributes = [_collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
	[_collectionView setContentOffset:attributes.frame.origin];
}

- (void) setDelegate:(id<PMImageFilmstripDelegate>)delegate
{
	_delegate = delegate;
	_delegateRespondsToWillScrollToImageAtIndex = [_delegate respondsToSelector:@selector(imageFilmstrip:willScrollToImageAtIndex:)];
}

- (void)reloadImages;
{
    [_collectionView reloadData];
}

- (void) scrollToImageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    if (_delegateRespondsToWillScrollToImageAtIndex) {
        [_delegate imageFilmstrip:self willScrollToImageAtIndex:index];
    }
    
    [_collectionView scrollToItemAtIndexPath:indexPath
                            atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally
                                    animated:animated];
}


#pragma mark - UICollectionView DataSource & Delegate


- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section
{
    return [self.dataSource numberOfImagesInImageFilmstrip:self];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMImageFilmstripCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PMImageFilmstripCell defaultReuseIdentifier] forIndexPath:indexPath];
	[self.delegate imageFilmstrip:self
	  configureFilmstripImageView:cell.imageView
						  atIndex:indexPath.item];
	return cell;
}

- (void) scrollViewWillEndDragging:(UICollectionView *)imageFilmstrip withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	if (_delegateRespondsToWillScrollToImageAtIndex) {
        NSIndexPath *indexPath = [imageFilmstrip indexPathForItemAtPoint:*targetContentOffset];
		[_delegate imageFilmstrip:self willScrollToImageAtIndex:indexPath.item];
	}
}


#pragma mark - Private Methods


- (void) PM_commonPMImageFilmstripInit
{
	_collectionViewFlowLayout = [UICollectionViewFlowLayout new];
	_collectionViewFlowLayout.minimumLineSpacing = 0.0f;
	_collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	_collectionViewFlowLayout.itemSize = self.frame.size;
	_collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:_collectionViewFlowLayout];
	_collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[_collectionView registerClass:[PMImageFilmstripCell class] forCellWithReuseIdentifier:[PMImageFilmstripCell defaultReuseIdentifier]];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.allowsSelection = NO;
	_collectionView.pagingEnabled = YES;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.backgroundColor = [UIColor whiteColor];
	[self addSubview:_collectionView];
}

@end
