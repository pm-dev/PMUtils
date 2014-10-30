//
//  NSIndexPathTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSIndexPath+PMUtils.h"

@interface NSIndexPathTestCase : XCTestCase

@end

@implementation NSIndexPathTestCase
{
	NSIndexPath *_indexPath;
}
- (void)setUp
{
    [super setUp];
	NSUInteger indexes[] = {1,2,3,4};
	_indexPath = [NSIndexPath indexPathWithIndexes:indexes length:4];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testIndexPathByRemovingFirstIndex
{
	NSIndexPath *modifiedIndexPath = [_indexPath indexPathByRemovingFirstIndex];
	NSUInteger expectedIndexes[] = {2,3,4};
	NSIndexPath *expectedIndexPath = [NSIndexPath indexPathWithIndexes:expectedIndexes length:3];
	XCTAssertEqualObjects(modifiedIndexPath, expectedIndexPath, @"Indexes expected to be equal");
}

- (void) testIndexPathByAddingFirstIndex
{
	NSIndexPath *modifiedIndexPath = [_indexPath indexPathByAddingFirstIndex:99];
	NSUInteger expectedIndexes[] = {99,1,2,3,4};
	NSIndexPath *expectedIndexPath = [NSIndexPath indexPathWithIndexes:expectedIndexes length:5];
	XCTAssertEqualObjects(modifiedIndexPath, expectedIndexPath, @"Indexes expected to be equal");
}

- (void) testIndexPathByReplacingLastIndex
{
	NSIndexPath *modifiedIndexPath = [_indexPath indexPathByReplacingLastIndex:99];
	NSUInteger expectedIndexes[] = {1,2,3,99};
	NSIndexPath *expectedIndexPath = [NSIndexPath indexPathWithIndexes:expectedIndexes length:4];
	XCTAssertEqualObjects(modifiedIndexPath, expectedIndexPath, @"Indexes expected to be equal");
}

- (void) testIndexPathByReplacingFirstIndex
{
	NSIndexPath *modifiedIndexPath = [_indexPath indexPathByReplacingFirstIndex:99];
	NSUInteger expectedIndexes[] = {99,2,3,4};
	NSIndexPath *expectedIndexPath = [NSIndexPath indexPathWithIndexes:expectedIndexes length:4];
	XCTAssertEqualObjects(modifiedIndexPath, expectedIndexPath, @"Indexes expected to be equal");
}

@end
