//
//  NSObject+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import "NSObject+PMUtils.h"

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
