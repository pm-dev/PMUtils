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
#import "UIGestureRecognizer+PMUtils.h"
#import "NSObject+PMUtils.h"

CGRect PMRectOfContentInBounds(CGRect bounds, UIViewContentMode mode, CGSize contentSize)
{
    CGFloat extraWidth = bounds.size.width - contentSize.width;
    CGFloat extraHeight = bounds.size.height - contentSize.height;
    
    switch (mode) {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleToFill:
            return bounds;
            
        case UIViewContentModeCenter:
            return CGRectMake(extraWidth/2.0f, extraHeight/2.0f, contentSize.width, contentSize.height);
            
        case UIViewContentModeTop:
            return CGRectMake(extraWidth/2.0f, 0.0f, contentSize.width, contentSize.height);
            
        case UIViewContentModeBottom:
            return CGRectMake(extraWidth/2.0f, extraHeight, contentSize.width, contentSize.height);
            
        case UIViewContentModeLeft:
            return CGRectMake(0.0f, extraHeight/2.0f, contentSize.width, contentSize.height);
            
        case UIViewContentModeRight:
            return CGRectMake(extraWidth, extraHeight/2.0f, contentSize.width, contentSize.height);
            
        case UIViewContentModeTopLeft:
            return CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
            
        case UIViewContentModeTopRight:
            return CGRectMake(extraWidth, 0.0f, contentSize.width, contentSize.height);
            
        case UIViewContentModeBottomLeft:
            return CGRectMake(0.0f, extraHeight, contentSize.width, contentSize.height);
            
        case UIViewContentModeBottomRight:
            return CGRectMake(extraWidth, extraHeight, contentSize.width, contentSize.height);
            
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat widthScale = bounds.size.width / contentSize.width;
            CGFloat heightScale = bounds.size.height / contentSize.height;
            
            if (widthScale > heightScale) { // Fill to width
                
                CGFloat height = widthScale * contentSize.height;
                CGFloat y = (bounds.size.height - height) / 2.0f;
                return CGRectMake(0.0f, y, bounds.size.width, height);
            }
            else { // Fill to height
                
                CGFloat width = heightScale * contentSize.width;
                CGFloat x = (bounds.size.width - width) / 2.0f;
                return CGRectMake(x, 0.0f, width, bounds.size.height);
            }
            return bounds;
        }
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat widthScale = bounds.size.width / contentSize.width;
            CGFloat heightScale = bounds.size.height / contentSize.height;
            
            if (widthScale > heightScale) { // Fit to height
                
                CGFloat width = heightScale * contentSize.width;
                CGFloat y = (bounds.size.height - width) / 2.0f;
                return CGRectMake(0.0f, y, width, bounds.size.height);
            }
            else { // Fit to width
                
                CGFloat height = widthScale * contentSize.height;
                CGFloat x = (bounds.size.width - height) / 2.0f;
                return CGRectMake(x, 0.0f, bounds.size.width, height);
            }
            return bounds;
        }
    }
    return CGRectZero;
}


static inline NSMutableSet *PMInitializedSharedViewClasses() {
    static NSMutableSet *_initializedSharedViewClasses = nil;
    static dispatch_once_t cacheToken;
    dispatch_once(&cacheToken, ^{
        _initializedSharedViewClasses = [NSMutableSet set];
    });
    return _initializedSharedViewClasses;
}

static inline NSLock *PMSharedViewLock() {
    static NSLock *_sharedInstanceLock = nil;
    static dispatch_once_t cacheToken = 0;
    dispatch_once(&cacheToken, ^{
        _sharedInstanceLock = [[NSLock alloc] init];
    });
    return _sharedInstanceLock;
}

@implementation UIView (PMUtils)


+ (void) setShared:(id)shared
{
    NSMutableSet *classes = PMInitializedSharedViewClasses();
    
    [PMSharedViewLock() lock];
    if (shared) {
        [classes addObject:self];
    }
    else {
        [classes removeObject:self];
    }
    [PMSharedViewLock() unlock];
    
    [super setShared:shared];
}

+ (instancetype)shared
{
    NSMutableSet *classes = PMInitializedSharedViewClasses();
    
    [PMSharedViewLock() lock];
    if ([classes containsObject:self] == NO) {
        [classes addObject:self];
        UIView *shared = [self viewFromDefaultNibWithOwner:nil];
        [super setShared:shared];
    }
    [PMSharedViewLock() unlock];
    
    return [super shared];
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
        if ([[NSBundle mainBundle] URLForResource:nibName withExtension:@"nib"]) {
            nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        }
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

- (BOOL)isVisible
{
    return self.hidden == NO && self.alpha > 0.0f;
}

- (void) removeSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void) cancelInteraction
{
    for (UIView *subview in self.subviews) {
        [subview cancelInteraction];
    }
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        [gestureRecognizer cancel];
    }
}

