//
//  UIResponder+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 1/29/15.
//
//

#import "UIResponder+PMUtils.h"

@implementation UIResponder (PMUtils)

static __weak id PMCurrentFirstResponder;

+ (UIResponder *)firstResponder
{
    PMCurrentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(PM_findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return PMCurrentFirstResponder;
}


#pragma mark - Internal


- (void) PM_findFirstResponder:(id)sender
{
    PMCurrentFirstResponder = self;
}

@end
