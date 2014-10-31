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
#import "NSObject+PMUtils.h"

typedef NS_OPTIONS(NSUInteger, PMDirection) {
    PMDirectionVertical = 1 << 0,
    PMDirectionHorizontal = 1 << 1
};

@interface UIView (PMUtils)

/**
 *  Classes inheriting from UIView will attempt to initialize its shared instance using +[self instanceFromDefaultNibWithOwner:]
 *	instead of the default [[self alloc] init] method. For more info on +[self shared] see +[NSObject shared].
 *
 *  @return The shared instance for the receiver.
 */
+ (instancetype)shared;

/**
 *  The default nib name is simply the name of the class. Override this method to change the default nib name.
 *
 *  @return The default name of nib, which defaults to the name of the receiver's class.
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
+ (instancetype) viewFromDefaultNibWithOwner:(id)ownerOrNil;


- (BOOL) isVisible;

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

- (BOOL) isSquare;

- (UIEdgeInsets) edgeInsetsWithRect:(CGRect)rect;

- (CGRect) centeredRectWithSize:(CGSize)size forDirection:(PMDirection)direction;

/**
 *  Convert's the reciever's frame to the coordinate system of a given view.
 *
 *  @param view The view that is the target of the conversion operation. If view is nil, this method instead converts
 *  to window base coordinates. Otherwise, both view and the receiver must belong to the same UIWindow object.
 *
 *  @return The converted frame.
 */
- (CGRect) convertFrameToCoordinateSystemOfView:(UIView *)view;

/**
 *  Centers the view's frame at a given x-coordinate.
 *
 *  @param x The x-coordinate to center the view's frame on.
 */
- (void) setCenterX:(CGFloat)x;

/**
 *  Returns the x-coordinate of the view's center in its superview's coordinate system.
 *
 *  @return The x-coordinate of the view's center in its superview's coordinate system.
 */
- (CGFloat) centerX;

/**
 *  Centers the view's frame at a given y-coordinate.
 *
 *  @param y The y-coordinate to center the view's frame on.
 */
- (void) setCenterY:(CGFloat)y;

/**
 *  Returns the y-coordinate of the view's center in its superview's coordinate system.
 *
 *  @return The y-coordinate of the view's center in its superview's coordinate system.
 */
- (CGFloat) centerY;

/**
 *  Centers an array of views in a rectangle for a given direction.
 *
 *  @param views     The views to center.
 *  @param rect      The rectangle that the views are centered in.
 *  @param direction The direction to center the views in. You must specify one direction, but not both.
 *  If PMDirectionVertical is specified, the views' yOrigins will be modified, if PMDirectionHorizontal is specified,
 *  the views' xOrigins will be modified.
 *  @param padding  The spacing between each view in the specified direction.
 */
+ (void) centerViews:(NSArray *)views inRect:(CGRect)rect forDirection:(PMDirection)direction withPadding:(CGFloat)padding;

/**
 *  Centers the reciever in its superview.
 */
- (void) centerInSuperview;

/**
 *  Centers the reciever in its superview for a given direction.
 *
 *  @param direction The direction in which to center the reciever in its superview.
 */
- (void) centerInSuperviewForDirection:(PMDirection)direction;

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
- (void) setFrameX:(CGFloat)x;

/**
 *  Returns the x-coordinate of the view's frame's origin.
 *
 *  @return The x-coordinate of the view's frame's origin.
 */
- (CGFloat) frameX;

/**
 *  Sets the view's frame's y-origin.
 *
 *  @param y The y-coordinate to assign to the frame's origin.
 */
- (void) setFrameY:(CGFloat)y;

/**
 *  Returns the y-coordinate of the view's frame's origin.
 *
 *  @return The y-coordinate of the view's frame's origin.
 */
- (CGFloat) frameY;

/**
 *  Sets the origin of the view's frame.
 *
 *  @param origin The origin of the view's frame.
 */
- (void) setFrameOrigin:(CGPoint)origin;

/**
 *  Returns the view's frame's origin.
 *
 *  @return The the view's frame's origin.
 */
