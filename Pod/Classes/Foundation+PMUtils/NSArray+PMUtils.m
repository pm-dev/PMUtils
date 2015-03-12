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
