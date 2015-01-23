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
//  PMImageFilmstrip.h
//  Created by Peter Meyers on 9/6/14.
//

#import <UIKit/UIKit.h>

@class PMImageFilmstrip;
@protocol PMImageFilmstripDelegate <NSObject>

@required

/**
 *  Asks the data source for the number of images in the image filmstrip. (required)
 *
 *  @param imageFilmstrip An object representing the image filmpstrip requesting this information.
 *
 *  @return The number of images in the image filmstrip.
 */
- (NSInteger) numberOfImagesInImageFilmstrip:(PMImageFilmstrip *)imageFilmstrip;

/**
 *  Tells the delegate to configure the UIImageView at a given index. (required)
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param imageView      A UIImageView the delegate is responsible for configuring.
 *  @param index          The index of the image in the image filmstrip.
 */
- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip configureFilmstripImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;

@optional

/**
 *  Tells the delegate an image in the image filmstrip is being scrolled to.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param index          The index of the image that is being scrolled to.
 */
- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip willScrollToImageAtIndex:(NSUInteger)index;

/**
 *  Tells the delegate an image in the image filmstrip has been scrolled to.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param index          The index of the image that has been scrolled to.
 */
- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip didScrollToImageAtIndex:(NSUInteger)index;

/**
 *  Tells the delegate an image in the image filmstrip has been selected/tapped.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param index          The index of the image that has been selected/tapped.
 */
- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip didTapImageAtIndex:(NSUInteger)index;

@end


@interface PMImageFilmstrip : UIView

/**
 *  The object that acts as the delegate of the image filmstrip. The delegate must adopt
 *	the PMImageFilmstripDelegate protocol. The collection view maintains a weak reference to the delegate object.
 *	The delegate is responsible for configuring images in the filmstrip.
 */
@property (nonatomic, weak) id<PMImageFilmstripDelegate> delegate;

@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTap;

- (void) reloadImages;

- (void) scrollToImageAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end


@class PMZoomableImageFilmstrip;
@protocol PMZoomableImageFilmstripDelegate <PMImageFilmstripDelegate>

@optional

- (void) imageFilmstrip:(PMZoomableImageFilmstrip *)imageFilmstrip didPinchToCloseImageView:(UIImageView *)imageView;
- (void) imageFilmstrip:(PMZoomableImageFilmstrip *)imageFilmstrip willZoomImageView:(UIImageView *)imageView;
- (void) imageFilmstrip:(PMZoomableImageFilmstrip *)imageFilmstrip didZoomImageView:(UIImageView *)imageView toScale:(CGFloat)scale;

@end

@interface PMZoomableImageFilmstrip : PMImageFilmstrip

@property (nonatomic, weak) id<PMZoomableImageFilmstripDelegate> delegate;
@property (nonatomic) CGFloat maximumZoomScale;

@end
