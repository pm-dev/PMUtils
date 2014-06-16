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
//  Created by Peter Meyers on 5/5/14.
//
//

#import "NSDictionary+PMUtils.h"
#import "NSString+PMUtils.h"

@implementation NSDictionary (PMUtils)

- (NSDictionary *) replaceKey:(id<NSCopying>)currentKey withKey:(id<NSCopying>)newKey
{
    id value = self[currentKey];
    if (value) {
        NSMutableDictionary *mutableSelf = [self mutableCopy];
        mutableSelf[newKey] = value;
        [mutableSelf removeObjectForKey:currentKey];
        return mutableSelf;
    }
    return self;
}


- (NSDictionary *) convertUnderscoredStringKeysToCamelCase
{
    NSMutableDictionary *mutableSelf = [NSMutableDictionary dictionaryWithCapacity:self.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *stringKey = key;
            mutableSelf[[stringKey camelCaseFromUnderscores]] = obj;
        }
        else {
            mutableSelf[key] = obj;
        }
    }];
     
    return mutableSelf;
}

- (NSDictionary *) convertCamelCaseStringKeysToUnderscored
{
    NSMutableDictionary *mutableSelf = [NSMutableDictionary dictionaryWithCapacity:self.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *stringKey = key;
            mutableSelf[[stringKey underscoresFromCamelCase]] = obj;
        }
        else {
            mutableSelf[key] = obj;
        }
    }];
     
     return mutableSelf;
}

@end
