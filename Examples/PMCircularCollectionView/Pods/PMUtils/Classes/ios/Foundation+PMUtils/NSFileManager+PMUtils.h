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
//  NSFileManager+PMUtils.h
//  Created by Peter Meyers on 3/1/14.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager (PMUtils)


/**
 *  This method returns the date that a file’s data was last modified.
 *
 *  @param path The path of a file or directory.
 *
 *  @return Returns the value for the key NSFileModificationDate, or nil if the item attributes at path doesn’t have an entry for the key.
 */
- (NSDate *)modificationDateForFileAtURL:(NSURL *)URL;


/**
 *  Enumerates through the directory at a path and removes each item which is not a directory. 
 *  This method does not resolve symbolic links encountered in the traversal process, nor does it recurse through them if they point to a directory.
 *
 *  @param path A path string indicating the directory whose files you wish to remove.
 *
 *  @param deep If YES, this method will recurse into subdirectories.
 */
- (void) removeFilesInDirectory:(NSURL *)URL deep:(BOOL)deep;


/**
 *  Enumerates through the directory at a path and removes each item.
 *  This method does not resolve symbolic links encountered in the traversal process, nor does it recurse through them if they point to a directory.
 *
 *  @param path A path string indicating the directory whose files you wish to remove.
 *
 */
- (void) removeContentsOfDirectory:(NSURL *)URL;


/**
 *  Get an extended attribute value string value associated with a file or directory in the system. Extended attributes extend the
 *  basic attributes of files and directories in the file system.  They are stored as name:data pairs associated with file 
 *	system objects (files, directories, symlinks, etc). Typical uses of xattributes include storing the author of a document,
 *	the character encoding of a plain-text document, or a checksum, cryptographic hash or digital signature.
 *
 *  @param key The name of the extended attribute.
 *
 *	@return path The filesystem location to attribute value with.
 */
+ (NSString *)xattrStringValueForKey:(NSString *)key atURL:(NSURL *)URL;


/**
 *  Set an extended attribute string value associated with a file or directory in the system. Extended attributes extend the
 *  basic attributes of files and directories in the file system.  They are stored as name:data pairs associated with file
 *	system objects (files, directories, symlinks, etc). Typical uses of xattributes include storing the author of a document, 
 *	the character encoding of a plain-text document, or a checksum, cryptographic hash or digital signature.
 *
 *  @param value A string to be associated with the extended attribute.
 *
 *  @param key The name of the extended attribute.
 *
 *	@param path The filesystem location to attribute value with.
 *
 *	@return YES if setting the attribute was successful, otherwise NO.
 */
+ (BOOL)setXAttrStringValue:(NSString *)value forKey:(NSString *)key atURL:(NSURL *)URL;


/**
 *  Finds a directory inside a search path directory, creating it if it doesn't exist. If you specify nil for the attributes parameter,
 *	this method uses a default set of values for the owner, group, and permissions of any newly created directories in the path. Similarly,
 *	if you omit a specific attribute, the default value is used. 
 *
 *  @param name A name string identifying the directory. If name contains a path relative to the search path's directory,
 *	intermediate directories will be created if necessary.
 *
 *  @param attributes The file attributes for the new directory and any newly created intermediate directories. You can set the owner and group numbers,
 *	file permissions, and modification date. If you specify nil for this parameter or omit a particular value, one or more default values are used as
 *	described in the discussion. For a list of keys you can include in this dictionary, see “Constants” section lists the global constants used as keys in
 *	the attributes dictionary. Some of the keys, such as NSFileHFSCreatorCode and NSFileHFSTypeCode, do not apply to directories.
 *
 *	@param directory The search path directory. The supported values are described in NSSearchPathDirectory.
 *
 *	@return A URL identifying the directory.
 */
- (NSURL *) URLForDirectoryWithName:(NSString *)name attributes:(NSDictionary *)attributes inDirectory:(NSSearchPathDirectory)directory;


/**
 *  Determines if there is a directory at a path
 *
 *  @param path The path of a directory. Must not be nil.
 *
 *  @return YES if a directory exists at path, otherwise NO.
 */
- (BOOL) URLIsDirectory:(NSURL *)URL;

@end
