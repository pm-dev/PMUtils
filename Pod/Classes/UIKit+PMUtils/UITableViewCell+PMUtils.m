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
//  UITableViewCell+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 11/12/14.
//
//

#import "UITableViewCell+PMUtils.h"
#import "UIView+PMUtils.h"

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
    reuseIdentifier = reuseIdentifier?: [self defaultReuseIdentifier];
    NSMutableDictionary *sharedDictionary = PMSharedSizingCellsByReuseIdentifier();
    UITableViewCell *cell = sharedDictionary[reuseIdentifier];
    if (!cell) {
        cell = [self viewFromDefaultNibWithOwner:nil];
        if (!cell) {
            cell = [self new];
        }
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
