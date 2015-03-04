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
//  PMCircularCollectionView.m
//  Created by Peter Meyers on 3/19/14.
//
//

#import "PMCircularCollectionView.h"
#import "PMProtocolInterceptor.h"
#import "UIColor+PMUtils.h"

static NSUInteger const ContentMultiplier = 4;

@interface PMCircularCollectionView ()
@property (nonatomic) BOOL circularImplicitlyDisabled;
@end

@implementation PMCircularCollectionView
{
    CAGradientLayer *_shadowLayer;
    PMProtocolInterceptor *_delegateInterceptor;
    PMProtocolInterceptor *_dataSourceInterceptor;
    BOOL _delegateRespondsToScrollViewDidScroll;
    BOOL _delegateRespondsToSizeForItemAtIndexPath;
    BOOL _delegateRespondsToMinimumInteritemSpacingForSectionAtIndex;
    BOOL _delegateRespondsToMinimumLineSpacingForSectionAtIndex;
}

@synthesize circularDisabled = _explicitlyDisabled;

+ (instancetype) collectionViewWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

+ (instancetype) collectionView
{
    return [[self alloc] init];
}

- (instancetype) init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]];
}

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self PM_commonCircularCollectionViewInit];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self PM_commonCircularCollectionViewInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self PM_recenterIfNecessary];
}

- (void) setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self PM_resetShadowLayer];
}


#pragma mark - Accessors


- (void)setDataSource:(NSObject <UICollectionViewDataSource> *)dataSource
{
    [super setDataSource:nil];
    _dataSourceInterceptor.receiver = dataSource;
    [super setDataSource:(id)_dataSourceInterceptor];
}

- (void)setDelegate:(NSObject<UICollectionViewDelegateFlowLayout> *)delegate
{
    [super setDelegate:nil];
    _delegateInterceptor.receiver = delegate;
    [super setDelegate:(id)_delegateInterceptor];
    
    _delegateRespondsToScrollViewDidScroll = [delegate respondsToSelector:@selector(scrollViewDidScroll:)];
    _delegateRespondsToSizeForItemAtIndexPath = [delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
    _delegateRespondsToMinimumInteritemSpacingForSectionAtIndex = [delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)];
    _delegateRespondsToMinimumLineSpacingForSectionAtIndex = [delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)];
}

- (void) setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius != shadowRadius) {
        _shadowRadius = shadowRadius;
        [self PM_resetShadowLayer];
    }
}

- (void) setShadowColor:(UIColor *)shadowColor
{
    if (![_shadowColor isEqual:shadowColor]) {
        _shadowColor = shadowColor;
        [self PM_resetShadowLayer];
    }
}

- (void) setCircularDisabled:(BOOL)circularDisabled
{
	if (_explicitlyDisabled != circularDisabled) {
		_explicitlyDisabled = circularDisabled;
		[self PM_resetShadowLayer];
		[self reloadData];
	}
}

- (void) setCircularImplicitlyDisabled:(BOOL)circularImplicitlyDisabled
{
	if (_circularImplicitlyDisabled != circularImplicitlyDisabled) {
		_circularImplicitlyDisabled = circularImplicitlyDisabled;
		[self PM_resetShadowLayer];
	}
}


#pragma mark - Public Methods


- (BOOL) circularActive
{
    return !_explicitlyDisabled && !_circularImplicitlyDisabled;
}

- (NSIndexPath *) normalizedIndexPath:(NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForItem:(_itemCount? indexPath.item % _itemCount : 0) inSection:indexPath.section];
}

#pragma mark - UICollectionViewDatasource Methods


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(PMCircularCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSParameterAssert([collectionView isKindOfClass:[PMCircularCollectionView class]]);
    
    _itemCount = [_dataSourceInterceptor.receiver collectionView:collectionView numberOfItemsInSection:section];
    self.circularImplicitlyDisabled = [self PM_disableCircularInternallyBasedOnContentSize];
    return [self circularActive]? _itemCount * ContentMultiplier : _itemCount;
}


