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
//  NSArray+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 8/26/14.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (PMUtils)


/**
 *  Compares the receiving array to another array. Two arrays are identical if they each hold the same 
 *  number of objects and objects at a given index in each array have pointer equality.
 *
 *  @param otherArray An array.
 *
 *  @return YES if the contents of otherArray have pointer equality to the contents of the receiving array, otherwise NO.
 */
- (BOOL) isIdenticalToArray:(NSArray *)otherArray;

/**
 *  Compares the receiving array to another array. This method looks up the value at a key path for objects at a given index in each array,
 *  and compares those values using isEqual:. If any comparison returns false, this method will return false.
 *
 *  @param otherArray An array
 *  @param key The name of a property of each object in the arrays.
 *
 *  @return YES if values for key between objects at a given index in each array are equal, otherwise NO.
 */
- (BOOL) compareToArray:(NSArray *)otherArray withKey:(NSString *)key;

/**
 *  A copy of the receiver, but with duplicate values removed.
 */
@property (nonatomic, copy, readonly) NSArray *distinctArray;

/**
 *  A JSON formatted string from the receiver.
 */
@property (nonatomic, copy, readonly) NSString *JSONString;

@end
