//
//  UIGestureRecognizer+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 11/29/14.
//
//

#import "UIGestureRecognizer+PMUtils.h"

@implementation UIGestureRecognizer (PMUtils)

- (void) cancel
{
    if (self.enabled) {
        self.enabled = NO;
        self.enabled = YES;
    }
}

@end
