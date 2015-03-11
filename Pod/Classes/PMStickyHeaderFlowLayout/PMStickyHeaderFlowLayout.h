//
//  PMStickyHeaderFlowLayout.h
//
//  Created by Peter Meyers on 3/26/14.
//  Copyright (c) 2014 Hunters Alley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMStickyHeaderFlowLayout : UICollectionViewFlowLayout

/**
 *  A boolean value controlling whether the flow layout forces supplementary views of kind
 *  UICollectionElementKindSectionHeader to "stick" to the top of the collection view's content while
 *  scrolling, much like table view headers.
 */
@property (nonatomic) BOOL stickyHeaderEnabled;

@end
