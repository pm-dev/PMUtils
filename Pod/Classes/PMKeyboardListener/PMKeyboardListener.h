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
//  PMKeyboardListener.h
//  Pods
//
//  Created by Peter Meyers on 10/21/14.
//
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PMKeyboardState)
{
    PMKeyboardStateHidden,
    PMKeyboardStateAppearing,
    PMKeyboardStateVisible,
    PMKeyboardStateDisappearing
};

@interface PMKeyboardListener : NSObject

/**
 *  Call this method to start observing changes to the keyboard state.
 */
+ (void) startListening;

/**
 *  Returns the current state of the kayboard.
 *
 *  @return The current state of the keyboard.
 */
+ (PMKeyboardState) keyboardState;

/**
 *  The current frame of the keyboard OR if animating, the frame that
 *  the keyboard is animating to.
 *
 *  @return The keyboard frame.
 */
+ (CGRect) keyboardFrame;

@end
