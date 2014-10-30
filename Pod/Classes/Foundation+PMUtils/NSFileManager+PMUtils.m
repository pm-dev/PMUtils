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


- (NSDate *)modificationDateForFileAtURL:(NSURL *)URL;
{
    NSError *error = nil;
	NSDictionary *attrs = [self attributesOfItemAtPath:URL.path error:&error];
    NSParameterAssert(!error);
	NSDate *modDate = [attrs fileModificationDate];
	return modDate;
}

- (void) removeContentsOfDirectory:(NSURL *)URL
{
	[self PM_removeContentsOfDirectory:URL removingSubdirectories:YES deep:NO];
}

- (void) removeFilesInDirectory:(NSURL *)URL deep:(BOOL)deep
{
	[self PM_removeContentsOfDirectory:URL removingSubdirectories:NO deep:deep];
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

+ (NSString *)xattrStringValueForKey:(NSString *)key atURL:(NSURL *)URL
{
	NSString *value = nil;
	const char *keyName = key.UTF8String;
	const char *filePath = URL.fileSystemRepresentation;
	
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

+ (BOOL)setXAttrStringValue:(NSString *)value forKey:(NSString *)key atURL:(NSURL *)URL
{
	int failed = setxattr(URL.fileSystemRepresentation, key.UTF8String, value.UTF8String, value.length, 0, 0);
	return (failed == 0);
}

- (BOOL) URLIsDirectory:(NSURL *)URL
{
	NSParameterAssert(URL);
    NSError *error = nil;
	NSDictionary *attrs = [self attributesOfItemAtPath:URL.path error:&error];
    NSParameterAssert(!error);
    return [[attrs fileType] isEqualToString:NSFileTypeDirectory];
}

#pragma mark - Internal Methods

- (void) PM_removeContentsOfDirectory:(NSURL *)URL
			   removingSubdirectories:(BOOL)subdirectories
								 deep:(BOOL)deep
{
    NSDirectoryEnumerator *enumerator = [self enumeratorAtURL:URL
                                   includingPropertiesForKeys:@[NSURLIsDirectoryKey]
                                                      options:deep? 0 : NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                 errorHandler:nil];
    for (NSURL *item in enumerator) {
        if (subdirectories || ![self URLIsDirectory:item]) {
            NSError *error = nil;
            [self removeItemAtURL:item error:&error];
            NSParameterAssert(!error);
        }
    }
}

@end
