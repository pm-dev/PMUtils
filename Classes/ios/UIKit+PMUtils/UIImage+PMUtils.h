/*
 File: UIImage+ImageEffects.h
 Abstract: This is a category of UIImage that adds methods to apply blur and tint effects to an image. This is the code you’ll want to look out to find out how to use vImage to efficiently calculate a blur.
 Version: 1.0
 
 Version: 1.1
 Created by JUSTIN M FISCHER on 9/02/13.
 Copyright (c) 2013 Justin M Fischer. All rights reserved.
 
 Version: 1.2
 Created by PETER MEYERS on 4/28/201.
 Copyright (c) 2013 Peter Meyers. All rights reserved.
 
 Abstract: This category crops and scales image efficiently using vImage prior to applying blur.
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 
 JMF
 9/2/2013
 
 PM
 4/28/2014
 */

#import <UIKit/UIKit.h>
#import "UIView+PMUtils.h"

@interface UIImage (PMUtils)


/**
 *  Creates and returns a new resizable image with one point of flex horizontally and/or vertically. The remaining pixels will be apart of the end caps. If the images have an even width or height, the end caps will be one pixel smaller on the right and bottom, respectively. The original image remains untouched. During scaling or resizing, the middle pixel is tiled, left-to-right and top-to-bottom. This method is most useful for creating variable width buttons, whose center region grows or shrinks as needed.
 *
 *  @param direction A mask of the directions to make the image resizable in.
 *
 *  @return A new image object resizable in the specified direction.
 */
- (UIImage *) makeResizable:(PMDirection)direction;

/**
 *  Draws the entire image in a graphics context, respecting the image's orientation setting, and returns the result. This method can be called from any thread. In the default coordinate system, images are situated down and to the right of the specified point. This method draws the image at full opacity using the kCGBlendModeNormal blend mode.
 *
 *  @return An image object rendered into an offscreen graphics context.
 */
- (UIImage *) drawnImage;

/**
 *  Creates and returns an image object by loading the image data from the file at the specified path. This differs from +imageWithContentsOfFile: in that the underlying CGImage is cached in decoded form.
 *
 *  @param path The full path to the file.
 *
 *  @return A new image object for the specified file, or nil if the method could not initialize the image from the specified file.
 */
+ (UIImage *) cachedImageWithFile:(NSString *)path;

/**
 *  Creates a UIImage object with the specified image data. This differs from +imageWithData: in that the underlying CGImage is cached in decoded form.
 *
 *  @param The image data. This can be data from a file or data you create programmatically. 
 *
 *  @return A new image object for the specified data, or nil if the method could not initialize the image from the specified data.
 */
+ (UIImage *) cachedImageWithData:(NSData *)data;

/**
 *  Apply scale, blur, tint and/or saturation to the UIImage or a cropped portion of the UIImage. Important: The image must not have a size of CGSizeZero.
 *
 *  @param radius          Radius of the blur.
 *  @param iterations      How many times to apply the blur algorithm.
 *  @param scaleDownFactor Factor by which to scale down the image. If bluring the image, also scaling down the image will reduce time spent blurring.
 *  @param saturation      Amount of saturation to apply to the image. Normal saturation is 1. A saturation of 0 results in black and white.
 *  @param tintColor       Tint to apply to the image. [UIColor clearColor] or nil for no tint. Apply an alpha to the tint color to reduce the effect.
 *  @param crop            The rect in the image's bounds to apply the effects to. The returned image's size will be the same as this rect. You may pass in CGRectZero if you want to apply the effects to the entire image.
 *
 *  @see -[UIView blurredViewWithRadius:iterations:scaleDownFactor:saturation:tintColor:crop:]
 *  @return A new UIImage with the specified image effects.
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius
						 iterations:(NSUInteger)iterations
					scaleDownFactor:(NSUInteger)scaleDownFactor
						 saturation:(CGFloat)saturation
						  tintColor:(UIColor *)tintColor
							   crop:(CGRect)crop;
@end
