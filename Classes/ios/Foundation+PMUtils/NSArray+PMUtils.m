//
//  NSArray+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/26/14.
//
//

#import "NSArray+PMUtils.h"

@implementation NSArray (PMUtils)

- (BOOL) isItenticalToArray:(NSArray *)otherArray
{
    if (self.count == otherArray.count) {
        __block BOOL identical = YES;
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj != otherArray[idx]) {
                identical = NO;
                *stop = YES;
            }
        }];
        return identical;
    }
    return NO;
}

@end
