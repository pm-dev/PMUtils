//
//  NSArrayTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "NSArray+PMUtils.h"

@interface NSArrayTestCase : XCTestCase

@end

@implementation NSArrayTestCase
{
	NSArray *_array;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	_array = @[[UIView new], [UIView new]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsItenticalToArray
{
	NSArray *identical = [NSArray arrayWithArray:_array];
	NSArray *notIdentical = @[[UIView new], [UIView new]];
	
	XCTAssert([_array isIdenticalToArray:identical], @"Arrays contents should be identical");
	XCTAssertFalse([_array isIdenticalToArray:notIdentical], @"Arrays contents should not be identical");
}

- (void)testCompareToArrayWithKey
{
	NSArray *equalAlphas = @[[UIView new], [UIView new]];
	
	UIView *clearView = [UIView new];
	clearView.alpha = 0.0f;
	NSArray *inequalAlphas = @[[UIView new], clearView];
	
	XCTAssert([_array compareToArray:equalAlphas withKey:@"alpha"], @"Arrays contents should have equal alphas");
	XCTAssertFalse([_array compareToArray:inequalAlphas withKey:@"alpha"], @"Arrays contents should not have equal alphas");
}

- (void) testDistinctArray
{
    UIView *view = [UIView new];
    NSArray *originalArray = @[view, view];
    NSArray *uniqueArray = [originalArray distinctArray];
    XCTAssertEqual(uniqueArray.count, 1, @"Unique array should have a count of 1.");
    XCTAssertEqualObjects(uniqueArray.firstObject, view, @"The object in unique array should be the view variable.");
}

- (void) testJSONString
{
    NSArray *array = @[@"Object 1", @{@"Dict Key": @43}, [NSNull null]];
    NSString *JSONString = [array JSONString];
    XCTAssertEqualObjects(JSONString, @"[\"Object 1\",{\"Dict Key\":43},null]");
}

@end
