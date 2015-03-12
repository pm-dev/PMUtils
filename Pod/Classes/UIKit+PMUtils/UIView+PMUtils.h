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

extern CGRect PMRectOfContentInBounds(CGRect bounds, UIViewContentMode mode, CGSize contentSize);

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

/**
 *  YES if the reciever is not hidden and has an alpha of greater than 0.0
 */
@property (nonatomic, readonly) BOOL isVisible;

/**
 *  Iterates through each subview and unlinks the view from its superview and its window, and removes it from the responder chain. If the view’s superview is not nil, the superview releases the view. Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing. Important: Never call this method from inside your view’s drawRect: method.
 */
- (void) removeSubviews;

/**
 *  This method recursively looks through its subviews and cancels any gesture recognizers currently
 *  enabled on those subviews.
 */
- (void) cancelInteraction;

/**
 *  Returns an the closest ancestor superview of a given class type.
 *
 *  @param ancestorClass The class type of the ancestor to search for. Must be a UIView or UIView subclass.
 *
 *  @return An instance of the closest ancestor of a given class type. If the reciever has no ancestor of the given class type, returns nil.
 */
- (UIView *) ancestorOfClass:(Class)ancestorClass;

/**
 *  Creates a snapshot of the complete view hierarchy as visible onscreen into a new UIImage. Renders a snapshot in the view hierarchy’s current state, which might not include recent changes.
 */
@property (nonatomic, copy, readonly) UIImage *snapshot;

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
 *  Returns the edge insets created by finding the difference between each edge of the reciever and
 *  the corresponding edges of a passed in rect.
 *
 *  @param rect The rect used to inset the reciever's edges.
 *
 *  @return Edge insets representing the difference between each edge of the reciever and
 *  the corresponding edges a given rect.
 */
- (UIEdgeInsets) edgeInsetsWithRect:(CGRect)rect;

/**
 *  Returns the rect that, if applied as the frame of the reciever, would center the reciever about a given size in the supplied direction(s)
 *
 *  @param size      The size to center the reciever's dimensions around.
 *  @param direction The direction(s) about which the resulting rect is centered.
 *
 *  @return A rect centered around around a given size.
 */
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
 *  Centers an array of views in the receivers' bounds for a given direction.
 *
 *  @param views     The views to center.
 *  @param direction The direction to center the views in. You must specify one direction, but not both.
 *  If PMDirectionVertical is specified, the views' yOrigins will be modified, if PMDirectionHorizontal is specified,
 *  the views' xOrigins will be modified.
 *  @param padding  The spacing between each view in the specified direction.
 */
- (void) centerSubviews:(NSArray *)views forDirection:(PMDirection)direction withPadding:(CGFloat)padding;

/**
 *  Centers the view in the given rect for one or both directions.
 *
 *  @param rect      The rect to center the receiver in.
 *  @param direction A mask of directions indicating how to center the view.
 */
- (void) centerInRect:(CGRect)rect forDirection:(PMDirection)direction;

/**
 *  YES if the reciever's width is equal to its height. Otherwise NO.
 */
@property (nonatomic, readonly) BOOL isSquare;

/**
 *  Returns the x-coordinate of the view's frame's origin.
 *
 *  @return The x-coordinate of the view's frame's origin.
 */
@property (nonatomic, readonly) CGFloat x;

/**
 *  Returns the y-coordinate of the view's frame's origin.
 *
 *  @return The y-coordinate of the view's frame's origin.
 */
@property (nonatomic, readonly) CGFloat y;

/**
 *  Returns the view's frame's origin.
 *
 *  @return The the view's frame's origin.
 */
@property (nonatomic, readonly) CGPoint origin;

/**
 *  Returns the width of the view's frame.
 *
 *  @return The width of the view's frame.
 */
@property (nonatomic, readonly) CGFloat width;

/**
 *  Returns the height of the view's frame.
 *
 *  @return The height of the view's frame.
 */
@property (nonatomic, readonly) CGFloat height;

/**
 *  Returns the size of the view's frame.
 *
 *  @return The size of the view's frame.
 */
@property (nonatomic, readonly) CGSize size;

/**
 *  Returns the x-coordinate of the view's right edge in its superview's coordinate system.
 *
 *  @return The x-coordinate of the view's right edge in its superview's coordinate system.
 */
@property (nonatomic, readonly) CGFloat maxX;

/**
 *  Returns the y-coordinate of the view's bottom edge in its superview's coordinate system.
 *
 *  @return The y-coordinate of the view's bottom edge in its superview's coordinate system.
 */
@property (nonatomic, readonly) CGFloat maxY;

/**
 *  Returns the x-coordinate of the view's center in its superview's coordinate system.
 *
 *  @return The x-coordinate of the view's center in its superview's coordinate system.
 */
@property (nonatomic, readonly) CGFloat midX;

/**
 *  Returns the y-coordinate of the view's center in its superview's coordinate system.
 *
 *  @return The y-coordinate of the view's center in its superview's coordinate system.
 */
@property (nonatomic, readonly) CGFloat midY;


@end
