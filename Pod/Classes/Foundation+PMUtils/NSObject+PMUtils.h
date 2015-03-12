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
//  NSObject+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (PMUtils)


/**
 *  Use this method to return a shared instance of the receiving class. If no shared instance exists for the receiving class,
 *	one is created using [[self alloc] init] then set as the class' shared instance so that subsequent calls return this same object.
 *	*Note* this is different from a singleton pattern, in that the receiving class is not restricted to only one instance.
 *
 *  @return The class' shared instance object.
 */
+ (instancetype)shared;


/**
 *  This method sets the shared instance of the receiving class. Use this method if [[self alloc] init] is not the desired method of
 *	initialization, as that is the default method used when calling +[self shared].
 *
 *  @param shared The instance to assign as the receiver's shared instace. Must be an instance of the receiving class. You may also pass nil to
 *	remove the receivers currently shared instance.
 */
+ (void) setShared:(id)shared;

/**
 *  Use this method to verify an object is an instance of the reciever or a subclass of the reciever.
 *
 *  @param object The object whose class you want to verify.
 *
 *  @see +[NSObject verifyMemberOfClass:]
 *  @return Returns object if object is an instance of the reciever or any class that inherits from the reciever. Otherwise nil.
 */
+ (instancetype) verifyKindOfClass:(id)object;

/**
 *  Use this method to verify an object is an instance of the reciever. Be careful the object you are 
 *	verifying with is not a class cluster, such as NSArray, NSDictionary, NSValue, etc.
 *
 *  @param object The object whose class you want to verify.
 *
 *  @see +[NSObject verifyKindOfClass:]
 *  @return Returns object if object is an instance of the reciever. Otherwise nil.
 */
+ (instancetype) verifyMemberOfClass:(id)object;

/**
 *  Returns an NSSet of NSString objects describing the properties declared by the class. Any properties declared by superclasses are not included.
 *
 *  @return An NSSet of NSStrings naming the properties declared by the class.
 */
+ (NSSet *) propertyNames;

/**
 *  A dictionary with the instance's property names as its keys and their values and the dictionary values.
 *  This method calls -valueForKey: on itself for each property declared by the class, but not any superclasses. If -valueForKey: returns nil, [NSNull null] is added to the dictionary for that key.
 */
@property (nonatomic, readonly) NSDictionary *propertiesByName;

/**
 *  Given a property name from +propertyNames return the class type attribute;
 *
 *  @param propertyName The name of the declared property.
 *
 *  @return The class declared by the property.
 */
+ (Class) classOfProperty:(NSString *)propertyName;

@end
