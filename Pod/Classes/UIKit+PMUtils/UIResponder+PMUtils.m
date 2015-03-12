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
//  UIResponder+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 1/29/15.
//
//

#import "UIResponder+PMUtils.h"

@implementation UIResponder (PMUtils)

static __weak id PMCurrentFirstResponder;

+ (UIResponder *)firstResponder
{
    PMCurrentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(PM_findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return PMCurrentFirstResponder;
}


#pragma mark - Internal


- (void) PM_findFirstResponder:(id)sender
{
    PMCurrentFirstResponder = self;
}

@end
