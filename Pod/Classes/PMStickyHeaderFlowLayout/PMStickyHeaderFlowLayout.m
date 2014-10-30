//
//  PMStickyHeaderFlowLayout
//
//  Created by Peter Meyers on 3/26/14.
//  Copyright (c) 2014 Hunters Alley. All rights reserved.
//

#import "PMStickyHeaderFlowLayout.h"

@implementation PMStickyHeaderFlowLayout


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	if (_stickyHeaderEnabled) {
		
		NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
		
		NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
		
		for (NSUInteger idx=0; idx < attributes.count; idx++) {
			UICollectionViewLayoutAttributes *layoutAttributes = attributes[idx];
			
			if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell || layoutAttributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
				[missingSections addIndex:(NSUInteger) layoutAttributes.indexPath.section];  // remember that we need to layout header for this section
			}
			if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
				[attributes removeObjectAtIndex:idx];  // remove layout of header done by our super, we will do it right later
				idx--;
			}
		}
		
		//    layout all headers needed for the rect using self code
		[missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
			
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
			UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
			if (layoutAttributes) {
				[attributes addObject:layoutAttributes];
			}
		}];
		
		return attributes;
	}
	
	return [super layoutAttributesForElementsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	if (_stickyHeaderEnabled) {
		
		UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
		
		if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
			
			UICollectionView * const cv = self.collectionView;
			
			CGPoint nextHeaderOrigin = CGPointMake(MAXFLOAT, MAXFLOAT);
			
			if (indexPath.section+1 < [cv numberOfSections]) {
				
				NSIndexPath *nextSection = [NSIndexPath indexPathForItem:0 inSection:indexPath.section+1];
				UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:nextSection];
				nextHeaderOrigin = nextHeaderAttributes.frame.origin;
			}

            
			CGRect frame = attributes.frame;
			switch (self.scrollDirection) {
				case UICollectionViewScrollDirectionHorizontal:
					frame.origin.x = fminf(fmaxf(cv.contentOffset.x + cv.contentInset.left, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame) - cv.contentInset.right);
					break;
					
				case UICollectionViewScrollDirectionVertical:
					frame.origin.y = fminf(fmaxf(cv.contentOffset.y + cv.contentInset.top, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame) - cv.contentInset.bottom);
					break;
			}
			
			attributes.zIndex = 1024;
			attributes.frame = frame;
		}
		
		return attributes;
	}
	
	return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
	if (_stickyHeaderEnabled) {
		return YES;
	}
	return [super shouldInvalidateLayoutForBoundsChange:newBound];
}

@end