- (UIView *) ancestorOfClass:(Class)ancestorClass
{
    NSParameterAssert([ancestorClass isSubclassOfClass:[UIView class]]);
    if (self.superview) {
        if ([self.superview isKindOfClass:ancestorClass]) {
            return self.superview;
        }
        return [self.superview ancestorOfClass:ancestorClass];
    }
    return nil;
}

- (UIImage *) snapshot
{
    return [self PM_croppedSnapshot:CGRectZero];
}

- (UIImage *)blurredViewWithRadius:(CGFloat)radius
                        iterations:(NSUInteger)iterations
                   scaleDownFactor:(NSUInteger)scaleDownFactor
                        saturation:(CGFloat)saturation
                         tintColor:(UIColor *)tintColor
                              crop:(CGRect)crop
{
    UIImage *snapshot = [self PM_croppedSnapshot:crop];
    return 	[snapshot blurredImageWithRadius:radius
                                  iterations:iterations
                             scaleDownFactor:scaleDownFactor
                                  saturation:saturation
                                   tintColor:tintColor
                                        crop:crop];
}

#pragma mark - Layout


- (UIEdgeInsets) edgeInsetsWithRect:(CGRect)rect
{
    CGFloat top = rect.origin.y;
    CGFloat left = rect.origin.x;
    CGFloat bottom = self.height - (rect.origin.y + rect.size.height);
    CGFloat right = self.width - (rect.origin.x + rect.size.width);
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGRect) convertFrameToCoordinateSystemOfView:(UIView *)view
{
    return [self convertRect:self.bounds toView:view];
}

- (void) centerSubviews:(NSArray *)views forDirection:(PMDirection)direction withPadding:(CGFloat)padding
{
    NSAssert(direction == PMDirectionVertical || direction == PMDirectionHorizontal,
             @"direction must be either PMDirectionVerticalor PMDirectionHorizontal");
    
    CGRect rect = self.bounds;
    CGFloat totalPadding = (views.count-1) * padding;
    
    switch (direction) {
        case PMDirectionVertical:
        {
            NSNumber *totalViewsHeight = [views valueForKeyPath:@"@sum.height"];
            CGFloat totalHeight = totalViewsHeight.floatValue + totalPadding;
            CGFloat yOrigin = floorf((rect.size.height - totalHeight)/2.0f);
            
            for (UIView *view in views) {
                CGRect frame = view.frame;
                frame.origin.y = yOrigin;
                view.frame = frame;
                yOrigin = view.maxY + padding;
            }
            break;
        }
        case PMDirectionHorizontal:
        {
            NSNumber *totalViewsWidth = [views valueForKeyPath:@"@sum.width"];
            CGFloat totalWidth = totalViewsWidth.floatValue + totalPadding;
            CGFloat xOrigin = floorf((rect.size.width - totalWidth)/2.0f);
            
            for (UIView *view in views) {
                CGRect frame = view.frame;
                frame.origin.x = xOrigin;
                view.frame = frame;
                xOrigin = view.maxX + padding;
            }
            break;
        }
    }
}

- (CGRect) centeredRectWithSize:(CGSize)size forDirection:(PMDirection)direction
{
    CGRect rect = CGRectZero;
    rect.size = size;
    
    if (direction & PMDirectionHorizontal) {
        rect.origin.x = floorf((self.width - size.width) / 2.0f);
    }
    
    if (direction & PMDirectionVertical) {
        rect.origin.y = floorf((self.height - size.height) / 2.0f);
    }
    return rect;
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

- (BOOL) isSquare
{
    return (self.width == self.height);
}

- (CGFloat) x
{
    return self.frame.origin.x;
}

- (CGFloat) y
{
    return self.frame.origin.y;
}

- (CGPoint) origin
{
    return self.frame.origin;
}

- (CGFloat) width
{
    NSParameterAssert(self.frame.size.width == self.bounds.size.width);
    return self.frame.size.width;
}

- (CGFloat) height
{
    NSParameterAssert(self.frame.size.height == self.bounds.size.height);
    return self.frame.size.height;
}

- (CGSize) size
{
    NSParameterAssert(CGSizeEqualToSize(self.frame.size, self.bounds.size));
    return self.frame.size;
}

- (CGFloat) maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat) maxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat) midX
{
    return self.center.x;
}

- (CGFloat) midY
{
    return self.center.y;
}


#pragma mark - Internal Methods


- (UIImage *) PM_croppedSnapshot:(CGRect)crop
{
    if (CGRectIsEmpty(crop)) {
        crop = self.bounds;
    }
    UIGraphicsBeginImageContextWithOptions(crop.size, YES, 1.0f);
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end
