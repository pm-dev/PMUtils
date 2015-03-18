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
//  NSObject+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import "NSObject+PMUtils.h"
#import "objc/runtime.h"


static inline NSMutableDictionary * PMSharedInstancesByClassName() {
    static NSMutableDictionary *_sharedInstancesByClassName = nil;
    static dispatch_once_t cacheToken = 0;
    dispatch_once(&cacheToken, ^{
        _sharedInstancesByClassName = [NSMutableDictionary dictionary];
    });
    return _sharedInstancesByClassName;
}

static inline NSMutableDictionary * PMLocksByClassName() {
    static NSMutableDictionary *_sharedInstancesByClassName = nil;
    static dispatch_once_t cacheToken = 0;
    dispatch_once(&cacheToken, ^{
        _sharedInstancesByClassName = [NSMutableDictionary dictionary];
    });
    return _sharedInstancesByClassName;
}


@implementation NSObject (PMUtils)


+ (void) setShared:(id)shared
{
    NSMutableDictionary *sharedDictionary = PMSharedInstancesByClassName();
    NSString *className = NSStringFromClass(self);
    NSLock *lock = PMLocksByClassName()[className];
    if (!lock) {
        lock = [[NSLock alloc] init];
        PMLocksByClassName()[className] = lock;
    }
    [lock lock];
    if (shared) {
        NSAssert([shared isKindOfClass:self], @"Parameter shared - %@ - must be an instance of the receiving class %@", shared, self);
        sharedDictionary[className] = shared;
    }
    else {
        [sharedDictionary removeObjectForKey:className];
    }
    [lock unlock];
}

+ (instancetype)shared
{
    NSMutableDictionary *sharedDictionary = PMSharedInstancesByClassName();
    NSString *className = NSStringFromClass(self);
    NSLock *lock = PMLocksByClassName()[className];
    if (!lock) {
        lock = [[NSLock alloc] init];
        PMLocksByClassName()[className] = lock;
    }
    [lock lock];
    id shared = sharedDictionary[className];
    if (!shared) {
        shared = [self new];
        sharedDictionary[className] = shared;
    }
    [lock unlock];
    return shared;
}

+ (instancetype) verifyKindOfClass:(id)object
{
    return [object isKindOfClass:self]? object : nil;
}

+ (instancetype) verifyMemberOfClass:(id)object
{
    return [object isMemberOfClass:self]? object : nil;
}

+ (NSSet *) propertyNames
{
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(self, &propertyCount);
    NSMutableSet *propertyNames = [NSMutableSet setWithCapacity:propertyCount];
    for (NSUInteger i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(propertyList);
    return [propertyNames copy];
}

- (NSDictionary *) propertiesByName
{
    NSSet *propertyNames = [[self class] propertyNames];
    NSMutableDictionary *propertiesByName = [NSMutableDictionary dictionaryWithCapacity:propertyNames.count];
    for (NSString *propertyName in propertyNames) {
        id obj = [self valueForKey:propertyName];
        propertiesByName[propertyName] = obj?: [NSNull null];
    }
    return propertiesByName;
}

+ (Class) classOfProperty:(NSString *)propertyName
{
    NSAssert([[self propertyNames] containsObject:propertyName],
             @"Property name <%@> is not a property of class %@", propertyName, NSStringFromClass(self));
    
    objc_property_t theProperty = class_getProperty(self, propertyName.UTF8String);
    NSParameterAssert(theProperty);
    const char * propertyAttrs = property_getAttributes(theProperty);
    NSArray *attributeComponents = [[NSString stringWithUTF8String:propertyAttrs] componentsSeparatedByString:@"\""];
    if (attributeComponents.count == 3) {
        return NSClassFromString(attributeComponents[1]);
    }
    return nil;
}

@end
