//
//  OrderedDictionary.m
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

#import "PMOrderedDictionary.h"

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent)
{
	NSString *objectString;
	if ([object isKindOfClass:[NSString class]])
	{
		objectString = (NSString *)object;
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)])
	{
		objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:)])
	{
		objectString = [(NSSet *)object descriptionWithLocale:locale];
	}
	else
	{
		objectString = [object description];
	}
	return objectString;
}

@interface PMOrderedDictionary ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation PMOrderedDictionary

- (id)init
{
	return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity
{
	self = [super init];
	if (self)
	{
		_dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		_array = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}

- (id)copy
{
	return [self mutableCopy];
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
	if (![self.dictionary objectForKey:aKey])
	{
		[self.array addObject:aKey];
	}
	[self.dictionary setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
	[self.dictionary removeObjectForKey:aKey];
	[self.array removeObject:aKey];
}

- (NSUInteger)count
{
	return self.dictionary.count;
}

- (id)objectForKey:(id)aKey
{
	return [self.dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
	return self.array.objectEnumerator;
}

- (NSEnumerator *)reverseKeyEnumerator
{
	return self.array.reverseObjectEnumerator;
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex
{
	if ([self.dictionary objectForKey:aKey])
	{
		[self removeObjectForKey:aKey];
	}
	[self.array insertObject:aKey atIndex:anIndex];
	[self.dictionary setObject:anObject forKey:aKey];
}

- (id<NSCopying>)keyAtIndex:(NSUInteger)index
{
	return [self.array objectAtIndex:index];
}

- (id) objectAtIndex:(NSUInteger)index
{
    id<NSCopying> key = [self keyAtIndex:index];
    return self.dictionary[key];
}

- (NSUInteger)indexOfKey:(id<NSCopying>)key
{
    return [self.array indexOfObject:key];
}

- (NSUInteger)indexOfObject:(id)object
{
    for (NSUInteger i = 0; i < self.array.count; i++) {
        id<NSCopying> key = self.array[i];
        if ([object isEqual:self.dictionary[key]]) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
	NSMutableString *indentString = [NSMutableString string];
	NSUInteger i, count = level;
	for (i = 0; i < count; i++)
	{
		[indentString appendFormat:@"    "];
	}
	
	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@{\n", indentString];
	for (NSObject *key in self)
	{
		[description appendFormat:@"%@    %@ = %@;\n",
			indentString,
			DescriptionForObject(key, locale, level),
			DescriptionForObject([self objectForKey:key], locale, level)];
	}
	[description appendFormat:@"%@}\n", indentString];
	return description;
}

@end
