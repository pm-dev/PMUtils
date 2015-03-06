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
//  PMViewController.m
//  Created by Peter Meyers on 3/19/14.
//

#import "PMViewController.h"
#import "PMCenteredCircularCollectionView.h"
#import "UICollectionView+PMUtils.h"

static NSString * const PMCellReuseIdentifier = @"PMCellReuseIdentifier";

@interface PMViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation PMViewController
{
	PMCenteredCircularCollectionView *_collectionView;
	NSArray *_images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _images = @[[UIImage imageNamed:@"stock_photo1.jpg"],
				[UIImage imageNamed:@"stock_photo2.jpg"],
				[UIImage imageNamed:@"stock_photo3.jpg"],
				[UIImage imageNamed:@"stock_photo4.jpg"],
				[UIImage imageNamed:@"stock_photo5.jpg"]];
    
    CGRect frame = self.view.bounds;
    
    PMCenteredCollectionViewFlowLayout *layout = [PMCenteredCollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 50.0f;
	CGFloat minDimension = fmin(self.view.bounds.size.width, self.view.bounds.size.height);
    layout.itemSize = CGSizeMake(minDimension, minDimension);
    
    _collectionView = [[PMCenteredCircularCollectionView alloc] initWithFrame:frame
                                                             collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
	_collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.shadowRadius = 10.0f;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PMCellReuseIdentifier];
    [_collectionView setDataSource:self];
    
    [self.view addSubview:_collectionView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [_collectionView setCenteredIndex:2 animated:YES];
}

#pragma mark - PMCircularCollectionViewDataSource Methods

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (NSInteger)_images.count;
}

- (UICollectionViewCell *) collectionView:(PMCenteredCircularCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PMCellReuseIdentifier forIndexPath:indexPath];
    NSIndexPath *normalizedIndexPath = [collectionView normalizedIndexPath:indexPath];
    if (!cell.contentView.subviews.count) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    UIImageView *imageView = cell.contentView.subviews.lastObject;
    imageView.image = _images[(NSUInteger)normalizedIndexPath.item];
    return cell;
}

@end
