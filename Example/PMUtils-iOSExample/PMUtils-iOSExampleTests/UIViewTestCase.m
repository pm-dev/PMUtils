//
//  UIViewTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIView+PMUtils.h"
#import "PMSampleView.h"


// Have not tested -[UIView blurredViewWithRadius:interations:scaleDownFactor:saturation:tintColor:crop]; because
// it requires that the view has been rendered on screen.

@interface UIViewTestCase : XCTestCase

@end

@implementation UIViewTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
	[PMSampleView setShared:nil];
    [super tearDown];
}

- (void)testShared
{
	PMSampleView *view = [PMSampleView shared];
	XCTAssertEqualObjects(view.label.text, @"sample text", @"View's label's text should equal what was set in the nib");

	NSString *newSampleText = @"New sample text";
	view.label.text = newSampleText;
	XCTAssertEqualObjects([PMSampleView shared].label.text, newSampleText, @"Shared object should have had new sample text set as its label's text");
}

- (void) testRemoveSubviews
{
	PMSampleView *view = [PMSampleView shared];
	XCTAssert(view.subviews.count > 0, @"view should have a label as its subview");
	
	[view removeSubviews];
	XCTAssert(view.subviews.count == 0, @"view should have no subviews");
}

- (void) testDefaultNibName
{
	NSString *nibName = [PMSampleView defaultNibName];
	XCTAssert(nibName, @"nibName should be initialized");
}

- (void) testDefaultNib
{
	UINib *nib = [PMSampleView defaultNib];
	XCTAssert(nib, @"nib should be initialized");
}

- (void) testInstanceFromDefaultNibWithOwner
{
	PMSampleView *view = [PMSampleView instanceFromDefaultNibWithOwner:nil];
	XCTAssert(view, @"view should be initialized");
}

- (void) testCenterInRectForDirection
{
	PMSampleView *view = [PMSampleView shared];
	[view centerInRect:CGRectOffset(view.frame, -10, -20) forDirection:PMDirectionHorizontal | PMDirectionVertical];
	XCTAssertEqual(view.frame.origin.x, -10, @"View should be centered in new frame");
	XCTAssertEqual(view.frame.origin.y, -20, @"View should be centered in new frame");
}

@end
