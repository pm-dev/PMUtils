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
//  UIDevice+PMUtils.m
//  Created by Peter Meyers on 3/1/14.
//
//

#import "UIDevice+PMUtils.h"
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <sys/mount.h>

@implementation UIDevice (PMUtils)

- (BOOL) isPad
{
    return self.userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

- (BOOL) isPhone
{
    return self.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (int)hardwareCores
{
    unsigned int numberOfCores = 0;
	size_t len = sizeof(numberOfCores);
    sysctlbyname("hw.ncpu", &numberOfCores, &len, NULL, 0);
    return numberOfCores;
}

+ (size_t)hardwareRam
{
	int mib[] = { CTL_HW, HW_PHYSMEM };
	size_t mem;
	size_t len = sizeof(mem);
	sysctl(mib, 2, &mem, &len, NULL, 0);
	return mem;
}

+ (NSString *) machine
{
    struct utsname systemInfo;
    if ( !uname(&systemInfo) ) {
        NSString *model = [NSString stringWithUTF8String:systemInfo.machine];
        return model;
    }	
	return @"";
}

+ (uint64_t)availableBytes
{
	struct statfs sfs;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	if ( !statfs(path.UTF8String, &sfs)) {
		uint64_t availableBytes = sfs.f_bsize * sfs.f_bavail;
		return availableBytes;
	}
	return 0;
}


@end
