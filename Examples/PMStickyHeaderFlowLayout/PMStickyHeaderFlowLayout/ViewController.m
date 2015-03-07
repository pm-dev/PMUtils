//
//  ViewController.m
//  PMStickyHeaderFlowLayout
//
//  Created by Peter Meyers on 3/7/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMStickyHeaderFlowLayout.h"

@interface ViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet PMStickyHeaderFlowLayout *stickyHeader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stickyHeader.stickyHeaderEnabled = YES;
    self.stickyHeader.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 100.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 80;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor =[UIColor whiteColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    header.backgroundColor = [UIColor greenColor];
    return header;
}



@end
