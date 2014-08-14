//
//  NSObject+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import "NSObject+PMUtils.h"

@implementation NSObject (PMUtils)

- (instancetype) ifKindOfClass:(Class)aClass
{
    return [self isKindOfClass:aClass]? self : nil;
}

@end
