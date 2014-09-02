//
//  NSRegularExpressionTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSRegularExpression+PMUtils.h"

@interface NSRegularExpressionTestCase : XCTestCase

@end

@implementation NSRegularExpressionTestCase
{
	NSRegularExpression *_fourDigitsRegex;
}

- (void)setUp
{
    [super setUp];
	_fourDigitsRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\d\\d\\d\\d)" options:0 error:nil];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testStringByReplacingMatchesInStringOptionsRangeTemplateWithString
{
	NSString *oldYearString = @"The year is 1990.";
	NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
	NSInteger currentYear = [comp year];
	NSString *correctedYearString = [_fourDigitsRegex stringByReplacingMatchesInString:oldYearString
																			   options:0
																				 range:NSMakeRange(0, oldYearString.length)
																			  template:@"$0"
																			withString:^NSString *(NSString *match) {
																				XCTAssertEqualObjects(match, @"1990", @"Should have matched	1990");
																				return [NSString stringWithFormat:@"%d", currentYear];
																			}];
	NSString *currentYearString = [NSString stringWithFormat:@"The year is %d.", currentYear];
	
	XCTAssertEqualObjects(correctedYearString, currentYearString, @"The year in the string should have been replaced.");
}

@end
