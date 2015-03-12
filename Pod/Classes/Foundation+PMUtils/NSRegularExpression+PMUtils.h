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
//  NSRegularExpression+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (PMUtils)


/**
 *  Used to perform substitution for multiple matches on a given input string. The receiver looks for matches on a given input string and replaces the contents of each match
 *  with a string supplied by the 'replacementWithMatch' block.
 *
 *  @param string               The string to search.
 *  @param options              The matching options to report. See “NSMatchingOptions” for the supported values.
 *  @param range                The range of the string to test.
 *  @param templateString       The template string to use when creating each match. Use $0 to see the entire match. See “Flag Options” for the format of template.
 *  @param replacementWithMatch A block that takes a match string as input and returns the string that will replace the match.
 *
 *  @return A replacement string.
 */
- (NSString *)stringByReplacingMatchesInString:(NSString *)string
                                       options:(NSMatchingOptions)options
                                         range:(NSRange)range
                                      template:(NSString *)templateString
                                    withString:(NSString* (^) (NSString* match))replacementWithMatch;

@end
