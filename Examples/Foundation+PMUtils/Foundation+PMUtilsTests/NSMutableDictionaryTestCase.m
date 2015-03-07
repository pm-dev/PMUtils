//
//  NSMutableDictionaryTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableDictionary+PMUtils.h"

@interface NSMutableDictionaryTestCase : XCTestCase

@end

@implementation NSMutableDictionaryTestCase
{
	NSMutableDictionary *_mutableDictionary;
}

- (void)setUp
{
    [super setUp];
	_mutableDictionary = [@{@"under_score": @1,
							@"camelCase": @2} mutableCopy];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testReplaceKeyWithKey
{
	NSString *newKey = @"new_key";
	[_mutableDictionary replaceKey:@"under_score" withKey:newKey];
	id value = _mutableDictionary[newKey];
	
	XCTAssertEqualObjects(value, @1, @"The new key should access the same value");
}

- (void) testConvertUnderscoredStringKeysToCamelCase
{
    [_mutableDictionary convertUnderscoredStringKeysToCamelCase:YES];
	id underscoreValue = _mutableDictionary[@"under_score"];
	id camelCaseValue = _mutableDictionary[@"underScore"];
	
	XCTAssertNil(underscoreValue, @"Underscore key should no longer exist");
	XCTAssertNotNil(camelCaseValue, @"CamelCase key should now exist");
}

- (void) testConvertCamelCaseStringKeysToUnderscored
{
    [_mutableDictionary convertCamelCaseStringKeysToUnderscored:YES];
	id camelCaseValue = _mutableDictionary[@"camelCase"];
	id underscoreValue = _mutableDictionary[@"camel_case"];
	
	XCTAssertNil(camelCaseValue, @"CamelCase key should no longer exist");
	XCTAssertNotNil(underscoreValue, @"Underscore key should now exist");
}

@end
