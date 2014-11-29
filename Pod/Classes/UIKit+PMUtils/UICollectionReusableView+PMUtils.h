//
//  UICollectionReusableView+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 11/12/14.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionReusableView (PMUtils)

/**
 *  The default reuse identifier is simply the name of the class. Override this method to change the default reuse identifier.
 *
 *  @return The default reuse identifier.
 */
+ (NSString *) defaultReuseIdentifier;

- (UICollectionView *) collectionView;

@end
