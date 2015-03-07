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
//  NSString+PMUtils.m
//  Created by Peter Meyers on 3/1/14.
//
//

#import "NSString+PMUtils.h"
#import "NSData+PMUtils.h"
#import "NSRegularExpression+PMUtils.h"

@implementation NSString (PMUtils)

- (BOOL) isNonEmpty
{
    return ![[NSNull null] isEqual:self] && self.length;
}

- (NSString *) stringByRemovingCharactersInSet:(NSCharacterSet *)characterSet
{
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
}

- (NSString *) encodedURLQuery
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)sha1Hash
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data sha1Hash];
    return [hash hexString];
}

- (NSString *)md5Hash
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data md5Hash];
    return [hash hexString];
}

- (NSString *)base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)options
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:options];
}

- (NSData *)base64EncodedDataWithOptions:(NSDataBase64EncodingOptions)options
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedDataWithOptions:options];
}

- (BOOL) isCapitalized
{
    return [[self capitalizedString] isEqualToString:self];
}

- (NSComparisonResult) compareWithVersion:(NSString *)otherVersion
{
    // We want 1.0 and 1.0.0 to return NSOrderedSame.
    NSParameterAssert([self PM_isVersionString]);
    NSParameterAssert([otherVersion PM_isVersionString]);
    NSString *v1 = [self PM_removeTrailingZerosAndPeriods];
    NSString *v2 = [otherVersion PM_removeTrailingZerosAndPeriods];
    return [v1 compare:v2 options:NSNumericSearch];
}

- (BOOL) inVersion:(NSString *)baseVersion
{
    NSParameterAssert([self PM_isVersionString]);
    NSParameterAssert([baseVersion PM_isVersionString]);
    NSString *receiver = [self PM_removeTrailingZerosAndPeriods];
    NSString *base = [baseVersion PM_removeTrailingZerosAndPeriods];
    NSRange range = [receiver rangeOfString:base];
    return range.location == 0;
}

- (BOOL)containsEmoji
{
    static dispatch_once_t once;
    static NSRegularExpression *regex;
    dispatch_once(&once, ^{
        NSError *error = nil;
        regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:&error];
        NSParameterAssert(!error);
    });
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return numberOfMatches != 0;
}

- (NSString *) stringByCapitalizingFirstLetter
{
    if (self.length) {
        NSString *firstLetter = [self substringToIndex:1];
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstLetter uppercaseString]];
    }
    return self;
}

- (NSString *) stringByLowercasingFirstLetter {
    if (self.length) {
        NSString *firstLetter = [self substringToIndex:1];
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstLetter lowercaseString]];
    }
    return self;
}

- (NSString *) camelCaseFromUnderscores
{
    NSArray *components = [self componentsSeparatedByString:@"_"];
    NSMutableString *output = [NSMutableString stringWithString:components[0]];
    
    for (NSUInteger i = 1; i < components.count; i++) {
        NSString *component = components[i];
        [output appendString:[component stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                withString:[[component substringToIndex:1] uppercaseString]]];
    }
    return [output copy];
}

- (NSString *) underscoresFromCamelCase
{
    NSMutableString *output = [[self substringToIndex:1] mutableCopy];
    NSCharacterSet *uppercaseCharacters = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *whitespaceCharacters = [NSCharacterSet whitespaceCharacterSet];
    
    for (NSInteger i = 1; i < self.length; i++ ) {
        unichar c = [self characterAtIndex:i];
        if ([uppercaseCharacters characterIsMember:c] &&
            ![whitespaceCharacters characterIsMember:[self characterAtIndex:i-1]]) {
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        }
        else {
            [output appendFormat:@"%C", c];
        }
    }
    return [output copy];
}

- (id)JSONObject:(NSJSONReadingOptions)options error:(NSError **)outError;
{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:options error:outError];
}

#pragma mark - Internal Methods

- (NSString *) PM_removeTrailingZerosAndPeriods
{
    NSRange rangeToDelete = NSMakeRange(self.length, 0);
    char lastChar = [self characterAtIndex:rangeToDelete.location-1];
    while (lastChar == '.' || lastChar == '0')
    {
        rangeToDelete.location--;
        rangeToDelete.length++;
        lastChar = [self characterAtIndex:rangeToDelete.location-1];
    }
    return [self stringByReplacingCharactersInRange:rangeToDelete withString:@""];
}

- (BOOL) PM_isVersionString
{
    NSArray *components = [self componentsSeparatedByString:@"."];
    BOOL isVersionString = YES;
    for (NSString *integerString in components) {
        if ([[integerString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] isEqualToString:@""] == NO) {
            isVersionString = NO;
            break;
        }
    }
    return isVersionString;
}

@end
