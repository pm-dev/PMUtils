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

- (CGFloat) heightFittinghWidth:(CGFloat)width
{
    self.bounds = CGRectMake(0.0f, 0.0f, width, UILayoutFittingExpandedSize.height);
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