#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_shadowLayer.hidden == NO) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _shadowLayer.position = scrollView.contentOffset;
        [CATransaction commit];
    }
    
    if (_delegateRespondsToScrollViewDidScroll) {
        [_delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
}


#pragma mark - Private Methods


- (void) PM_commonCircularCollectionViewInit;
{
    NSSet *delegateProtocols = [NSSet setWithObjects:
                                @protocol(UICollectionViewDelegate),
                                @protocol(UIScrollViewDelegate),
                                @protocol(UICollectionViewDelegateFlowLayout), nil];
    
    _delegateInterceptor = [PMProtocolInterceptor interceptorWithMiddleMan:self forProtocols:delegateProtocols];
    [super setDelegate:(id)_delegateInterceptor];
    
    _dataSourceInterceptor = [PMProtocolInterceptor interceptorWithMiddleMan:self forProtocol:@protocol(UICollectionViewDataSource)];
    [super setDataSource:(id)_dataSourceInterceptor];
	
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void) PM_recenterIfNecessary
{
    if ([self circularActive]) {
        
        CGPoint currentOffset = self.contentOffset;
        
        switch (self.collectionViewLayout.scrollDirection) {
                
            case UICollectionViewScrollDirectionHorizontal: {
                
                CGFloat contentCenteredX = (self.contentSize.width - self.bounds.size.width) / 2.0f;
                CGFloat deltaFromCenter = currentOffset.x - contentCenteredX;
                CGFloat singleContentWidth = self.contentSize.width / ContentMultiplier;
                
                if (fabsf(deltaFromCenter) >= singleContentWidth ) {
                    
                    CGFloat correction = (deltaFromCenter > 0)? deltaFromCenter - singleContentWidth : deltaFromCenter + singleContentWidth;
                    
                    currentOffset.x = contentCenteredX + correction;
                }
                break;
            }
            case UICollectionViewScrollDirectionVertical: {
                
                CGFloat contentCenteredY = (self.contentSize.height - self.bounds.size.height) / 2.0f;
                CGFloat deltaFromCenter = currentOffset.y - contentCenteredY;
                CGFloat singleContentHeight = self.contentSize.height / ContentMultiplier;
                
                if (fabsf(deltaFromCenter) >= singleContentHeight) {
                    
                    CGFloat correction = (deltaFromCenter > 0)? deltaFromCenter - singleContentHeight : deltaFromCenter + singleContentHeight;
                    
                    currentOffset.y = contentCenteredY + correction;
                }
                break;
            }
        }
        self.contentOffset = currentOffset;
    }
}

- (void) PM_resetShadowLayer
{
    if (self.shadowRadius && self.shadowColor.alpha && [self circularActive]) {
        
		if (!_shadowLayer) {
			_shadowLayer = [CAGradientLayer layer];
			[self.layer addSublayer:_shadowLayer];
		}
		
        UIColor *outerColor = self.shadowColor;
        UIColor *innerColor = [self.shadowColor colorWithAlphaComponent:0.0];
		
        _shadowLayer.frame = self.bounds;
        _shadowLayer.colors = @[(id)outerColor.CGColor, (id)innerColor.CGColor, (id)innerColor.CGColor, (id)outerColor.CGColor];
        _shadowLayer.anchorPoint = CGPointZero;
        _shadowLayer.position = self.contentOffset;
		
        CGFloat totalDistance;
        switch (self.collectionViewLayout.scrollDirection) {
                
            case UICollectionViewScrollDirectionHorizontal:
                totalDistance = self.bounds.size.width;
                _shadowLayer.startPoint = CGPointMake(0.0f, 0.5f);
                _shadowLayer.endPoint = CGPointMake(1.0f, 0.5f);
                break;
                
            case UICollectionViewScrollDirectionVertical:
                totalDistance = self.bounds.size.height;
                _shadowLayer.startPoint = CGPointMake(0.5f, 0.0f);
                _shadowLayer.endPoint = CGPointMake(0.5f, 1.0f);
                break;
        }
        
        CGFloat location1 = self.shadowRadius / totalDistance;
        CGFloat location2 = 1.0f - location1;
        _shadowLayer.locations = @[@0.0, @(location1), @(location2), @1.0];
		[_shadowLayer removeAllAnimations];
		_shadowLayer.hidden = NO;
    }
	else {
		_shadowLayer.hidden = YES;
	}
}

- (BOOL) PM_disableCircularInternallyBasedOnContentSize
{
    CGSize requiredContentSize = [self PM_calculateRequiredContentSize];
    CGSize spacingSize = [self PM_calculateSpacingSize];
    
    switch (self.collectionViewLayout.scrollDirection)
    {
        case UICollectionViewScrollDirectionHorizontal: return  requiredContentSize.width + spacingSize.width < self.bounds.size.width;
        case UICollectionViewScrollDirectionVertical: return requiredContentSize.height + spacingSize.height < self.bounds.size.height;
    }
}

- (CGSize) PM_calculateRequiredContentSize
{
    CGSize contentSize = CGSizeZero;
    CGSize largestItem = CGSizeZero;
    
    if (_delegateRespondsToSizeForItemAtIndexPath) {
        for (NSUInteger i = 0; i < _itemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CGSize itemSize = [self.delegate collectionView:self layout:self.collectionViewLayout sizeForItemAtIndexPath:indexPath];
            contentSize.height += itemSize.height;
            contentSize.width += itemSize.width;
            
            if (itemSize.width > largestItem.width) {
                largestItem.width = itemSize.width;
            }
            if (itemSize.height > largestItem.height) {
                largestItem.height = itemSize.height;
            }
        }
    }
    else {
        contentSize.height += self.collectionViewLayout.itemSize.height * _itemCount;
        contentSize.width += self.collectionViewLayout.itemSize.width * _itemCount;
        largestItem = self.collectionViewLayout.itemSize;
    }
    return CGSizeMake(contentSize.width - largestItem.width, contentSize.height - largestItem.height);
}

- (CGSize) PM_calculateSpacingSize
{
    CGFloat lineSpacing = _delegateRespondsToMinimumLineSpacingForSectionAtIndex? [self.delegate collectionView:self layout:self.collectionViewLayout minimumLineSpacingForSectionAtIndex:0] : (_itemCount * self.collectionViewLayout.minimumLineSpacing);
    CGFloat interitemSpacing = _delegateRespondsToMinimumInteritemSpacingForSectionAtIndex? [self.delegate collectionView:self layout:self.collectionViewLayout minimumInteritemSpacingForSectionAtIndex:0] : (_itemCount * self.collectionViewLayout.minimumInteritemSpacing);
    
    switch (self.collectionViewLayout.scrollDirection) {
        case UICollectionViewScrollDirectionVertical: return CGSizeMake(interitemSpacing, lineSpacing);
        case UICollectionViewScrollDirectionHorizontal: return CGSizeMake(lineSpacing, interitemSpacing);
    }
}

@end
