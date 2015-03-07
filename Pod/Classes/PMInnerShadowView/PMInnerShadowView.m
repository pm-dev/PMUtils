//
//  PMInnerShadowView.m
//  PMInnerShadowView
//
//  This is based off a project by Yasuhiro Inami on 2012/10/14.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//
//  Version: 1.1
//  Created by PETER MEYERS on 8/21/2014.
//  Copyright (c) 2013 Peter Meyers. All rights reserved.
//  The original source code can be found at:
//  https://github.com/inamiy/YIInnerShadowView

#import "PMInnerShadowView.h"

@interface PMInnerShadowLayer : CAShapeLayer
@property (nonatomic) UIRectEdge edges;
@end

@implementation PMInnerShadowView
{
    PMInnerShadowLayer *_innerShadowLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self PM_commonPMInnerShadowViewInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self PM_commonPMInnerShadowViewInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _innerShadowLayer.frame = self.layer.bounds;
}


#pragma mark - Accessors


- (UIRectEdge)edges
{
    return _innerShadowLayer.edges;
}

- (void)setEdges:(UIRectEdge)edges
{
    _innerShadowLayer.edges = edges;
}

- (UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:_innerShadowLayer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _innerShadowLayer.shadowColor = shadowColor.CGColor;
}

- (CGFloat)shadowOpacity
{
    return _innerShadowLayer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _innerShadowLayer.shadowOpacity = shadowOpacity;
}

- (CGSize)shadowOffset
{
    return _innerShadowLayer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _innerShadowLayer.shadowOffset = shadowOffset;
}

- (CGFloat)shadowRadius
{
    return _innerShadowLayer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _innerShadowLayer.shadowRadius = shadowRadius;
}

- (CGFloat)cornerRadius;
{
    return _innerShadowLayer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius;
{
    self.layer.cornerRadius = cornerRadius;
    _innerShadowLayer.cornerRadius = cornerRadius;
}

#pragma mark - Private Methods

- (void)PM_commonPMInnerShadowViewInit
{
    NSNull *null = [NSNull null];
    _innerShadowLayer = [PMInnerShadowLayer layer];
    _innerShadowLayer.actions = @{@"position": null,
                                  @"bounds": null,
                                  @"contents": null,
                                  @"shadowColor": null,
                                  @"shadowOpacity": null,
                                  @"shadowOffset": null,
                                  @"shadowRadius": null};
    [self.layer addSublayer:_innerShadowLayer];
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = NO;
}

@end

@implementation PMInnerShadowLayer

- (id)init
{
    self = [super init];
    if (self) {
        self.masksToBounds = YES;
        self.needsDisplayOnBoundsChange = YES;
        self.shouldRasterize = YES;
        self.shadowColor = [UIColor whiteColor].CGColor;
        self.shadowOffset = CGSizeZero;
        self.shadowOpacity = 1.0f;
        self.shadowRadius = 5;
        self.fillRule = kCAFillRuleEvenOdd;
        self.edges = UIRectEdgeAll;
    }
    return self;
}

- (void)layoutSublayers
{
    [super layoutSublayers];

    CGFloat top = (self.edges & UIRectEdgeTop)? self.shadowRadius : 0.0f;
    CGFloat bottom = (self.edges & UIRectEdgeBottom)? self.shadowRadius : 0.0f;
    CGFloat left = (self.edges & UIRectEdgeLeft)? self.shadowRadius : 0.0f;
    CGFloat right = (self.edges & UIRectEdgeRight)? self.shadowRadius : 0.0f;
    CGRect largerRect = self.bounds;
    largerRect.origin.x -= left;
    largerRect.origin.y -= top;
    largerRect.size.width += left + right;
    largerRect.size.height += top + bottom;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, largerRect);
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    CGPathAddPath(path, NULL, bezier.CGPath);
    CGPathCloseSubpath(path);

    [self setPath:path];
    CGPathRelease(path);
}

#pragma mark - Accessors

- (void)setEdges:(UIRectEdge)edges
{
    _edges = edges;
    [self setNeedsLayout];
}

- (void)setShadowColor:(CGColorRef)shadowColor
{
    [super setShadowColor:shadowColor];
    [self setNeedsLayout];
}

- (void)setShadowOpacity:(float)shadowOpacity
{
    [super setShadowOpacity:shadowOpacity];
    [self setNeedsLayout];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    [super setShadowOffset:shadowOffset];
    [self setNeedsLayout];
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    [super setShadowRadius:shadowRadius];
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [super setCornerRadius:cornerRadius];
    [self setNeedsLayout];
}

@end
