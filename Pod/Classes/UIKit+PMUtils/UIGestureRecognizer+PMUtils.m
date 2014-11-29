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
    BOOL isEnabled = self.enabled;
    self.enabled = !isEnabled;
    self.enabled = isEnabled;
}

@end
