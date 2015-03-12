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
//  NSDictionary+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 10/2/14.
//
//

#import "NSDictionary+PMUtils.h"
#import "NSMutableDictionary+PMUtils.h"

@implementation NSDictionary (PMUtils)

- (NSString *) JSONString
{
    if (self.count) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSAssert(!error, @"Error serializing dictionary %@. Error: %@", self, error);
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"{}";
}

- (NSDictionary *) dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mutableSelf = [NSMutableDictionary dictionaryWithDictionary:self];
    [mutableSelf addEntriesFromDictionary:dictionary];
    return [mutableSelf copy];
}

- (NSDictionary *) dictionaryByConvertingUnderscoredStringKeysToCamelCase:(BOOL)deep
{
    NSMutableDictionary *mutableSelf = [self mutableCopy];
    [mutableSelf convertUnderscoredStringKeysToCamelCase:deep];
    return [mutableSelf copy];
}

- (NSDictionary *) dictionaryByConvertingCamelCaseStringKeysToUnderscored:(BOOL)deep
{
    NSMutableDictionary *mutableSelf = [self mutableCopy];
    [mutableSelf convertCamelCaseStringKeysToUnderscored:deep];
    return [mutableSelf copy];
}

@end
