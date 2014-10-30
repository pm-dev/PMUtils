//
//  PMRoundedBorderView.h
//  Pods
//
//  Created by Peter Meyers on 10/1/14.
//
//

#import <UIKit/UIKit.h>

@interface PMRoundedBorderView : UIView

/**
 *  The color of the view's border. Animatable. The default value of this property is an opaque white color.
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  The corners of the view to round. The default value of this property is 0.
 */
@property (nonatomic) UIRectCorner corners;

/**
 *  The blur radius (in points) used to render the inner shadow. Animatable. The default value of this property is 1.
 */
@property (nonatomic) CGFloat borderWidth;

/**
 *  The radius to use when drawing rounded corners for the view's inner shadow. Animatable. The default value
 *	of this property is CGSizeZero.
 */
@property (nonatomic) CGSize cornerRadii;


@end
