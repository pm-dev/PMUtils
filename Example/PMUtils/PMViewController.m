// Copyright (c) 2013-2014 Peter Meyers
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  PMViewController.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 3/10/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import "PMViewController.h"
#import "PMUtils.h"
#import "PMSampleView.h"
#import "PMGradientView.h"

@interface PMViewController () <PMImageFilmstripDataSource, PMZoomableImageFilmstripDelegate>
@end

@implementation PMViewController
{
	NSArray *_images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	/*
	 * This example app only illustrates how to use PMImageFilmstrip, UIImageView's image entity delegate, and
	 * [UIImage blurredImageWithRadius:iterations:scaleDownFactor:saturation:tintColor].
	 * You may use this view controller as a blank canvas to experment with other category methods
	 * provided by PMUtils.
	 *
	 */
	
    PMGradientView *gradient = [[PMGradientView alloc] initWithFrame:self.view.bounds];
    gradient.startColor = [UIColor whiteColor];
    gradient.endColor = [UIColor grayColor];
    gradient.startPoint = CGPointMake(0.0f, 0.0f);
    gradient.endPoint = CGPointMake(1.0f, 1.0f);
    gradient.locations = @[@0.5, @0.8];
    [self.view addSubview:gradient];
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[self.view addGestureRecognizer:tap];
	
	UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
	label.text = @"Tap view to render blurred images.";
	label.textAlignment = NSTextAlignmentCenter;
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:label];
}


- (void)tap:(UITapGestureRecognizer *)sender
{
    sender.enabled = NO;
	UIImage *img = [UIImage imageNamed:@"Sample.JPG"];

	CFTimeInterval start = CACurrentMediaTime();
	UIImage *imgOne = [img blurredImageWithRadius:10
									   iterations:3
								  scaleDownFactor:2
									   saturation:1
										tintColor:nil
											 crop:CGRectZero];
	CFTimeInterval duration = CACurrentMediaTime() - start;
	NSLog(@"Blur #1: %f", duration);

	start = CACurrentMediaTime();
	UIImage *imgTwo = [img blurredImageWithRadius:20
									   iterations:4
								  scaleDownFactor:4
									   saturation:1
										tintColor:nil
											 crop:CGRectZero];
	duration = CACurrentMediaTime() - start;
	NSLog(@"Blur #2: %f", duration);
	
	_images = @[imgOne, imgTwo];
	
	PMZoomableImageFilmstrip *filmstrip = [[PMZoomableImageFilmstrip alloc] initWithFrame:self.view.bounds];
	filmstrip.delegate = self;
	filmstrip.dataSource = self;
    filmstrip.maximumZoomScale = 3.0f;
	filmstrip.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:filmstrip];
}

#pragma mark - PMImageFilmstripDelegate Methods

- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip configureFilmstripImageView:(UIImageView *)imageView atIndex:(NSUInteger)index
{
	[imageView setImageEntity:_images[index]];
}

#pragma mark - PMImageFilmstripDataSource Methods

- (NSInteger) numberOfImagesInImageFilmstrip:(PMImageFilmstrip *)imageFilmstrip
{
	return _images.count;
}

@end
