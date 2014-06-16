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
//  UIColor+PMUtils.m
//  Created by Peter Meyers on 3/2/14.
//
//

#import "UIColor+PMUtils.h"

@implementation UIColor (PMUtils)

+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	unsigned int colors;
	
	if ([scanner scanHexInt:&colors])
	{
		unsigned int red = (colors >> 16) & 0x00FF;
		unsigned int green = (colors >> 8) & 0x00FF;
		unsigned int blue = colors & 0x00FF;
		
		return [UIColor colorWithRed:RGB(red) green:RGB(green) blue:RGB(blue) alpha:alpha];
	}
	
	return [UIColor colorWithWhite:0.0f alpha:alpha];
}

- (CGFloat) alpha
{
    CGFloat alpha = 0.0f;
    [self getRed:NULL green:NULL blue:NULL alpha:&alpha];
    return alpha;
}

@end
