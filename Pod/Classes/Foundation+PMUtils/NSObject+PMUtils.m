//
//  NSObject+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import "NSObject+PMUtils.h"
#import "objc/runtime.h"


@implementation NSObject (PMUtils)

+ (void) setShared:(id)shared
{
	NSMutableDictionary *sharedDictionary = [self PM_sharedInstancesDictionary];
	NSString *className = [self PM_className];
	if (shared) {
		NSAssert([shared isKindOfClass:self], @"Parameter shared - %@ - must be an instance of the receiving class %@", shared, self);
		sharedDictionary[className] = shared;
	}
	else {
		[sharedDictionary removeObjectForKey:className];
	}
}

+ (instancetype)shared
{
	NSMutableDictionary *sharedDictionary = [self PM_sharedInstancesDictionary];
	NSString *className = [self PM_className];
    id shared = sharedDictionary[className];
	
	if (!shared) {
		shared = [self new];
		sharedDictionary[className] = shared;
	}
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


#pragma mark - Internal Methods

+ (NSMutableDictionary *) PM_sharedInstancesDictionary
{
	static NSMutableDictionary *sharedDictionary = nil;
	static dispatch_once_t cacheToken = 0;
	dispatch_once(&cacheToken, ^{
        sharedDictionary = [NSMutableDictionary dictionary];
    });
	return sharedDictionary;
}

+ (NSString *) PM_className
{
	return NSStringFromClass(self);
}

@end