- (CGPoint) frameOrigin;

/**
 *  Sets the view's frame width.
 *
 *  @param width The width to assign to the frame's size.
 */
- (void) setFrameWidth:(CGFloat)width;

/**
 *  Returns the width of the view's frame.
 *
 *  @return The width of the view's frame.
 */
- (CGFloat) frameWidth;

/**
 *  Sets the view's frame height
 *
 *  @param height The height to assign to the frame's size.
 */
- (void) setFrameHeight:(CGFloat)height;

/**
 *  Returns the height of the view's frame.
 *
 *  @return The height of the view's frame.
 */
- (CGFloat) frameHeight;

/**
 *  Set's the view's frame size
 *
 *  @param size The size to assign to the frame.
 */
- (void) setFrameSize:(CGSize)size;

/**
 *  Returns the size of the view's frame.
 *
 *  @return The size of the view's frame.
 */
- (CGSize) frameSize;

/**
 *  Sets the view's frame's maximum x-coordinate. The maximum x is calculated from the frame's x-origin plus its width.
 *  When setting the maximum x coordinate, this method adjusts the frame's x-origin; the width does not change.
 *
 *  @param maxX The x-coordinate to set as the new maximum x-coordinate.
 */
- (void) setFrameMaxX:(CGFloat)maxX;

/**
 *  Returns the x-coordinate of the view's right edge in its superview's coordinate system.
 *
 *  @return The x-coordinate of the view's right edge in its superview's coordinate system.
 */
- (CGFloat) frameMaxX;

/**
 *  Sets the view's frame's maximum y-coordinate. The maximum y is calculated from the frame's y-origin plus its height.
 *  When setting the maximum y coordinate, this method adjusts the frame's y-origin; the height does not change.
 *
 *  @param maxY The y-coordinate to set as the new maximum y-coordinate.
 */
- (void) setFrameMaxY:(CGFloat)maxY;

/**
 *  Returns the y-coordinate of the view's bottom edge in its superview's coordinate system.
 *
 *  @return The y-coordinate of the view's bottom edge in its superview's coordinate system.
 */
- (CGFloat) frameMaxY;

/**
 *  Returns the x-coordinate of the view's bound's origin.
 *
 *  @return The x-coordinate of the view's bound's origin.
 */
- (CGFloat) boundsX;

/**
 *  Returns the y-coordinate of the view's bound's origin.
 *
 *  @return The y-coordinate of the view's bound's origin.
 */
- (CGFloat) boundsY;

/**
 *  Returns the view's bound's origin.
 *
 *  @return The the view's bound's origin.
 */
- (CGPoint) boundsOrigin;

/**
 *  Returns the width of the view's bounds.
 *
 *  @return The width of the view's bounds.
 */
- (CGFloat) boundsWidth;

/**
 *  Returns the height of the view's bounds.
 *
 *  @return The height of the view's bounds.
 */
- (CGFloat) boundsHeight;

/**
 *  Returns the size of the view's bounds.
 *
 *  @return The size of the view's bounds.
 */
- (CGSize) boundsSize;

/**
 *  Returns the x-coordinate of the right edge in its own coordinate system.
 *
 *  @return The x-coordinate of the right edge in its own coordinate system.
 */
- (CGFloat) boundsMaxX;

/**
 *  Returns the y-coordinate of the right edge in its own coordinate system.
 *
 *  @return The y-coordinate of the right edge in its own coordinate system.
 */
- (CGFloat) boundsMaxY;

/**
 *  Returns the x-coordinate that establishes the center of the view's bounds.
 *
 *  @return The x-coordinate that establishes the center of the view's bounds.
 */
- (CGFloat) boundsMidX;

/**
 *  Returns the y-coordinate that establishes the center of the view's bounds.
 *
 *  @return The y-coordinate that establishes the center of the view's bounds.
 */
- (CGFloat) boundsMidY;

/**
 *  Returns the point that establishes the center of the view's bounds.
 *
 *  @return The point that establishes the center of the view's bounds.
 */
- (CGPoint) boundsCenter;

@end
