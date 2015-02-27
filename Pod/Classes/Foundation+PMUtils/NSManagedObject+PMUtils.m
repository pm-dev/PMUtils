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
#import "NSEntityDescription+PMUtils.h"
#import <objc/runtime.h>

@implementation NSManagedObject (PMUtils)


+ (void) setManagedObjectContext:(NSManagedObjectContext *)context
{
    objc_setAssociatedObject(self, @selector(context), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSManagedObjectContext *)context
{
    NSManagedObjectContext *context = objc_getAssociatedObject(self, @selector(context));
    if (!context && [self.superclass isSubclassOfClass:[NSManagedObject class]]) {
        context = [self.superclass context];
    }
    return context;
}

+ (void) setClassNamePrefix:(NSString *)prefix
{
    objc_setAssociatedObject(self, @selector(classNamePrefix), prefix, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSString *) classNamePrefix
{
    return objc_getAssociatedObject(self, @selector(classNamePrefix));
}

+ (NSEntityDescription *) entityDescription;
{
    NSManagedObjectContext *context = [self context];
    if (context) {
        NSString *entityName = NSStringFromClass(self);
        NSString *classNamePrefix = [self classNamePrefix];
        if (classNamePrefix && [entityName hasPrefix:classNamePrefix]) {
            entityName = [entityName substringFromIndex:classNamePrefix.length];
        }
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
                                                             inManagedObjectContext:context];
        return entityDescription;
    }
    return nil;
}


+ (instancetype) create
{
    NSManagedObjectContext *context = [self context];
    if (context) {
        NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:[self entityDescription]
                                                  insertIntoManagedObjectContext:context];
        return managedObject;
    }
    
    return nil;
}


+ (instancetype) retrieveWithId:(id)identifier
{
    if (identifier) {
        NSManagedObjectContext *context = [self context];
        if (context) {
            NSFetchRequest *request = [NSFetchRequest new];
            request.entity = [self entityDescription];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", request.entity.idAttributeName, identifier];
            request.predicate = predicate;
            request.fetchLimit = 1;
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            NSParameterAssert(results && !error);
            return results.lastObject;
        }
    }
    return nil;
}

+ (NSArray *) retrieveWithPredicate:(NSPredicate *)predicate
{
    if (predicate) {
        NSManagedObjectContext *context = [self context];
        if (context) {
            NSFetchRequest *request = [NSFetchRequest new];
            request.entity = [self entityDescription];
            request.predicate = predicate;
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            NSParameterAssert(results && !error);
            return results;
        }
    }
    return nil;
}

- (BOOL) destroy
{
    [self.managedObjectContext deleteObject:self];
    return [self update];
}


- (BOOL) update
{
    NSError *error = nil;
    BOOL succeeded = [self.managedObjectContext save:&error];
    NSAssert(succeeded, @"Error saving Managed Object: %@ to context. Error: %@", self, error);
    return succeeded;
}

@end
