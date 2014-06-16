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

#import "NSDictionary+PMUtils.h"
#import "NSManagedObject+PMUtils.h"
#import "NSThread+PMUtils.h"
#import "NSIndexPath+PMUtils.h"
#import "NSFileManager+PMUtils.h"
#import "NSString+PMUtils.h"
#import "NSData+PMUtils.h"

#import "UIImage+PMUtils.h"
#import "UIColor+PMUtils.h"
#import "UIDevice+PMUtils.h"
#import "UIScreen+PMUtils.h"
#import "UITableView+PMUtils.h"
#import "UICollectionView+PMUtils.h"
#import "UIScrollView+PMUtils.h"
#import "UICollectionViewFlowLayout+PMUtils.h"
#import "UICollectionReusableView+PMUtils.h"
#import "UIView+PMUtils.h"
#import "UIImageView+PMUtils.h"

#import "PMOrderedDictionary.h"
#import "PMProtocolInterceptor.h"
#import "PMPair.h"
#import "PMImageFilmstrip.h"
#import "PMAnimationQueue.h"

#if DEBUG
#define DLog(args...)   NSLog(args)
#else
#define DLog(args...)
#endif

#define DEF_weakSelf    __weak __typeof(self) weakSelf = self;

extern NSTimeInterval const PMOneHour;
extern NSTimeInterval const PMOneDay;
extern NSTimeInterval const PMOneWeek;
extern NSUInteger const PMBytesPerMegabyte;

extern NSInteger PMShortestCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange);
extern NSInteger PMReverseCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange);
extern NSInteger PMForwardCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange);

#endif
