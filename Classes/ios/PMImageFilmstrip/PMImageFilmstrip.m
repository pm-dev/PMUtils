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
//  Created by Peter Meyers on 4/16/14.
//

#import "PMImageFilmstrip.h"
#import "UIImageView+PMUtils.h"

static NSString * const PMImageFilmstripCellReuseIdentifier = @"PMImageFilmstripCellReuseIdentifier";

@interface PMImageFilmstrip () <UICollectionViewDataSource>
@end

@implementation PMImageFilmstrip


+ (instancetype) imageFilmstripWithFrame:(CGRect)frame imageEntities:(NSArray *)imageEntities
{
	return [[self alloc] initWithFrame:frame imageEntities:imageEntities];
}

- (instancetype) initWithFrame:(CGRect)frame imageEntities:(NSArray *)imageEntities
{
	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = frame.size;
    layout.minimumLineSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewLayout = layout;
	
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		_imageEntities = imageEntities;
		[self _commonPMImageFilmstripInit];
	}
	return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self _commonPMImageFilmstripInit];
}

- (void) setImageEntities:(NSArray *)imageEntities
{
    if (_imageEntities != imageEntities) {
        _imageEntities = imageEntities;
        [self reloadData];
    }
}


#pragma mark - UICollectionView DataSource Delegate


- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section
{
    return self.imageEntities.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PMImageFilmstripCellReuseIdentifier forIndexPath:indexPath];
	
	UIImageView *imageView = nil;
	if (cell.contentView.subviews.count) {
		imageView = cell.contentView.subviews.firstObject;
	}
	else {
		imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:imageView];
	}
	
	id imageEntity = self.imageEntities[indexPath.item];
	[imageView setImageEntity:imageEntity];

	return cell;
}


#pragma mark - Private Methods


- (void) _commonPMImageFilmstripInit
{
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PMImageFilmstripCellReuseIdentifier];
    self.dataSource = self;
    self.allowsSelection = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
}


@end
