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

- (NSDate *)modificationDateForFileAtPath:(NSString *)path
{
    NSError *error = nil;
	NSDictionary *attrs = [self attributesOfItemAtPath:path error:&error];
    NSParameterAssert(!error);
	NSDate *modDate = [attrs fileModificationDate];
	return modDate;
}



- (void) removeFilesInDirectory:(NSString *)path deep:(BOOL)deep
{
    NSAssert([NSFileManager pathIsDirectory:path], @"path parameter for -[NSFileManager removeFilesInDirectory:deep:] must be a directory.");
    
    NSDirectoryEnumerator *enumerator = [self enumeratorAtPath:path];
    if (!deep) {
        [enumerator skipDescendants];
    }
    
    for (NSString *fileName in enumerator) {
        NSString *fullPath = [path stringByAppendingString:fileName];
        if ([NSFileManager pathIsDirectory:fullPath] == NO) {
            NSError *error = nil;
            [self removeItemAtPath:fullPath error:&error];
            NSParameterAssert(!error);
        }
    }
}

- (void) removeContentsOfDirectory:(NSString *)path
{
    NSAssert([NSFileManager pathIsDirectory:path], @"path parameter for -[NSFileManager removeContentsOfDirectory:] must be a directory.");
    
    NSError *error = nil;
    NSArray *fileNames = [self contentsOfDirectoryAtPath:path error:&error];
    NSParameterAssert(!error);
    
    for (NSString *fileName in fileNames)  {
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        [self removeItemAtPath:fullPath error:&error];
        NSParameterAssert(!error);
    }
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

+ (BOOL) pathIsDirectory:(NSString *)path
{
    struct stat st;
    int failed = stat(path.UTF8String, &st);
    NSParameterAssert(!failed);
    return (st.st_mode & S_IFDIR);
}



@end
