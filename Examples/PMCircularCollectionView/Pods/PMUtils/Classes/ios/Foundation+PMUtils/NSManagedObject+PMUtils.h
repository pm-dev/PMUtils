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
//  NSManagedObject+PMUtils.h
//  Created by Peter Meyers on 5/5/14.
//
//


#import <CoreData/CoreData.h>

@interface NSManagedObject (PMUtils)

/**
 *  Associate a managed object context with the class object that calls this method.
 *
 *  @param context The managed object context to be associated with the class.
 */
+ (void) setManagedObjectContext:(NSManagedObjectContext *)context;

/**
 *  The context that has been associated with the calling class using +[NSManagedObject setManagedObjectContext:].
 *  If no context has been associated with the class calling this method, it looks to see if a context has been
 *  associated with its superclass. This recursion continues until a context is found or until this method
 *	is called on the NSManagedObject class.
 *
 *  @return The associated managed object context.
 */
+ (NSManagedObjectContext *)context;

/**
 *  The entity name for this managed object. By default, this method returns NSStringFromClass(self).
 *  If the entity name is not equal to the name of the class, you must override this method and return the correct name.
 *
 *  @return The name of the entity.
 */
+ (NSString *) entityName;

/**
 *  Creates a new instance of the managed object. This method uses +[NSManagedObject entityName] to create the object
 *  and inserts it into the managed object context that was associated with this class using +[NSManagedObject setManagedObjectContext:].
 *
 *  @return An instantiated NSManagedObject or nil if no context has been associated with the calling class.
 */
+ (instancetype) create;

/**
 *  The equivalent of calling [[NSManagedObject create] save]
 *
 *  @return An instantiated NSManagedObject or nil if no context has been associated with the calling class.
 */
+ (instancetype) createAndSave;

/**
 *  Removes receiver from its managed object context's persistent store. If the receiver has not yet
 *  been saved to a persistent store, it is simply removed from its managed object context. To achieve this the
 *  reciever's context is saved.
 *
 *  @return YES if the receiver's context is successfully saved after deleting the receiver, otherwise NO
 */
- (BOOL) destroy;


/**
 *  Commits unsaved changes to the receiver to its managed object context's parent store. To acheive this, the receivers
 *  context is saved.
 *
 *  @return YES if the save succeeds, otherwise NO.
 */
- (BOOL) save;

@end
