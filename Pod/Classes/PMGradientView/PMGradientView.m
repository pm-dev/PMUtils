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
