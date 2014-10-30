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
//  UIScreen+PMUtils.h
//  Created by Peter Meyers on 3/1/14.
//

#import <UIKit/UIKit.h>

@interface UIScreen (PMUtils)

/**
 *  Check for determining whether the main screen has a height of 586 points, which is the case on iPhones starting at the iPhone 5, 5s and 5c. (As of 4/29/2014).
 *
 *  @return Boolean determining whether the main screen has a height of 586 points.
 */
+ (BOOL) is568h;

/**
 *  @return Boolean determining whether the main screen has scale of 2.0 or greater.
 */
+ (BOOL) isRetina;

/**
 *  @return Float value describing how many points are in one pixel for the main screen.
 */
+ (CGFloat) pointsPerPixel;

@end
