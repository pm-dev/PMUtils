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

@class FXPageControl;
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
 *  @param imageView      The imageView that is being scrolled to.
 *  @param index          The index of the image that is being scrolled to.
 */
- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip willScrollToImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;

/**
 *  Tells the delegate an image in the image filmstrip has been scrolled to.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param imageView      The imageView that has been scrolled to.
 *  @param index          The index of the image that has been scrolled to.
 */
- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip didScrollToImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;

/**
 *  Tells the delegate an image in the image filmstrip has been selected/tapped.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param imageView      The imageView that was tapped.
 *  @param index          The index of the image that has been selected/tapped.
 */
- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip didTapImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;

@end


@interface PMImageFilmstrip : UIView

/**
 *  The object that acts as the delegate of the image filmstrip. The delegate must adopt
 *	the PMImageFilmstripDelegate protocol. The filmstrip maintains a weak reference to the delegate object.
 *	The delegate is responsible for configuring images in the filmstrip.
 */
@property (nonatomic, weak) id<PMImageFilmstripDelegate> delegate;

/**
 *  A page control shown over the bottom of the image filmstrip when there are multiple images in the filmstrip.
 */
@property (nonatomic, strong, readonly) FXPageControl *pageControl;

/**
 *  The underlying gesture recognizer for a single tap gesture. Your application accesses this property 
 *  when it wants to more precisely control when a tap gesture is recongnized by the image filmstrip.
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTap;

/**
 *  A Boolean value that determines whether the receiver allows the images in the filmstrip to 
 *  continuously scroll as if on a carousel.
 */
@property (nonatomic) BOOL circularDisabled;

/**
 *  Reloads all of the data for the collection view. Call this method to reload all of the images in the filmstrip. 
 *  This causes the filmstrip to discard any currently visible images and redisplay them. For efficiency, the filmstrip
 *  only displays the image views that are visible.
 */
- (void) reloadImages;

/**
 *  Scrolls the filmstrip until the specified image index is visible.
 *
 *  @param index    The index of the image to scroll into view.
 *  @param animated Specify YES to animate the scrolling behavior or NO to adjust the filmstrip immediately.
 */
- (void) scrollToImageAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end


@class PMZoomableImageFilmstrip;
@protocol PMZoomableImageFilmstripDelegate <PMImageFilmstripDelegate>

@optional

/**
 *  Tells the delegate an image in the image filmstrip has been pinched in a gesture
 *  that indicates the user would like to close the filmstrip.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param imageView      The imageView that has been pinched.
 *  @param index          The index of the image that has been pinched.
 */
- (void) imageFilmstrip:(PMZoomableImageFilmstrip *)imageFilmstrip didPinchToCloseImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;

/**
 *  Tells the delegate that zooming of the filmstrip is about to commence.
 *  This method is called at the beginning of zoom gestures.
 *  You can use this method to store state information or perform any additional actions prior to zooming the view’s content.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param imageView      The imageView that will be zoomed.
 *  @param index          The index of the image that will be zoomed.
 */
- (void) imageFilmstrip:(PMZoomableImageFilmstrip *)imageFilmstrip willZoomImageView:(UIImageView *)imageView atIndex:(NSUInteger)index;

/**
 *  Tells the delegate an image in the image filmstrip completed zooming.
 *
 *  @param imageFilmstrip An object representing the image filmstrip.
 *  @param imageView      The imageView that has been zoomed.
 *  @param index          The index of the image that has been zoomed.
 */
- (void) imageFilmstrip:(PMZoomableImageFilmstrip *)imageFilmstrip didZoomImageView:(UIImageView *)imageView atIndex:(NSUInteger)index toScale:(CGFloat)scale;

@end

@interface PMZoomableImageFilmstrip : PMImageFilmstrip

/**
 *  The object that acts as the delegate of the image filmstrip. The delegate must adopt
 *	the PMZoomableImageFilmstripDelegate protocol. The filmstrip maintains a weak reference to the delegate object.
 *	The delegate is responsible for configuring images in the filmstrip.
 */
@property (nonatomic, weak) id<PMZoomableImageFilmstripDelegate> delegate;

/**
 *  A floating-point value that specifies the maximum scale factor that can be applied to the filmstrip.
 *  This value determines how large the images can be scaled. It must be greater than 1.0 for zooming to be enabled. The default value is 0.0.
 */
@property (nonatomic) CGFloat maximumZoomScale;

@end
