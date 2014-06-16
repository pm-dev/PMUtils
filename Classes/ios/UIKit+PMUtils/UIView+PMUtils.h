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
//  UIView+PMUtils.h
//  Created by Peter Meyers on 3/1/14.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, PMDirection) {
    PMDirectionVertical = 1 << 0,
    PMDirectionHorizontal = 1 << 1
};

@interface UIView (PMUtils)


/**
 *  The default nib name is simply the name of the class.
 *
 *  @return The name of the class.
 */
+ (NSString *) defaultNibName;


/**
 *  Returns an UINib object initialized to the nib file in the main bundle with the name from +[UIView defaultNibName]. The UINib object looks for the nib file in the bundle's language-specific project directories first, followed by the Resources directory.
 *
 *  @return The initialized UINib object or nil if there were errors during initialization or the nib file could not be located.
 */
+ (UINib *) defaultNib;


/**
 *  Unarchives and instantiates the in-memory contents of [UIView defaultNib], then returns the first object from its top level objects. This method sets the views properties to their configured values, and reestablishes any connections to other objects. For detailed information about the nib-loading process, see Resource Programming Guide.
 *
 *  @param ownerOrNil The object to use as the owner of the nib file. If the nib file has an owner, you must specify a valid object for this parameter.
 *
 *  @return An instance of the first top level object from the default nib file.
 */
+ (instancetype) instanceFromDefaultNibWithOwner:(id)ownerOrNil;


/**
 *  Iterates through each subview and unlinks the view from its superview and its window, and removes it from the responder chain. If the view’s superview is not nil, the superview releases the view. Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing. Important: Never call this method from inside your view’s drawRect: method.
 */
- (void) removeSubviews;

/**
 *  Apply scale, blur, tint and/or saturation to a snapshot of the UIView or a cropped portion of the UIView.
 *
 *  @param radius          Radius of the blur.
 *  @param iterations      How many times to apply the blur algorithm.
 *  @param scaleDownFactor Factor by which to scale down the image. If bluring the image, also scaling down the image will reduce time spent blurring.
 *  @param saturation      Amount of saturation to apply to the image. Normal saturation is 1. A saturation of 0 results in black and white.
 *  @param tintColor       Tint to apply to the image. [UIColor clearColor] or nil for no tint. Apply an alpha to the tint color to reduce the effect.
 *  @param crop            The rect in the views's bounds to apply the effects to. The returned image's size will be the same as this rect. You may pass in CGRectZero if you want the snapshot & effects to be of the entire view.
 *
 *  @see -[UIImage blurredImageWithRadius:iterations:scaleDownFactor:saturation:tintColor:crop:]
 *  @return A UIImage snapshot of the view with the specified image effects.
 */
- (UIImage *)blurredViewWithRadius:(CGFloat)radius
						iterations:(NSUInteger)iterations
				   scaleDownFactor:(NSUInteger)scaleDownFactor
						saturation:(CGFloat)saturation
						 tintColor:(UIColor *)tintColor
							  crop:(CGRect)crop;

#pragma mark - Layout

/**
 *  Centers the view in the given rect for one or both directions.
 *
 *  @param rect      The rect to center the view on. Frequently, this will be a superview's bounds.
 *  @param direction A mask of directions indicating how to center the view.
 */
- (void) centerInRect:(CGRect)rect forDirection:(PMDirection)direction;

/**
 *  Sets the view's frame x-origin.
 *
 *  @param x The x-coordinate to assign to the frame's origin.
 */
- (void) setFX:(CGFloat)x;

/**
 *  Sets the view's frame y-origin.
 *
 *  @param y The y-coordinate to assign to the frame's origin.
 */
- (void) setFY:(CGFloat)y;

/**
 *  Sets the view's frame origin.
 *
 *  @param origin The origin to assign to the frame.
 */
- (void) setFOrigin:(CGPoint)origin;

/**
 *  Sets the view's frame width.
 *
 *  @param width The width to assign to the frame's size.
 */
- (void) setFWidth:(CGFloat)width;

/**
 *  Sets the view's frame height
 *
 *  @param height The height to assign to the frame's size.
 */
- (void) setFHeight:(CGFloat)height;

/**
 *  Set's the view's frame size
 *
 *  @param size The size to assign to the frame.
 */
- (void) setFSize:(CGSize)size;

/**
 *  Sets the view's bounds width
 *
 *  @param width The width to assign to the bounds size.
 */
- (void) setBWidth:(CGFloat)width;

/**
 *  Sets the view's bounds height
 *
 *  @param height The height to assign to the bounds size.
 */
- (void) setBHeight:(CGFloat)height;

/**
 *  Sets the view's bounds size.
 *
 *  @param size The size to assign to the bounds.
 */
- (void) setBSize:(CGSize)size;

@end
