//
//  NSNumber+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 3/6/15.
//
//

#import "NSNumber+PMUtils.h"

@implementation NSNumber (PMUtils)

- (BOOL)isNonZero
{
    return ![self isEqual:@0];
}

@end
