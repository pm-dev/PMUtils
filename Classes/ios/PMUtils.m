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
//  PMUtils.m
//  Created by Peter Meyers on 4/24/14.
//
//

#import "PMUtils.h"

NSTimeInterval const PMOneHour = (60*60);
NSTimeInterval const PMOneDay = (PMOneHour*24);
NSTimeInterval const PMOneWeek = (PMOneDay*7);
NSUInteger const PMBytesPerMegabyte = 1024 * 1024;


NSInteger PMShortestCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange)
{
    NSInteger forwardDistance = PMForwardCircularDistance(fromIndex, toIndex, inRange);
    NSInteger reverseDistance = PMReverseCircularDistance(fromIndex, toIndex, inRange);
    
    if (ABS(reverseDistance) < forwardDistance) {
        return reverseDistance;
    }
    
    return forwardDistance;
}

NSInteger PMReverseCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange)
{
    return -PMForwardCircularDistance(toIndex, fromIndex, inRange);
}

NSInteger PMForwardCircularDistance(NSInteger fromIndex, NSInteger toIndex, NSRange inRange)
{
    fromIndex -= inRange.location;
    toIndex -= inRange.location;
    
    if (fromIndex < 0 || fromIndex >= inRange.length) {
        @throw([NSException exceptionWithName:@"Index Out Of Bounds" reason:[NSString stringWithFormat:@"fromIndex %@, is out of Bounds", [NSNumber numberWithInteger:fromIndex]] userInfo:nil]);
    }
    else if (toIndex < 0 || toIndex >= inRange.length) {
       @throw([NSException exceptionWithName:@"Index Out Of Bounds" reason:[NSString stringWithFormat:@"toIndex %@, is out of Bounds", [NSNumber numberWithInteger:toIndex]] userInfo:nil]);
    }
    
    if (toIndex >= fromIndex) {
        return toIndex - fromIndex;
    }
    else {
        return inRange.length - fromIndex + toIndex;
    }
}
