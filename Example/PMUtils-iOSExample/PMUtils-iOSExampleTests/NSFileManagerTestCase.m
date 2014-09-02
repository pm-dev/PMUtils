//
//  NSFileManagerTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/2/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSFileManager+PMUtils.h"

@interface NSFileManagerTestCase : XCTestCase

@end

@implementation NSFileManagerTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testModificationDateForFileAtPath
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lebowskiipsum" ofType:@"txt"];
    NSDate *modDate = [[NSFileManager defaultManager] modificationDateForFileAtPath:path];
    XCTAssert(modDate, @"modeDate should be the valid");
}

// TODO
//- (void) testRemoveFilesInDirectory
//{
//    
//}
//
//- (void) testRemoveContentsOfDirectory
//{
//    
//}
//
//- (void) testXAttr
//{
//    
//}
//
//- (void) testPathForCachesDirectoryWithNameAttributesInDirectory
//{
//    
//}
//
//- (void) testURLForDirectoryWithNameAttributesInDirectory
//{
//    
//}

- (void) testPathIsDirectory
{
    NSString *nonDirectoryPath = [[NSBundle mainBundle] pathForResource:@"LICENSE" ofType:nil];
    NSString *directoryPath = [[NSBundle mainBundle] pathForResource:@"TestModel" ofType:@"momd"];

    XCTAssert([NSFileManager pathIsDirectory:directoryPath] , @"Should be a directory.");
    XCTAssertFalse([NSFileManager pathIsDirectory:nonDirectoryPath], @"Should not be a directory.");
}

@end
