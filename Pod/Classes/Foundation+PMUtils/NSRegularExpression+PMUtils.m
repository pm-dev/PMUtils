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
//  NSRegularExpression+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import "NSRegularExpression+PMUtils.h"

@implementation NSRegularExpression (PMUtils)


- (NSString *)stringByReplacingMatchesInString:(NSString *)string
                                       options:(NSMatchingOptions)options
                                         range:(NSRange)range
                                      template:(NSString *)templateString
                                    withString:(NSString * (^) (NSString *match))replacementWithMatch
{
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    
    [self enumerateMatchesInString:string options:options range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange resultRange = result.range;
        resultRange.location += offset;
        NSString *match = [self replacementStringForResult:result inString:mutableString offset:offset template:templateString];
        NSString *replacement = replacementWithMatch(match);
        [mutableString replaceCharactersInRange:resultRange withString:replacement];
        offset += (replacement.length - resultRange.length);
    }];
    
    return [mutableString copy];
}


@end
