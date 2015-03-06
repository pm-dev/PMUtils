//
//  NSThreadTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/2/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSThread+PMUtils.h"

@interface NSThreadTestCase : XCTestCase

@end

@implementation NSThreadTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testDispatchMainThread
{
    [NSThread dispatchMainThread:^{
        XCTAssertEqualObjects([NSThread mainThread], [NSThread currentThread], @"Current thread should be the main thread.");
    }];
}

- (void) testDispatchBackgroundThreadPriority
{
    [NSThread dispatchBackgroundThread:^{
        XCTAssertNotEqualObjects([NSThread mainThread], [NSThread currentThread], @"Current thread should not be the main thread.");
    } priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (void) testObjectForCurrentThreadWithNameCreationBlock
{
    NSString *testObjectName = @"testObjectName";
    __block id testObject;
    [NSThread objectForCurrentThreadWithName:testObjectName creationBlock:^id{
        testObject = @[@"testObjectValue"];
        return testObject;
    }];
    id object = [NSThread objectForCurrentThreadWithName:testObjectName creationBlock:nil];
    
    XCTAssert(testObject == object, @"Objects should be identical");
}

@end
