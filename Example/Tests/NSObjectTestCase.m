//
//  NSObjectTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+PMUtils.h"

@interface NSObjectTestCase : XCTestCase

@end

@implementation NSObjectTestCase


- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


- (void) testShared
{
	NSString *string = @"test";
	[NSString setShared:string];
	
	NSArray *sharedArray = [NSArray shared];
	NSObject *sharedObject = [NSObject shared];
	NSMutableString *sharedMutableString = [NSMutableString shared];
	XCTAssertNotEqualObjects(string, sharedArray, @"String was not set as the shared NSArray.");
	XCTAssertNotEqualObjects(string, sharedObject, @"String was not set as the shared NSObject.");
	XCTAssertNotEqualObjects(string, sharedMutableString, @"String was not set as the shared NSMutableString.");
	
	NSString *sharedString = [NSString shared];
	XCTAssertEqualObjects(sharedString, string, @"String was set as the shared NSString.");
	
	[NSString setShared:nil];
	sharedString = [NSString shared];
	XCTAssertNotNil(sharedString, @"Shared method should always return an initialized object of the receiving type");
	XCTAssertNotEqualObjects(string, sharedString, @"String is no longer the shared object for NSString");
	
	NSMutableString *mutableString = [string mutableCopy];
	[NSString setShared:mutableString];
	string = [NSString shared];
	XCTAssertEqualObjects(string, mutableString, @"mutableString should be the shared object for NSString");
}

- (void) testVerifyKindOfClass
{
	NSMutableArray *mutableArray = [@[] mutableCopy];
	NSArray *array = [NSArray verifyKindOfClass:mutableArray];
	XCTAssert(array && array == mutableArray, @"mutableArray is a kind of NSArray");
	
	array = @[];
	mutableArray = [NSMutableArray verifyKindOfClass:array];
	XCTAssertNil(mutableArray, @"array is not kind of NSMutableArray");
}

- (void) testVerifyMemberOfClass
{
	UILabel *label = [UILabel new];
	UIView *value = [UIView verifyMemberOfClass:label];
	XCTAssertNil(value, @"UILabel instances are not members of UIView.");
	
	label = [UILabel verifyMemberOfClass:label];
	XCTAssertNotNil(label, @"label is a member of UILabel");
}

@end
