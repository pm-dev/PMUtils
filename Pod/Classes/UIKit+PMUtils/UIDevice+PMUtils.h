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
//  UIDevice+PMUtils.h
//  Created by Peter Meyers on 3/1/14.
//
//

#import <UIKit/UIKit.h>

@interface UIDevice (PMUtils)

/**
 *  Checks if the style of interface to use on the current device is equal to UIUserInterfaceIdiomPad. 
 *  Yes if the style of interface to use on the current device is equal to UIUserInterfaceIdiomPad.
 */
@property (nonatomic, readonly) BOOL isPad;

/**
 *  Checks if the style of interface to use on the current device is equal to UIUserInterfaceIdiomPhone.
 *  Yes if the style of interface to use on the current device is equal to UIUserInterfaceIdiomPhone.
 */
@property (nonatomic, readonly) BOOL isPhone;


/**
 *  @return The number of independent cpu's running on the current device.
 */
+ (int) hardwareCores;

/**
 *  @return Total memory available on the current device.
 */
+ (size_t) hardwareRam;

/**
 *  @return The machine name of the current device.
 */
+ (NSString *) machine;

/**
 *  @return The number of bytes available in the root volume to the application.
 */
+ (uint64_t) availableBytes;

@end
