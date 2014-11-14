//
//  NSDictionaryTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 10/26/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import "NSDictionary+PMUtils.h"
#import <XCTest/XCTest.h>

@interface NSDictionaryTestCase : XCTestCase

@end

@implementation NSDictionaryTestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testJSONString
{
    NSDictionary *dict = @{@"Object 1": @{@"fourty-three": @43,
                                        @"null": [NSNull null]}};
    NSString *JSONString = [dict JSONString];
    XCTAssert([JSONString isEqualToString:@"{\"Object 1\":{\"fourty-three\":43,\"null\":null}}"] ||
              [JSONString isEqualToString:@"{\"Object 1\":{\"null\":null,\"fourty-three\":43}}"]);
}



@end
