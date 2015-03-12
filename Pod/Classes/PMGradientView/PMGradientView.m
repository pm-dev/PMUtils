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
//  PMLinearGradientView.m
//  Pods
//
//  Created by Peter Meyers on 10/1/14.
//
//


#import "PMGradientView.h"

@interface PMGradientView()
@property(nonatomic,readonly) CAGradientLayer *layer;
@end

@implementation PMGradientView

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
}

- (void)setStartColor:(UIColor *)startColor
{
    _startColor = startColor;
    [self setLayerColors];
}

- (void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    [self setLayerColors];
}

- (void) setLayerColors
{
    self.layer.colors = @[(__bridge id)(_startColor?:[UIColor clearColor]).CGColor,
                          (__bridge id)(_endColor?:[UIColor clearColor]).CGColor];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    self.layer.startPoint = startPoint;
}

- (CGPoint)startPoint
{
    return self.layer.startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint
{
    self.layer.endPoint = endPoint;
}

- (CGPoint)endPoint
{
    return self.layer.endPoint;
}

- (void)setMidPoint:(NSNumber *)midPoint
{
    self.layer.locations = @[midPoint];
}

- (void)setLocations:(NSArray *)locations
{
    self.layer.locations = locations;
}

- (NSArray *)locations
{
    return self.layer.locations;
}

@end
