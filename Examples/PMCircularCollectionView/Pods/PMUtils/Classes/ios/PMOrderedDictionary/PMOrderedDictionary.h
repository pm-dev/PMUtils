//
//  OrderedDictionary.h
//  OrderedDictionary
//
//  Created by Matt Gallagher on 19/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//
//  Version: 1.1
//  Created by PETER MEYERS on 6/11/2014.
//  Copyright (c) 2013 Peter Meyers. All rights reserved.
//  The original source code can be found at:
//  http://projectswithlove.com/projects/OrderedDictionary.zip


@interface PMOrderedDictionary : NSMutableDictionary

/**
 *  Adds a given key-value pair to the ordered dictionary at an index.
 *
 *  @param anObject The value for aKey. A strong reference to the object is maintained by the dictionary.
 *  Raises an NSInvalidArgumentException if anObject is nil. If you need to represent a nil value in the dictionary, use NSNull.
 *  @param aKey     The key for value. The key is copied (using copyWithZone:; keys must conform to the NSCopying protocol). 
 *  Raises an NSInvalidArgumentException if aKey is nil. If aKey already exists in the dictionary, the previously associated value is removed and anObject
 *  is added at anIndex.
 *  @param anIndex  The index to add the key-value pair in the dictionary.
 */
- (void)insertObject:(id)anObject forKey:(id<NSCopying>)aKey atIndex:(NSUInteger)anIndex;

/**
 *  Returns the key located at the specified index. If index is beyond the end of the ordered dictionary
 *  (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
 *
 *  @param index An index within the bounds of the ordered dictionary.
 *
 *  @return The key located at index.
 */
- (id<NSCopying>)keyAtIndex:(NSUInteger)index;

/**
 *  Returns the object located at the specified index. If index is beyond the end of the ordered dictionary
 *  (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
 *
 *  @param index An index within the bounds of the ordered dictionary.
 *
 *  @return The object located at index.
 */
- (id) objectAtIndex:(NSUInteger)index;

/**
 *  Returns the index of key in the ordered dictionary. The isEqual: message is used to find the key in the ordered dictionary.
 *
 *  @param key A key.
 *
 *  @return The index of key in the ordered dictionary. If no keys in the ordered dictionary are equal to key, returns NSNotFound.
 */
- (NSUInteger)indexOfKey:(id<NSCopying>)key;

/**
 *  Returns the index of object in the ordered dictionary. The isEqual: message is used to find the object in the ordered dictionary.
 *
 *  @param object An object.
 *
 *  @return The index of object in the ordered dictionary. If no objects in the ordered dictionary are equal to object, returns NSNotFound.
 */
- (NSUInteger)indexOfObject:(id)object;

/**
 *  Returns an enumerator object that lets you access each object in the ordered dictionary, in reverse order.
 *  When you use this method, you must not modify the ordered dictionary during enumeration. It is more efficient to use the fast enumeration protocol (see NSFastEnumeration). Fast enumeration is available on OS X v10.5 and later and iOS 2.0 and later.
 *
 *  @return An enumerator object that lets you access each key in the ordered dictionary, in order, from the element at the highest index down to the element at index 0.
 */
- (NSEnumerator *)reverseKeyEnumerator;

@end
