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
{
    NSFileManager *_defaultManager;
    NSURL *_lebowskiipsumURL;
    NSURL *_createdDirectoryURL;
    NSURL *_createdSubdirectoryURL;
    NSString *_tempDirName;
}

- (void)setUp
{
    [super setUp];
    _defaultManager = [NSFileManager defaultManager];
    _tempDirName = @"tempDir";
    _lebowskiipsumURL = [[NSBundle mainBundle] URLForResource:@"lebowskiipsum" withExtension:@"txt"];
    _createdDirectoryURL = [_defaultManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].lastObject;
    _createdDirectoryURL = [_createdDirectoryURL URLByAppendingPathComponent:_tempDirName];
    _createdSubdirectoryURL = [_createdDirectoryURL URLByAppendingPathComponent:@"L1_Dir_1"];
    NSError *error = nil;
    [_defaultManager createDirectoryAtURL:_createdDirectoryURL withIntermediateDirectories:YES attributes:nil error:&error];
    XCTAssertNil(error, @"Error should be nil.");
}

- (void)tearDown
{
    NSError *error;
    [_defaultManager removeItemAtURL:_createdDirectoryURL error:&error];
    XCTAssertNil(error, @"Error should be nil.");
    [super tearDown];
}

- (void) testModificationDateForFileAtPath
{
    NSDate *modDate = [_defaultManager modificationDateForFileAtURL:_lebowskiipsumURL];
    XCTAssert(modDate, @"modeDate should be the valid");
}

- (void) populateCreatedDirectory
{
    // Create 2 files and 1 directory with another file nested inside.
    NSData *fileData = [NSData dataWithContentsOfURL:_lebowskiipsumURL];
    
	NSURL *URL = [_createdDirectoryURL URLByAppendingPathComponent:@"L1_File_1"];
    [fileData writeToURL:URL atomically:YES];
    
    URL = [_createdDirectoryURL URLByAppendingPathComponent:@"L1_File_2"];
    [fileData writeToURL:URL atomically:YES];
    
    NSError *error;
    [_defaultManager createDirectoryAtURL:_createdSubdirectoryURL withIntermediateDirectories:YES attributes:nil error:&error];
    XCTAssertNil(error, @"error should be nil");
    
    URL = [_createdSubdirectoryURL URLByAppendingPathComponent:@"L2_File_1"];
    [fileData writeToURL:URL atomically:YES];
    
    NSArray *createdDirContents = [_defaultManager contentsOfDirectoryAtURL:_createdDirectoryURL includingPropertiesForKeys:nil options:0 error:&error];
    XCTAssertNil(error, @"tempDir should exist");
    XCTAssertEqual(createdDirContents.count, 3, @"tempDir should contain 3 items");
}

- (void) testRemoveFilesInDirectory
{
    [self populateCreatedDirectory];
    
    [_defaultManager removeFilesInDirectory:_createdDirectoryURL deep:NO];
    
    NSError *error;
    NSArray *dirURLContents = [_defaultManager contentsOfDirectoryAtURL:_createdSubdirectoryURL includingPropertiesForKeys:nil options:0 error:&error];
    XCTAssertNil(error, @"L1_Dir_1 should still exist");
    XCTAssertEqual(dirURLContents.count, 1, @"L1_Dir_1 should still contain L2_File_1 since the remove was not deep");
    
    NSArray *createdDirContents = [_defaultManager contentsOfDirectoryAtURL:_createdDirectoryURL includingPropertiesForKeys:nil options:0 error:&error];
    XCTAssertNil(error, @"tempDir should exist");
    XCTAssertEqual(createdDirContents.count, 1, @"tempDir should only contain L1_Dir_1");
    
    [_defaultManager removeFilesInDirectory:_createdDirectoryURL deep:YES];
    
    dirURLContents = [_defaultManager contentsOfDirectoryAtURL:_createdSubdirectoryURL includingPropertiesForKeys:nil options:0 error:&error];
    XCTAssertNil(error, @"L1_Dir_1 should still exist");
    XCTAssertEqual(dirURLContents.count, 0, @"L1_Dir_1 should not contain files since the remove was deep");
}

- (void) testRemoveContentsOfDirectory
{
    [self populateCreatedDirectory];

    [_defaultManager removeContentsOfDirectory:_createdDirectoryURL];
    
    NSError *error;
    NSArray *createdDirContents = [_defaultManager contentsOfDirectoryAtURL:_createdDirectoryURL includingPropertiesForKeys:nil options:0 error:&error];
    XCTAssertNil(error, @"tempDir should exist");
    XCTAssertEqual(createdDirContents.count, 0, @"tempDir should contain 0 items");
}

- (void) testXAttr
{
    NSString *xAttrValue = @"value";
    NSString *xAttrKey = @"key";
    
    BOOL success = [NSFileManager setXAttrStringValue:xAttrValue forKey:xAttrKey atURL:_lebowskiipsumURL];
    XCTAssert(success, @"Set xAttr should return YES");
    
    NSString *value = [NSFileManager xattrStringValueForKey:xAttrKey atURL:_lebowskiipsumURL];
    XCTAssertEqualObjects(value, xAttrValue, @"xAttr values should be equal");
}


- (void) testURLForCachesDirectoryWithNameAttributesInDirectory
{
    NSURL *URL = [_defaultManager URLForDirectoryWithName:_tempDirName attributes:nil inDirectory:NSCachesDirectory];
    XCTAssertEqualObjects(URL.path, _createdDirectoryURL.path, @"created dir should be equal to _createdDirURL");
    
    URL = [_defaultManager URLForDirectoryWithName:@"randomDir" attributes:nil inDirectory:NSCachesDirectory];
    XCTAssertNotNil(URL, @"URL should be a valid NSURL");
    
    [_defaultManager removeItemAtURL:URL error:nil];
}

- (void) testPathIsDirectory
{
    NSURL *nonDirectoryPath = [[NSBundle mainBundle] URLForResource:@"LICENSE" withExtension:nil];
    NSURL *directoryPath = [[NSBundle mainBundle] URLForResource:@"TestModel" withExtension:@"momd"];

    XCTAssert([_defaultManager URLIsDirectory:directoryPath] , @"Should be a directory.");
    XCTAssertFalse([_defaultManager URLIsDirectory:nonDirectoryPath], @"Should not be a directory.");
}

@end
