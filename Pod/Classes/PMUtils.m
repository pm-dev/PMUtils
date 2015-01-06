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

NSTimeInterval const PMOneSecond = 1;
NSTimeInterval const PMOneMilisecond = (PMOneSecond / 1000);
NSTimeInterval const PMOneMinute = (PMOneSecond * 60);
NSTimeInterval const PMOneHour = (PMOneMinute * 60);
NSTimeInterval const PMOneDay = (PMOneHour * 24);
NSTimeInterval const PMOneWeek = (PMOneDay * 7);

double const PMMetersPerMile = 1609.344;
double const PMMilesPerMeter = 0.000621371192;

NSUInteger const PMBytesPerKilobyte = 1024;
NSUInteger const PMBytesPerMegabyte = 1024 * PMBytesPerKilobyte;
NSUInteger const PMBytesPerGigabyte = 1024 * PMBytesPerMegabyte;

