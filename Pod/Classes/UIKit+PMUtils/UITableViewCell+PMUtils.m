//
//  UITableViewCell+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 11/12/14.
//
//

#import "UITableViewCell+PMUtils.h"

@implementation UITableViewCell (PMUtils)


static inline NSMutableDictionary *PMSharedSizingCellsByReuseIdentifier() {
    static NSMutableDictionary *_sharedSizingCellsByReuseIdentifier = nil;
    static dispatch_once_t cacheToken;
    dispatch_once(&cacheToken, ^{
        _sharedSizingCellsByReuseIdentifier = [@{} mutableCopy];
    });
    return _sharedSizingCellsByReuseIdentifier;
}

+ (instancetype) sizingCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    NSMutableDictionary *sharedDictionary = PMSharedSizingCellsByReuseIdentifier();
    UITableViewCell *cell = sharedDictionary[reuseIdentifier];
    if (!cell) {
        cell = [[self new] dequeueReusableCellWithIdentifier:reuseIdentifier];
        sharedDictionary[reuseIdentifier] = cell;
    }
    return cell;
}

+ (NSString *)defaultReuseIdentifier
{
    return NSStringFromClass(self);
}

- (CGFloat) heightFittingWidth:(CGFloat)width
{
    self.bounds = CGRectMake(0.0f, 0.0f, width, CGRectGetHeight(self.bounds));
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (UITableView *) tableView
{
    UIView *view = self.superview;
    while (view != nil) {
        if ([view isKindOfClass:[UITableView class]]) {
            break;
        }
        view = view.superview;
    }
    return (UITableView *)view;
}

@end
