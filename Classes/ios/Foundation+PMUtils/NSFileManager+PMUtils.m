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

- (void) removeContentsOfDirectory:(NSString *)path
{
	[self PM_removeContentsOfDirectory:path removingSubdirectories:YES deep:NO];
}

- (void) removeFilesInDirectory:(NSString *)path deep:(BOOL)deep
{
	[self PM_removeContentsOfDirectory:path removingSubdirectories:NO deep:deep];
}

- (NSString *) pathForCachesDirectoryWithName:(NSString *)name attributes:(NSDictionary *)attributes inDirectory:(NSSearchPathDirectory)directory
{
	NSString *basePath = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES).lastObject;
	NSString *path = [basePath stringByAppendingPathComponent:name];
    NSError *error = nil;
    [self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:attributes error:&error];
    NSParameterAssert(!error);
	return path;
}

- (NSURL *) URLForDirectoryWithName:(NSString *)name attributes:(NSDictionary *)attributes inDirectory:(NSSearchPathDirectory)directory
{
    NSURL *baseURL = [self URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
    NSURL *fullURL = [baseURL URLByAppendingPathComponent:name];
    NSError *error = nil;
    [self createDirectoryAtURL:fullURL withIntermediateDirectories:YES attributes:attributes error:&error];
    NSParameterAssert(!error);
    return fullURL;
}

+ (NSString *)xattrStringValueForKey:(NSString *)key atPath:(NSString *)path
{
	NSString *value = nil;
	const char *keyName = key.UTF8String;
	const char *filePath = path.fileSystemRepresentation;
	
	ssize_t bufferSize = getxattr(filePath, keyName, NULL, 0, 0, 0);

	if (bufferSize != -1) {
		char *buffer = malloc(bufferSize+1);
	
		if (buffer) {
			getxattr(filePath, keyName, buffer, bufferSize, 0, 0);
			buffer[bufferSize] = '\0';
			value = [NSString stringWithUTF8String:buffer];
			free(buffer);
		}
	}
	return value;
}

+ (BOOL)setXAttrStringValue:(NSString *)value forKey:(NSString *)key atPath:(NSString *)path
{
	int failed = setxattr(path.UTF8String, key.UTF8String, value.UTF8String, value.length, 0, 0);
	return (failed == 0);
}

+ (BOOL) pathIsDirectory:(NSString *)path
{
    struct stat st;
    int failed = stat(path.UTF8String, &st);
	if (!failed) {
		return S_ISDIR(st.st_mode);
	}
	return NO;
}

#pragma mark - Internal Methods


- (void) PM_removeContentsOfDirectory:(NSString *)path
			   removingSubdirectories:(BOOL)subdirectories
								 deep:(BOOL)deep
{
    NSAssert([NSFileManager pathIsDirectory:path],
			 @"path parameter %@ for -[NSFileManager removeFilesInDirectory:deep:] must be a directory.", path);
    
    NSDirectoryEnumerator *enumerator = [self enumeratorAtPath:path];
    
	if (!deep) {
        [enumerator skipDescendants];
    }
    
    for (NSString *fileName in enumerator) {
						
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
		if (![NSFileManager pathIsDirectory:fullPath] || subdirectories) {
			NSError *error = nil;
			[self removeItemAtPath:fullPath error:&error];
			NSParameterAssert(!error);
		}
    }
}


@end
