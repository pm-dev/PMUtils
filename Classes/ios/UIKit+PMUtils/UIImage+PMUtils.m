/*
 File: UIImage+PMUtils.m
 
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


#import "UIImage+PMUtils.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>

static NSUInteger const bitsPerComponent = 8;
static NSUInteger const bytesPerPixel = 4;

@implementation UIImage (PMUtils)

- (UIImage *) makeResizable:(PMDirection)direction;
{
    CGFloat leftInset = 0.0f;
    CGFloat rightInset = 0.0f;
    
    if (direction & PMDirectionHorizontal) {
        leftInset = floorf(self.size.width / 2.0f);
        rightInset = leftInset + 1.0f;
    }
    
    CGFloat topInset = 0.0f;
    CGFloat bottomInset = 0.0f;
    
    if (direction & PMDirectionVertical) {
        topInset = floorf(self.size.height / 2.0f);
        bottomInset = topInset + 1.0f;
    }
    
	UIEdgeInsets capInsets = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset);
	
	return [self resizableImageWithCapInsets:capInsets];
}

- (UIImage *) drawnImage
{
	UIGraphicsBeginImageContextWithOptions(self.size, YES, self.scale);
	
	[self drawAtPoint:CGPointZero];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return image;
}

+ (UIImage *) cachedImageWithData:(NSData *)data
{
	CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef) data, NULL);

	UIImage *image = [self imageFromSource:source];
		
	CFRelease(source);
	
	return image? : [UIImage imageWithData:data];
}

+ (UIImage *) cachedImageWithFile:(NSString *)path
{
	CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef) path, NULL);
	
	UIImage *image = [self imageFromSource:source];

	CFRelease(source);
	
	return image? : [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *) imageFromSource:(CGImageSourceRef)source
{
	if (source) {
		static NSDictionary *cacheOptionsDict = nil;
		static dispatch_once_t cacheOptionsToken = 0;
		dispatch_once(&cacheOptionsToken, ^{
			cacheOptionsDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
														   forKey:(id)kCGImageSourceShouldCache];
		});
		
		CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)cacheOptionsDict);
		UIImage *image = [UIImage imageWithCGImage:cgImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
		CGImageRelease(cgImage);
		return image;
	}
	return nil;
}


- (UIImage *)blurredImageWithRadius:(CGFloat)radius
						 iterations:(NSUInteger)iterations
					scaleDownFactor:(NSUInteger)scaleDownFactor
						 saturation:(CGFloat)saturation
						  tintColor:(UIColor *)tintColor
							   crop:(CGRect)crop
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
	
	if (CGRectIsEmpty(crop)) {
		crop = CGRectMake(0, 0, self.size.width, self.size.height);
	}
	CGImageRef sourceImageRef = CGImageCreateWithImageInRect(self.CGImage, crop);
	
	CGColorSpaceRef sourceColorRef = CGImageGetColorSpace(sourceImageRef);
	CGBitmapInfo sourceBitmapInfo = CGImageGetBitmapInfo(sourceImageRef);

	// scale down image
	NSUInteger sourceWidth = CGImageGetWidth(sourceImageRef);
	NSUInteger sourceHeight = CGImageGetHeight(sourceImageRef);
	
	unsigned char *sourceData = (unsigned char*) calloc(sourceWidth * sourceHeight * bytesPerPixel, sizeof(unsigned char));
	
	vImage_Buffer sourceBuffer = {
        .data = sourceData,
        .height = sourceHeight,
        .width = sourceWidth,
        .rowBytes = CGImageGetBytesPerRow(sourceImageRef)
    };
	vImage_Buffer destBuffer = sourceBuffer;
	CGImageRef scaledImageRef = sourceImageRef;
	
	if (scaleDownFactor > 1)
	{
		CGContextRef context = CGBitmapContextCreate(sourceData,
													 sourceBuffer.width,
													 sourceBuffer.height,
													 bitsPerComponent,
													 sourceBuffer.rowBytes,
													 sourceColorRef,
													 sourceBitmapInfo);
		
		CGContextDrawImage(context,
						   CGRectMake(0, 0, sourceBuffer.width, sourceBuffer.height),
						   sourceImageRef);
		
		CGContextRelease(context);
		
		NSUInteger destWidth = sourceBuffer.width / scaleDownFactor;
		NSUInteger destHeight = sourceBuffer.height / scaleDownFactor;
		
		unsigned char *destData = (unsigned char*) calloc(destWidth * destHeight * bytesPerPixel, sizeof(unsigned char));
		
		destBuffer.data = destData;
		destBuffer.height = destHeight;
		destBuffer.width = destWidth;
		destBuffer.rowBytes = bytesPerPixel * destWidth;
		
		vImageScale_ARGB8888 (&sourceBuffer, &destBuffer, NULL, kvImageNoInterpolation);
		
		free(sourceData);
		
		CGContextRef scaledContext = CGBitmapContextCreate(destData,
														   destBuffer.width,
														   destBuffer.height,
														   bitsPerComponent,
														   destBuffer.rowBytes,
														   sourceColorRef,
														   sourceBitmapInfo);
		
		scaledImageRef = CGBitmapContextCreateImage(scaledContext);
		CGContextRelease(scaledContext);
		free(destData);
	}
	
	CGImageRelease(sourceImageRef);
	
	// blur
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
	// setup image buffers for blurring
	sourceBuffer.width = destBuffer.width;
	sourceBuffer.height = destBuffer.height;
	sourceBuffer.rowBytes = destBuffer.rowBytes;
	size_t bytes = sourceBuffer.rowBytes * sourceBuffer.height;
    sourceBuffer.data = malloc(bytes);
    destBuffer.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&sourceBuffer,
																 &destBuffer, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(scaledImageRef));
    memcpy(sourceBuffer.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
	CGImageRelease(scaledImageRef);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&sourceBuffer, &destBuffer, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = sourceBuffer.data;
        sourceBuffer.data = destBuffer.data;
        destBuffer.data = temp;
    }
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(sourceBuffer.data,
											 sourceBuffer.width,
											 sourceBuffer.height,
                                             bitsPerComponent,
											 sourceBuffer.rowBytes,
											 sourceColorRef,
                                             sourceBitmapInfo);
    
	BOOL hasSaturationChange = fabs(saturation - 1.) > __FLT_EPSILON__;
	if (hasSaturationChange)
	{
		CGFloat s = saturation;
		CGFloat floatingPointSaturationMatrix[] = {
			0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
			0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
			0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
			0,                    0,                    0,					  1,
		};
		
		const int32_t divisor = 256;
		NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
		int16_t saturationMatrix[matrixSize];
		
		for (NSUInteger i = 0; i < matrixSize; ++i) {
			saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
		}
		
		vImageMatrixMultiply_ARGB8888(&destBuffer,
									  &sourceBuffer,
									  saturationMatrix,
									  divisor,
									  NULL,
									  NULL,
									  kvImageNoFlags);
	}
	
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
        CGContextFillRect(ctx, CGRectMake(0, 0, sourceBuffer.width, sourceBuffer.height));
    }

    //create image from context
    CGImageRef blurredImageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:blurredImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(blurredImageRef);
    CGContextRelease(ctx);
    free(sourceBuffer.data);
	free(destBuffer.data);
    return image;
}


@end
