//
//  UITableViewCell+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 11/12/14.
//
//

#import "UITableViewCell+PMUtils.h"

@implementation UITableViewCell (PMUtils)

+ (NSString *)defaultReuseIdentifier
{
    return NSStringFromClass(self);
}

- (CGSize) sizeThatFitsConfiguredCell
{
    [self layoutIfNeeded];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
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
