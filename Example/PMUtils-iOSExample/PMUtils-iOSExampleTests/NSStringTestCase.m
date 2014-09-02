//
//  NSStringTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+PMUtils.h"

@interface NSStringTestCase : XCTestCase

@end

@implementation NSStringTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testEncodedURLQuery
{
	NSString *query = @"key1=value1&key2=value2,value3#this is another parameter";
	NSString *encodedQuery = [query encodedURLQuery];
	NSString *expectedQuery = @"key1=value1&key2=value2,value3%23this%20is%20another%20parameter";
	XCTAssertEqualObjects(encodedQuery, expectedQuery, @"query should be URL encoded");
}

- (void) testSha1Hash
{
	NSString *string = @"DIY flannel Helvetica, +1 blog farm-to-table gastropub mlkshk Neutra tofu typewriter iPhone forage. Roof party hashtag squid paleo. VHS messenger bag pug, literally ethical leggings ugh readymade tote bag craft beer. Swag Godard food truck ethical disrupt lo-fi, selfies wayfarers PBR deep v Etsy flannel keffiyeh ethnic. Banjo VHS food truck, scenester vinyl pug kogi disrupt Schlitz pop-up. Pour-over tousled banh mi, kale chips ethical you probably haven't heard of them Neutra gluten-free DIY irony Truffaut. Sriracha pickled gastropub chia art party literally, locavore Tumblr hella Etsy fingerstache.";
	NSString *hash = [string sha1Hash];
	NSString *expectedHash = @"4D94F0CF57B6D26177D31529A3D3300510B0EC6C";
	XCTAssertEqualObjects(hash, expectedHash, @"string should be converted to its SHA1 hash");
}

- (void) testMd5Hash
{
	NSString *string = @"DIY flannel Helvetica, +1 blog farm-to-table gastropub mlkshk Neutra tofu typewriter iPhone forage. Roof party hashtag squid paleo. VHS messenger bag pug, literally ethical leggings ugh readymade tote bag craft beer. Swag Godard food truck ethical disrupt lo-fi, selfies wayfarers PBR deep v Etsy flannel keffiyeh ethnic. Banjo VHS food truck, scenester vinyl pug kogi disrupt Schlitz pop-up. Pour-over tousled banh mi, kale chips ethical you probably haven't heard of them Neutra gluten-free DIY irony Truffaut. Sriracha pickled gastropub chia art party literally, locavore Tumblr hella Etsy fingerstache.";
	NSString *hash = [string md5Hash];
	NSString *expectedHash = @"DCDA7DE9BCE62B9B626D10E4BACB633D";
	XCTAssertEqualObjects(hash, expectedHash, @"string should be converted to its MD5 hash");
}

- (void) testIsCapitalized
{
	NSString *capitalized = @"Capitalized";
	NSString *notCapitalized = @"notCapitalized";
	
	XCTAssert([capitalized isCapitalized], @"Should be capitalized");
	XCTAssertFalse([notCapitalized isCapitalized], @"Should not be capitalized");
}

- (void) testCompareWithVersion
{
	NSString *newVersion = @"1.0.3";
	NSString *oldVersion = @"1.0";
	
	NSComparisonResult ascending = [oldVersion compareWithVersion:newVersion];
	NSComparisonResult descending = [newVersion compareWithVersion:oldVersion];
	
	XCTAssertEqual(ascending, NSOrderedAscending, @"Should be NSOrderedAscending");
	XCTAssertEqual(descending, NSOrderedDescending, @"Should be NSOrderedDescending");
}

- (void) testInVersion
{
	NSString *newVersion = @"1.0.3";
	NSString *oldVersion = @"1.0";
	
	XCTAssert([newVersion inVersion:oldVersion], @"1.0.3 is in version 1.0");
	XCTAssertFalse([oldVersion inVersion:newVersion], @"1.0 is not in version 1.0.3");
}


- (void) testContainsEmoji
{
	NSString *emojiString = @"DIY flannel Helvetica, +1 😈 blog farm-to-table gastropub mlkshk Neutra tofu typewriter iPhone forage.";
	NSString *noEmojiString = @"DIY flannel Helvetica, +1  blog farm-to-table gastropub mlkshk Neutra tofu typewriter iPhone forage.";
	
	XCTAssert([emojiString containsEmoji], @"Should contain emoji");
	XCTAssertFalse([noEmojiString containsEmoji], @"Should not contain emoji");
}

- (void) testCamelCaseFromUnderscores
{
	NSString *underscore = @"This is_a string";
	NSString *camelcase = @"This isA string";
	
	XCTAssertEqualObjects([underscore camelCaseFromUnderscores], camelcase, @"Should convert underscored words to camel case");
	XCTAssertEqualObjects([camelcase camelCaseFromUnderscores], camelcase, @"Should not convert non underscored strings");
}

- (void) testUnderscoresFromCamelCase
{
	NSString *camelcase = @"This isA string";
	NSString *underscore = @"This is_a string";
	
	XCTAssertEqualObjects([camelcase underscoresFromCamelCase], underscore, @"Should convert camel case words to underscores");
	XCTAssertEqualObjects([underscore underscoresFromCamelCase], underscore, @"Should not convert underscored strings");
}

@end
