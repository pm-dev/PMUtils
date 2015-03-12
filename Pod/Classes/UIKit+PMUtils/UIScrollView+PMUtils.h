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
//  UIScrollView+PMUtils.h
//  Created by Peter Meyers on 3/25/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMScrollDirection) {
    PMScrollDirectionNone,
    PMScrollDirectionPositive,
    PMScrollDirectionNegative
};

@interface UIScrollView (PMUtils)

/**
 *  If the scroll view is currently animating a scroll, this method will stop the scroll at the current contentOffset.
 */
- (void) killScroll;

/**
 *  The center point of the recievers content.
 */
@property (nonatomic, readonly) CGPoint contentCenter;

/**
 *  Calculates the content offset if the supplied rect was centered within the currently visible rect.
 *
 *	@param rect A rect to base the contentOffset of off, if the rect was centered in the visible rect.
 *
 *  @return The point at which the origin of the content view is offset from the origin of the scroll view if rect was
 *	centered within the scroll view.
 */
- (CGPoint) contentOffsetForCenteredRect:(CGRect)rect;

/**
 *  The point at which the origin of the content view is offset from the center of the scroll view's bounds.
 */
@property (nonatomic, readonly) CGPoint contentOffsetInBoundsCenter;

/**
 *  The rect of the content view currently visible within the bounds of the scroll view..
 */
@property (nonatomic, readonly) CGRect visibleRect;

@end
