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
//  PMPair.m
//  Created by Peter Meyers on 5/22/14.
//
//

#import "PMPair.h"

static NSString * const kObject1Key = @"1";
static NSString * const kObject2Key = @"2";
static NSString * const kMapTableCodingKey = @"MapTable";

@implementation PMPair
{
	NSMapTable *_mapTable;
	NSMapTableOptions _options;
}

- (instancetype) init
{
	return [self initWithFirstObject:nil secondObject:nil];
}

- (instancetype) initWithFirstObject:(id)object secondObject:(id)otherObject
{
	return [self initWithFirstObject:object secondObject:otherObject options:NSMapTableStrongMemory];
}

+ (instancetype) pairWithFirstObject:(id)object secondObject:(id)otherObject
{
    return [[self alloc] initWithFirstObject:object secondObject:otherObject];
}

- (instancetype) initWithFirstObject:(id)object secondObject:(id)otherObject options:(NSMapTableOptions)options
{
	self = [super init];
	if (self) {
		_options = options;
		[self setMapTableWithFirstObject:object secondObject:otherObject];
	}
	return self;
}

+ (instancetype) pairWithFirstObject:(id)object secondObject:(id)otherObject options:(NSMapTableOptions)options
{
	return [[self alloc] initWithFirstObject:object secondObject:otherObject options:options];
}

- (id) object1
{
	return [_mapTable objectForKey:kObject1Key];
}

- (void) setObject1:(id)object1
{
	[_mapTable setObject:object1 forKey:kObject1Key];
}

- (id) object2
{
	return [_mapTable objectForKey:kObject2Key];
}

- (void) setObject2:(id)object2
{
	[_mapTable setObject:object2 forKey:kObject2Key];
}

- (void) setOptions:(NSMapTableOptions)options
{
	if (options != _options) {
		_options = options;
		[self setMapTableWithFirstObject:[_mapTable objectForKey:kObject1Key]
							 secondObject:[_mapTable objectForKey:kObject2Key]];
	}
}

- (NSMapTableOptions)options
{
	return _options;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	NSParameterAssert(idx == 0 || idx == 1);
	return [_mapTable objectForKey:idx? kObject2Key : kObject1Key];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
	NSParameterAssert(idx == 0 || idx == 1);
	[_mapTable setObject:obj forKey:idx? kObject2Key : kObject1Key];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id *)stackbuf
                                    count:(NSUInteger)len
{
	[_mapTable]
}
#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
	return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if (self) {
		_mapTable = [decoder decodeObjectOfClass:[NSMapTable class] forKey:kMapTableCodingKey];
		_options = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(options))] integerValue];
	}
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_mapTable forKey:kMapTableCodingKey];
	[coder encodeObject:[NSNumber numberWithInteger:_options] forKey:NSStringFromSelector(@selector(options))];
}


#pragma mark - NSCopying


- (id)mutableCopyWithZone:(NSZone *)zone
{
	PMPair *pair = [[[self class] allocWithZone:zone] initWithFirstObject:[_mapTable objectForKey:kObject1Key]
															 secondObject:[_mapTable objectForKey:kObject2Key]
																  options:_options];
    return pair;
}

#pragma mark - Internal Methods

- (void) setMapTableWithFirstObject:(id)object secondObject:(id)otherObject
{
	_mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:_options];
	if (object) {
		[_mapTable setObject:object forKey:kObject1Key];
	}
	if (otherObject) {
		[_mapTable setObject:otherObject forKey:kObject2Key];
	}
}


@end
