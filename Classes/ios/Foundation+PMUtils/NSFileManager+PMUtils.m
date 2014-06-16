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
//  NSFileManager+PMUtils.m
//  Created by Peter Meyers on 3/1/14.
//
//

#import "NSFileManager+PMUtils.h"
#import <sys/xattr.h>
#import <sys/stat.h>

@implementation NSFileManager (PMUtils)

- (NSDate *)fileModificationDateForPath:(NSString *)path
{
	NSDictionary	*attrs			= [self attributesOfItemAtPath:path error:NULL];
	NSDate			*modDate		= [attrs fileModificationDate];
	
	return modDate;
}

- (NSString *)xattrStringValueForKey:(NSString *)key atPath:(NSString *)path
{
	size_t					size			= 0;
	char					*str			= NULL;
	NSString				*string			= nil;
    
	size = getxattr([path UTF8String], [key UTF8String], NULL, 0, 0, 0);
	if (size != -1)
	{
		str = malloc(size + 1);
		if (str)
		{
			getxattr([path UTF8String], [key UTF8String], str, size, 0, 0);
			str[size] = '\0';
			
			string = [NSString stringWithUTF8String:str];
			
			free(str);
		}
	}
	
	return string;
}

- (void)setXAttrStringValue:(NSString *)value forKey:(NSString *)key atPath:(NSString *)path
{
	setxattr([path UTF8String], [key UTF8String], [value UTF8String], [value length], 0, 0);
}


- (void)shallowRemoveAllFilesInDirectory:(NSString *)path
{
	NSDirectoryEnumerator	*enumerator		= [self enumeratorAtPath:path];
	
	for (NSString *file in enumerator)
	{
		NSString *fullPath		= [path stringByAppendingPathComponent:file];
		struct stat st;
		
		if (stat([fullPath UTF8String], &st) == 0)
		{
			if (!(st.st_mode & S_IFDIR))
				unlink([fullPath UTF8String]);
		}
	}
}

+ (NSString *) pathForCreatedCachesDirectoryWithName:(NSString *)name
{
    NSFileManager *fileManager = [self defaultManager];
	NSString *basePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
	NSString *path = [basePath stringByAppendingPathComponent:name];
    NSError *error = nil;
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    NSParameterAssert(!error);
	return path;
}

+ (NSURL *) URLForCreatedCachesDirectoryWithName:(NSString *)name
{
    NSFileManager *fileManager = [self defaultManager];
    NSURL *baseURL = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].lastObject;
    NSURL *fullURL = [baseURL URLByAppendingPathComponent:name];
    NSError *error = nil;
    [fileManager createDirectoryAtURL:fullURL withIntermediateDirectories:YES attributes:nil error:&error];
    NSParameterAssert(!error);
    return fullURL;
}



@end
