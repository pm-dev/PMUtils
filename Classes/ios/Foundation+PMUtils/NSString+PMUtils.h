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
//  NSString+PMUtils.h
//  Created by Peter Meyers on 3/1/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PMUtils)

/**
 *  Returns a new string made from the receiver by replacing all characters not in the specified set 
 *  with percent encoded characters allowed in a query URL component. UTF-8 encoding is used to determine the correct percent encoded characters. 
 *  Entire URL strings cannot be percent-encoded. This method is intended to percent-encode an URL query, NOT the entire URL string.
 *  The query component of a URL is the component immediately following a question mark (?). 
 *  For example, in the URL http://www.example.com/index.php?key1=value1#jumpLink, the query component is key1=value1.
 *  
 *  @return The encoded string or nil if the transformation is not possible.
 */
- (NSString *) encodedURLQuery;

/**
 *  Returns a SHA1 hash of the receiver, expressed as a 160 bit hex number.
 *
 *  @return A new string representing the SHA1 hash of the receiver.
 */
- (NSString *)sha1Hash;

/**
 *  Returns a MD5 hash of the receiver, expressed as a 128 bit hex number.
 *
 *  @return A new string representing the MD5 hash of the receiver.
 */
- (NSString *)md5Hash;

/**
 *  Compares the receiver to its capitalized string.
 *
 *  @return YES if the reciever is equal to [self capitalizedString], otherwise NO.
 */
- (BOOL) isCapitalized;

/**
 *  Compares the receiver to otherVersion after stripping any trailing periods or zeros. The receiver must be a string of dot, '.',
 *	separated integers.
 *
 *  @param otherVersion A string of dot separated integers to compare with the receiver. Must not be nil.
 *
 *  @return Returns an NSComparisonResult value that indicates the lexical ordering of the receiver and otherVersion. 
 *  NSOrderedAscending if the receiver precedes otherVersion, NSOrderedSame if the receiver and otherVersion are equivalent in lexical value,
 *  and NSOrderedDescending if the receiver follows otherVersion.
 */
- (NSComparisonResult) compareWithVersion:(NSString *)otherVersion;

/**
 *  For a version string to be considered 'in' another version string (base version), the base version
 *  must be a substring of the reciever, after trailing zeros and periods have been removed, where the substring starts at index 0.
 *  1.2.8 is not included in 1.2.9
 *  1.2 is not included in 1.2.9
 *  1.2.8 is included in 1.2
 *  1.2.3 is included in 1.2.3
 *
 *  @param baseVersion A string of dot separated integers.
 *
 *  @return YES if the receiver is 'in' baseVersion, otherwise NO.
 */
- (BOOL) inVersion:(NSString *)baseVersion;

/**
 *  Checks for an emoji character in the receiver.
 *
 *  @return YES if the receiver contains an emoji character, otherwise NO.
 */
- (BOOL) containsEmoji;

/**
 *  If the receiver contains one or more sequential underscores, the first character following the underscore(s)
 *  is capitalized and the underscores are removed.
 *
 *  For example @"this_is__underscored" becomes @"thisIsUnderscored"
 *
 *  @return A camelCased string.
 */
- (NSString *) camelCaseFromUnderscores;


/**
 *  If an uppercase character in the receiver is preceeded by a lowercase character, and underscore '_' character is added
 *  before the uppercase character and the uppercase character is converted to lowercase.
 *
 *  For example, @"thisIsCamelCase" becomes @"this_is_camel_case"
 *
 *  @return An underscored string.
 */
- (NSString *) underscoresFromCamelCase;

@end
