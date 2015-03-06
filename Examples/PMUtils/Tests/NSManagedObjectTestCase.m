//
//  NSManagedObjectTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSManagedObject+PMUtils.h"
#import "PMTest.h"

@interface NSManagedObjectTestCase : XCTestCase

@end

@implementation NSManagedObjectTestCase
{
	NSManagedObjectContext *_context;
}

- (void)setUp
{
    [super setUp];
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestModel" withExtension:@"momd"];
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	[coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
	_context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	[_context setPersistentStoreCoordinator:coordinator];
	[NSManagedObject setManagedObjectContext:_context];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testSetManagedObject
{
	XCTAssertEqualObjects(_context, [PMTest context], @"Contexts should be equal");
}

- (void) testCreate
{
	PMTest *createdObject = [PMTest create];
	NSSet *insertedObjects = _context.insertedObjects;
	
	XCTAssert(insertedObjects.count == 1, @"The context should have 1 inserted object");
	XCTAssertEqualObjects(insertedObjects.anyObject, createdObject, @"The created object should be the inserted object");
}

- (void) testCreateAndSave
{
	PMTest *createdObject = [PMTest createAndSave];
	NSSet *insertedObjects = _context.insertedObjects;
	PMTest *fetchedObject = (PMTest*)[_context existingObjectWithID:createdObject.objectID error:nil];
	
	XCTAssert(insertedObjects.count == 0, @"The context should have already inserted the object");
	XCTAssertEqualObjects(fetchedObject, createdObject, @"The created object should be available to be fetched object");
}

- (void) testDestroy
{
	PMTest *createdObject = [PMTest createAndSave];
	[createdObject destroy];
	PMTest *fetchedObject = (PMTest*)[_context existingObjectWithID:createdObject.objectID error:nil];
	
	XCTAssertNil(fetchedObject, @"fetchedObject should be nil because the created object has been deleted.");
}

- (void) testSave
{
	PMTest *createdObject = [PMTest create];
	[createdObject save];
	NSSet *insertedObjects = _context.insertedObjects;
	PMTest *fetchedObject = (PMTest*)[_context existingObjectWithID:createdObject.objectID error:nil];
	
	XCTAssert(insertedObjects.count == 0, @"Should be no pending objects to insert.");
	XCTAssertNotNil(fetchedObject, @"Should be able to fetch the object that was saved");
}

@end
