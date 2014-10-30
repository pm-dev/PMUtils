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
		shared = [self viewFromDefaultNibWithOwner:nil];
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

+ (instancetype) viewFromDefaultNibWithOwner:(id)ownerOrNil
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

- (BOOL) isSquare
{
    return (self.frameWidth == self.frameHeight);
}

- (UIEdgeInsets) edgeInsetsWithRect:(CGRect)rect
{
    CGFloat top = self.boundsY + rect.origin.y;
    CGFloat left = self.boundsX + rect.origin.x;
    CGFloat bottom = self.boundsMaxY - (rect.origin.y + rect.size.height);
    CGFloat right = self.boundsMaxX - (rect.origin.x + rect.size.width);
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGRect) centeredRectWithSize:(CGSize)size forDirection:(PMDirection)direction
{
    CGRect rect = CGRectZero;
    rect.size = size;
    
    if (direction & PMDirectionHorizontal) {
        rect.origin.x = floorf((self.boundsWidth - size.width) / 2.0f + self.boundsX);
    }
    
    if (direction & PMDirectionVertical) {
        rect.origin.y = floorf((self.boundsHeight - size.height) / 2.0f + self.boundsY);
    }
    return rect;
}

- (CGRect) convertFrameToCoordinateSystemOfView:(UIView *)view
{
    return [self convertRect:self.bounds toView:view];
}

- (void) setCenterX:(CGFloat)x
{
    NSAssert(!fmodf(self.window.screen.scale * x, 1.0f) , @"Setting x center that does not land on a pixel boundary.");
    self.center = CGPointMake(x, self.centerY);
}

- (CGFloat) centerX
{
    return self.center.x;
}

- (void) setCenterY:(CGFloat)y
{
    NSAssert(!fmodf(self.window.screen.scale * y, 1.0f) , @"Setting y center that does not land on a pixel boundary.");
    self.center = CGPointMake(self.centerX, y);
}

- (CGFloat) centerY
{
    return self.center.y;
}

+ (void) centerViews:(NSArray *)views inRect:(CGRect)rect forDirection:(PMDirection)direction withPadding:(CGFloat)padding
{
    NSAssert(direction == PMDirectionVertical || direction == PMDirectionHorizontal,
             @"direction must be either PMDirectionVerticalor PMDirectionHorizontal");
    
    CGFloat totalPadding = (views.count-1) * padding;
    
    switch (direction) {
        case PMDirectionVertical:
        {
            NSNumber *totalViewsHeight = [views valueForKeyPath:@"@sum.frameHeight"];
            CGFloat totalHeight = totalViewsHeight.floatValue + totalPadding;
            CGFloat yOrigin = floorf((rect.size.height - totalHeight)/2.0f);

            for (UIView *view in views) {
                view.frameY = yOrigin;
                yOrigin = view.frameMaxY + padding;
            }
            break;
        }
        case PMDirectionHorizontal:
        {
            NSNumber *totalViewsWidth = [views valueForKeyPath:@"@sum.frameWidth"];
            CGFloat totalWidth = totalViewsWidth.floatValue + totalPadding;
            CGFloat xOrigin = floorf((rect.size.width - totalWidth)/2.0f);
            
            for (UIView *view in views) {
                view.frameX = xOrigin;
                xOrigin = view.frameMaxX + padding;
            }
            break;
        }
    }
}

- (void) centerInSuperview
{
    [self centerInSuperviewForDirection:(PMDirectionVertical | PMDirectionHorizontal)];
}

- (void) centerInSuperviewForDirection:(PMDirection)direction
{
    [self centerInRect:self.superview.bounds forDirection:direction];
}

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

- (void) setFrameX:(CGFloat)x
{
    NSAssert(!fmodf(self.window.screen.scale * x, 1.0f) , @"Setting x origin that does not land on a pixel boundary.");
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat) frameX
{
    return self.frame.origin.x;
}

- (void) setFrameY:(CGFloat)y
{
    NSAssert(!fmodf(self.window.screen.scale * y, 1.0f) , @"Setting y origin that does not land on a pixel boundary.");
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat) frameY
{
    return self.frame.origin.y;
}

- (void) setFrameOrigin:(CGPoint)origin
{
    NSAssert(!fmodf(self.window.screen.scale * origin.x, 1.0f) , @"Setting x origin that does not land on a pixel boundary.");
    NSAssert(!fmodf(self.window.screen.scale * origin.y, 1.0f) , @"Setting y origin that does not land on a pixel boundary.");
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint) frameOrigin
{
    return self.frame.origin;
}

- (void) setFrameWidth:(CGFloat)width
{
    NSAssert(!fmodf(self.window.screen.scale * width, 1.0f) , @"Setting width that does not land on a pixel boundary.");
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat) frameWidth
{
    return self.frame.size.width;
}

- (void) setFrameHeight:(CGFloat)height
{
    NSAssert(!fmodf(self.window.screen.scale * height, 1.0f) , @"Setting height that does not land on a pixel boundary.");
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat) frameHeight
{
    return self.frame.size.height;
}

- (void) setFrameSize:(CGSize)size
{
    NSAssert(!fmodf(self.window.screen.scale * size.height, 1.0f) , @"Setting height that does not land on a pixel boundary.");
    NSAssert(!fmodf(self.window.screen.scale * size.width, 1.0f) , @"Setting width that does not land on a pixel boundary.");
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize) frameSize
{
    return self.frame.size;
}

- (void) setFrameMaxX:(CGFloat)maxX
{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat) frameMaxX
{
    return CGRectGetMaxX(self.frame);
}

- (void) setFrameMaxY:(CGFloat)maxY
{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

- (CGFloat) frameMaxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat) boundsX
{
    return self.bounds.origin.x;
}

- (CGFloat) boundsY
{
    return self.bounds.origin.y;
}

- (CGPoint) boundsOrigin
{
    return self.bounds.origin;
}

- (CGFloat) boundsWidth
{
    return self.bounds.size.width;
}

- (CGFloat) boundsHeight
{
    return self.bounds.size.height;
}

- (CGSize) boundsSize
{
    return self.bounds.size;
}

- (CGFloat) boundsMaxX
{
    return CGRectGetMaxX(self.bounds);
}

- (CGFloat) boundsMaxY
{
    return CGRectGetMaxY(self.bounds);
}

- (CGFloat) boundsMidX
{
    return CGRectGetMidX(self.bounds);
}

- (CGFloat) boundsMidY
{
    return CGRectGetMidY(self.bounds);
}

- (CGPoint) boundsCenter;
{
    return CGPointMake(self.boundsMidX, self.boundsMidY);
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
