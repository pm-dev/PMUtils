//
//  UICollectionReusableView+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 11/12/14.
//
//

#import "UICollectionReusableView+PMUtils.h"

@implementation UICollectionReusableView (PMUtils)

+ (NSString *)defaultReuseIdentifier
{
    return NSStringFromClass(self);
}

- (UICollectionView *) collectionView
{
    UIView *view = self.superview;
    while (view != nil) {
        if ([view isKindOfClass:[UICollectionView class]]) {
            break;
        }
        view = view.superview;
    }
    return (UICollectionView *)view;
}

@end
