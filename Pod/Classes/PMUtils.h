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
//  PMUtils.h
//  Created by Peter Meyers on 3/2/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#ifndef PMUtils_iOSExample_PMUtils_h
#define PMUtils_iOSExample_PMUtils_h

#import "UIKit+PMUtils.h"
#import "Foundation+PMUtils.h"
#import "PMOrderedDictionary.h"
#import "PMFloatTextField.h"
#import "PMPlaceholderTextView.h"
#import "PMProtocolInterceptor.h"
#import "PMImageFilmstrip.h"
#import "PMInfiniteScrollView.h"
#import "PMMapView.h"
#import "PMAnimationOperation.h"
#import "PMCollectionViewSwipeCell.h"
#import "PMCircularCollectionView.h"
#import "PMInnerShadowView.h"
#import "PMRoundedBorderView.h"
#import "PMGradientView.h"
#import "PMKeyboardListener.h"
#import "PMStickyHeaderFlowLayout.h"

#if DEBUG
#define DLog(args...)   NSLog(args)
#else
#define DLog(args...)
#endif

#define DEF_weak(var, weakName)    __weak __typeof(var) weakName = var;
#define DEF_strong(var, strongName) __strong __typeof(var) strongName = var;

#define STRINGIFY2(s) #s
#define STRINGIFY(s) @STRINGIFY2(s)

// Units
extern NSTimeInterval const PMOneMilisecond;
extern NSTimeInterval const PMOneSecond;
extern NSTimeInterval const PMOneMinute;
extern NSTimeInterval const PMOneMilisecond;
extern NSTimeInterval const PMOneHour;
extern NSTimeInterval const PMOneDay;
extern NSTimeInterval const PMOneWeek;

extern NSUInteger const PMBytesPerMegabyte;
extern NSUInteger const PMBytesPerMegabyte;
extern NSUInteger const PMBytesPerGigabyte;

extern double const PMMetersPerMile;
extern double const PMMilesPerMeter;

#endif
