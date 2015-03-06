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
//  UIView+PMUtils.m
//  Created by Peter Meyers on 3/1/14.
//
//

#import "UIView+PMUtils.h"
#import "UIImage+PMUtils.h"

@implementation UIView (PMUtils)

+ (void) setShared:(id)shared
{
	NSMutableSet *classes = [self PM_initializedSharedViewClasses];
	if (shared) {
		[classes addObject:self];
	}
	else {
		[classes removeObject:self];
	}
	[super setShared:shared];
}

+ (instancetype)shared
{
	NSMutableSet *classes = [self PM_initializedSharedViewClasses];

	id shared = nil;
	
	if ([classes containsObject:self] == NO) {
		[classes addObject:self];
		shared = [self instanceFromDefaultNibWithOwner:nil];
		[self setShared:shared];
	}
	
	if (!shared) {
		shared = [super shared];
	}
	
	return shared;
}

+ (NSString *) defaultNibName
{
    return NSStringFromClass(self);
}

+ (UINib *) defaultNib
{
    // Cache nibs to prevent unnecessary filesystem access
    static NSCache *nibs = nil;
    static dispatch_once_t cacheToken;
    dispatch_once(&cacheToken, ^{
        nibs = [NSCache new];
    });
    
    NSString *nibName = [self defaultNibName];
    UINib *nib = [nibs objectForKey:nibName];
    if (!nib) {
		nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        [nibs setObject:nib?:[NSNull null]  forKey:nibName];
    }
    else if ([nib isEqual:[NSNull null]]) {
        nib = nil;
    }
	return nib;
}

+ (instancetype) instanceFromDefaultNibWithOwner:(id)ownerOrNil
{
    UINib *nib = [self defaultNib];
    if (nib) {
        UIView *view = [nib instantiateWithOwner:ownerOrNil options:nil].firstObject;
        NSAssert ([view isKindOfClass:self], @"First object in nib '%@' was '%@'. Expected '%@'", [self defaultNibName], view, self);
        return view;
    }
    return nil;
}

- (void) removeSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (UIImage *)blurredViewWithRadius:(CGFloat)radius
						 iterations:(NSUInteger)iterations
					scaleDownFactor:(NSUInteger)scaleDownFactor
						 saturation:(CGFloat)saturation
						  tintColor:(UIColor *)tintColor
							   crop:(CGRect)crop
{
	UIGraphicsBeginImageContextWithOptions(crop.size, YES, 1.0f);

	CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
	
	[self drawViewHierarchyInRect:rect afterScreenUpdates:NO];
	
	UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return 	[snapshot blurredImageWithRadius:radius
								  iterations:iterations
							 scaleDownFactor:scaleDownFactor
								  saturation:saturation
								   tintColor:tintColor
										crop:crop];
}

#pragma mark - Layout


- (void) centerInRect:(CGRect)rect forDirection:(PMDirection)direction;
{
    CGRect frame = self.frame;
    
    if (direction & PMDirectionHorizontal) {
        frame.origin.x = floorf((rect.size.width - frame.size.width) / 2.0f + rect.origin.x);
    }
    
    if (direction & PMDirectionVertical) {
        frame.origin.y = floorf((rect.size.height - frame.size.height) / 2.0f + rect.origin.y);
    }
    
    self.frame = frame;
}

- (void) setFX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void) setFY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void) setFOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void) setFWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void) setFHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void) setFSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void) setBWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (void) setBHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}

- (void) setBSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

#pragma mark - Internal Methods


+ (NSMutableSet *) PM_initializedSharedViewClasses
{
	static dispatch_once_t cacheToken;
	static NSMutableSet *initializedSharedViewClasses = nil;
    dispatch_once(&cacheToken, ^{
		initializedSharedViewClasses = [NSMutableSet set];
    });
	return initializedSharedViewClasses;
}


@end
