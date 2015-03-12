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
