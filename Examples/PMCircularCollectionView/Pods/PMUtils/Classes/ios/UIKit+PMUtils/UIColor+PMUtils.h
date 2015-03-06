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
//  UIColor+PMUtils.h
//  Created by Peter Meyers on 3/2/14.
//

#import <UIKit/UIKit.h>

extern inline UIColor * PMColorWithRGBA(NSUInteger red, NSUInteger green, NSUInteger blue, CGFloat alpha);
extern inline UIColor * PMColorWithHex(NSString *hexString, CGFloat alpha);

@interface UIColor (PMUtils)


/**
 *  Returns the alpha component that makes up the color in the RGB color space, if the color is in a compatible color space.
 *
 *  @return The opacity component of the receiver, specified as a value between 0.0 and 1.0.
 */
- (CGFloat) alpha;

@end
