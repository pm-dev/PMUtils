//
//  PMGradientView.h
//  Pods
//
//  Created by Peter Meyers on 10/1/14.
//
//

#import <UIKit/UIKit.h>

@interface PMGradientView : UIView

/**
 *  The color associated with the start point of the gradient. Default is [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *startColor;

/**
 *  The color associated with the end point of the gradient. Default is [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *endColor;

/**
 *  The start point of the gradient. Animatable. The start point corresponds to the first stop of the gradient. The point is defined in the unit coordinate space and is then mapped to the view's layer’s bounds rectangle when drawn. Default value is (0.5,0.0).
 */
@property (nonatomic) CGPoint startPoint;

/**
 *  The end point of the gradient. Animatable. The end point corresponds to the last stop of the gradient. The point is defined in the unit coordinate space and is then mapped to the layer’s bounds rectangle when drawn. Default value is (0.5,1.0).
 */
@property (nonatomic) CGPoint endPoint;

/**
 *  An optional array of NSNumber objects defining the location of each gradient stop. Animatable. Defaults to @0.5
 */
@property (nonatomic, strong) NSArray *locations;

@end
