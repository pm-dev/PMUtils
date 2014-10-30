//
//  NSArray+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/26/14.
//
//

#import "NSArray+PMUtils.h"

@implementation NSArray (PMUtils)

- (BOOL) isIdenticalToArray:(NSArray *)otherArray
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

- (BOOL) compareToArray:(NSArray *)otherArray withKey:(NSString *)key;
{
    if (self.count == otherArray.count) {
        __block BOOL equal = YES;
        [self enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
            id obj2 = otherArray[idx];
            id value1 = [obj1 valueForKey:key];
            id value2 = [obj2 valueForKey:key];
            if (![value1 isEqual:value2]) {
                equal = NO;
                *stop = YES;
            }
        }];
        return equal;
    }
    return NO;
}

- (NSArray *) distinctArray
{
    NSArray *unique = [self valueForKeyPath:@"@distinctUnionOfObjects.self"];
    NSParameterAssert([unique isKindOfClass:[NSArray class]] && unique.count <= self.count);
    return unique;
}

- (NSString *) JSONString
{
    if (self.count) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSAssert(!error, @"Error serializing dictionary %@. Error: %@", self, error);
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"[]";
}

@end
