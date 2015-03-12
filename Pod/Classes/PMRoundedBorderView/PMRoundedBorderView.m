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
//  PMRoundedBorderView.m
//  Pods
//
//  Created by Peter Meyers on 10/1/14.
//
//

#import "PMRoundedBorderView.h"

@interface PMRoundedBorderLayer : CAShapeLayer
@property (nonatomic) UIRectCorner corners;
@property (nonatomic) CGSize cornerRadii;
@end

@interface PMRoundedBorderView ()
@property (nonatomic, retain, readonly) PMRoundedBorderLayer *layer;
@end

@implementation PMRoundedBorderView

+ (Class) layerClass
{
    return [PMRoundedBorderLayer class];
}

- (UIColor *) backgroundColor
{
    return [UIColor colorWithCGColor:self.layer.fillColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.layer.fillColor = backgroundColor.CGColor;
}

#pragma mark - Accessors


- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.strokeColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.strokeColor = borderColor.CGColor;
    [self.layer setNeedsDisplay];
}

- (CGFloat)borderWidth
{
    return self.layer.lineWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.lineWidth = borderWidth;
    [self.layer setNeedsDisplay];
}

- (UIRectCorner) corners
{
    return self.layer.corners;
}

- (CGSize) cornerRadii
{
    return self.layer.cornerRadii;
}

- (void)setCornerRadii:(CGSize)cornerRadii
{
    self.layer.cornerRadii = cornerRadii;
}

- (void)setCorners:(UIRectCorner)corners
{
    self.layer.corners = corners;
}

@end

@implementation PMRoundedBorderLayer
{
    CAShapeLayer *_strokeLayer;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.path = [self pathForBounds:bounds].CGPath;
    [self setNeedsDisplay];
}

- (UIBezierPath *)pathForBounds:(CGRect)bounds
{
    CGFloat halfWidth = self.lineWidth/2.0f;
    return [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bounds, halfWidth, halfWidth)
                                 byRoundingCorners:self.corners
                                       cornerRadii:self.cornerRadii];
}

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key
{
    [super addAnimation:animation forKey:key];
    if ([animation isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnimation = (CABasicAnimation *)animation;
        if ([basicAnimation.keyPath isEqualToString:@"bounds.size"]) {
            CABasicAnimation *pathAnimation = [basicAnimation copy];
            pathAnimation.keyPath = NSStringFromSelector(@selector(path));
            pathAnimation.fromValue = (__bridge id)(self.path);
            pathAnimation.toValue = (__bridge id)([self pathForBounds:self.bounds].CGPath);
            [self addAnimation:pathAnimation forKey:NSStringFromSelector(@selector(path))];
        }
    }
}

- (void)setCornerRadii:(CGSize)cornerRadii
{
    _cornerRadii = cornerRadii;
    self.path = [self pathForBounds:self.bounds].CGPath;
    [self needsDisplay];
}

- (void)setCorners:(UIRectCorner)corners
{
    _corners = corners;
    self.path = [self pathForBounds:self.bounds].CGPath;
    [self needsDisplay];
}

- (void)setBorderColor:(CGColorRef)borderColor
{
    self.strokeColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.lineWidth = borderWidth;
    self.path = [self pathForBounds:self.bounds].CGPath;
    [self setNeedsDisplay];
}

- (void) setCornerRadius:(CGFloat)cornerRadius
{
    self.cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
}

- (CGFloat)cornerRadius
{
    return MAX(self.cornerRadii.height, self.cornerRadii.width);
}

@end
