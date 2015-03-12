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
//  NSDictionary+PMUtils.h
//  Created by Peter Meyers on 5/5/14.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PMUtils)

/**
 *  Sets the value associated with currentKey with newKey and removes currentKey from the dictionary.
 *  This method does nothing if nothing is associated with currentKey.
 *
 *  @param currentKey The key to replace. Must not be nil.
 *  @param newKey     A new key to associate currentKey's value with. Must not be nil.
 */
- (void) replaceKey:(id<NSCopying>)currentKey withKey:(id<NSCopying>)newKey;

/**
 *  All keys in the receiver of type NSString are converted to camelCase if they contain underscores.
 *  Keys that are not strings or do not contain underscores are not affected.
 *  e.g. @"this_is_underscored" becomes @"thisIsUnderscored"
 *
 *  @param deep A boolean indicating whether to recursively convert keys when a value happens to be
 *  a dictionary, or if the value is an array, searching for any dictionaries in the array to 
 *  recursively convert.
 */
- (void) convertUnderscoredStringKeysToCamelCase:(BOOL)deep;

/**
 *  All keys in the receiver of type NSString and formatted in camelCase are converted to underscores.
 *  Keys that are not strings or are not camelCase are not affected.
 *  e.g. @"thisIsCamelCase" becomes @"this_is_camel_case"
 *
 *  @param deep A boolean indicating whether to recursively convert keys when a value happens to be
 *  a dictionary, or if the value is an array, searching for any dictionaries in the array to
 *  recursively convert.
 */
- (void) convertCamelCaseStringKeysToUnderscored:(BOOL)deep;

@end
