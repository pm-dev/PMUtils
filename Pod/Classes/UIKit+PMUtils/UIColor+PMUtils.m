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

inline UIColor * PMColorWithRGB(uint8_t red, uint8_t green, uint8_t blue) {
    return PMColorWithRGBA(red, green, blue, 1.0f);
}

inline UIColor * PMColorWithRGBA(uint8_t red, uint8_t green, uint8_t blue, CGFloat alpha) {
    return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:alpha];
}

inline UIColor * PMColorWithGreyscaleRGB(uint8_t greyscale) {
    return PMColorWithGreyscaleRGBA(greyscale, 1.0f);
}

inline UIColor * PMColorWithGreyscaleRGBA(uint8_t greyscale, CGFloat alpha) {
    return [UIColor colorWithWhite:greyscale/255.0f alpha:alpha];
}

inline UIColor * PMColorWithHex(NSString *hexString, CGFloat alpha) {
	
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	unsigned int colors;
	
	if ([scanner scanHexInt:&colors]) {
        
		unsigned int red = (colors >> 16) & 0xFF;
		unsigned int green = (colors >> 8) & 0xFF;
		unsigned int blue = colors & 0xFF;
		return PMColorWithRGBA(red, green, blue, alpha);
	}
	return [UIColor colorWithWhite:0.0f alpha:alpha];
}

@implementation UIColor (PMUtils)

- (CGFloat) alpha
{
    CGFloat alpha = 0.0f;
    [self getRed:NULL green:NULL blue:NULL alpha:&alpha];
    return alpha;
}

@end
