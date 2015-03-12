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
