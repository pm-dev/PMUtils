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
//  NSIndexPath+PMUtils.m
//  Created by Peter Meyers on 3/2/14.

#import "NSIndexPath+PMUtils.h"

@implementation NSIndexPath (PMUtils)

- (NSIndexPath *) indexPathByAddingFirstIndex:(NSUInteger)index
{
	NSUInteger newLength = self.length + 1;
	NSUInteger newarray[newLength];
	
	newarray[0] = index;
	
	for (NSUInteger position = 0; position < self.length; position++)
	{
		newarray[position+1] = [self indexAtPosition:position];
	}
	
	return [NSIndexPath indexPathWithIndexes:newarray length:newLength];
}


- (NSIndexPath *) indexPathByRemovingFirstIndex
{
	NSUInteger newLength = self.length - 1;
	NSUInteger newarray[newLength];
	
	for (NSUInteger position = 1; position < self.length; position++)
	{
		newarray[position-1] = [self indexAtPosition:position];
	}
	
	return [NSIndexPath indexPathWithIndexes:newarray length:newLength];
}

- (NSIndexPath *) indexPathByReplacingLastIndex:(NSUInteger)index
{
	NSUInteger newarray[self.length];
	
    newarray[self.length-1] = index;
    
	for (NSUInteger position = 0; position < self.length-1; position++)
	{
		newarray[position] = [self indexAtPosition:position];
	}
	
	return [NSIndexPath indexPathWithIndexes:newarray length:self.length];
}

- (NSIndexPath *) indexPathByReplacingFirstIndex:(NSUInteger)index
{
	NSUInteger newarray[self.length];
	
    newarray[0] = index;
    
	for (NSUInteger position = 1; position < self.length; position++)
	{
		newarray[position] = [self indexAtPosition:position];
	}
	
	return [NSIndexPath indexPathWithIndexes:newarray length:self.length];
}

@end
