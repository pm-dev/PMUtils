//
//  PMInnerShadowView.h
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

#import <UIKit/UIKit.h>

@interface PMInnerShadowView : UIView

/**
 *  The color of the view's shadow. Animatable. The default value of this property is an opaque white color.
 */
@property (nonatomic, strong) UIColor* shadowColor;

/**
 *  The edges of the view on which to show an inner shadow. The default value of this property is UIRectEdgeAll.
 */
@property (nonatomic) UIRectEdge edges;

/**
 *  The opacity of the layer’s shadow. Animatable. The value in this property must 
 *	be in the range 0.0 (transparent) to 1.0 (opaque). The default value of this property is 1.0.
 */
@property (nonatomic) CGFloat shadowOpacity;

/**
 *  The offset (in points) of the view's inner shadow. Animatable. The default value of this property is (0.0, 0.0)
 */
@property (nonatomic) CGSize shadowOffset;

/**
 *  The blur radius (in points) used to render the inner shadow. Animatable. The default value of this property is 5.
 */
@property (nonatomic) CGFloat shadowRadius;

/**
 *  The radius to use when drawing rounded corners for the view's inner shadow. Animatable. The default value
 *	of this property is 0.0.
 */
@property (nonatomic) CGFloat cornerRadius;

@end
