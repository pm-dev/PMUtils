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
//  NSManagedObject+PMUtils.m
//  Created by Peter Meyers on 5/5/14.
//
//

#import "NSManagedObject+PMUtils.h"
#import <objc/runtime.h>

@implementation NSManagedObject (PMUtils)


+ (void) setManagedObjectContext:(NSManagedObjectContext *)context
{
    objc_setAssociatedObject(self, @selector(delegate), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (NSManagedObjectContext *)context
{
    NSManagedObjectContext *context = objc_getAssociatedObject(self, @selector(delegate));
	Class superclass = self.superclass;
    if (!context && [superclass isSubclassOfClass:[NSManagedObject class]]) {
        context = [superclass context];
    }
    return context;
}


+ (NSString *) entityName
{
    return NSStringFromClass(self);
}


+ (instancetype) create
{
    NSManagedObjectContext *context = [self context];
    NSParameterAssert(context.persistentStoreCoordinator.managedObjectModel);
	
    if (context) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName]
                                                  inManagedObjectContext:context];
        NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity
                                                  insertIntoManagedObjectContext:context];
        return managedObject;
    }
    
    return nil;
}


+ (instancetype) createAndSave
{
    NSManagedObject *object = [self create];
    BOOL succeeded = [object save];
    return succeeded? object : nil;
}

- (BOOL) destroy
{
    [self.managedObjectContext deleteObject:self];
    return [self save];
}


- (BOOL) save
{
    NSError *error = nil;
    BOOL succeeded = [self.managedObjectContext save:&error];
    NSAssert(succeeded, @"Error saving Managed Object: %@ to context. Error: %@", self, error);
    return succeeded;
}

@end
