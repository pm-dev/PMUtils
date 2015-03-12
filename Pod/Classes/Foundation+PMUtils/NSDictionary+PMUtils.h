//
//  NSDictionary+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 10/2/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PMUtils)

/**
 *  A JSON formatted string from the receiver.
 */
@property (nonatomic, copy, readonly) NSString *JSONString;

/**
 *  Returns a new dictionary created by addiing to the receiving dictionary the entries from another dictionary.
 Each value object from dictionary is sent a retain message before being added to the receiving dictionary. In contrast, each key object is copied (using copyWithZone:—keys must conform to the NSCopying protocol), and the copy is added to the receiving dictionary.
 If both dictionaries contain the same key, the receiving dictionary’s previous value object for that key is sent a release message, and the new value object takes its place.
 *
 *  @param dictionary The dictionary from which to add entries
 *
 *  @return A new dictionary created by addiing to the receiving dictionary the entries from another dictionary.
 */
- (NSDictionary *) dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

/**
 *  All keys in the receiver of type NSString are converted to camelCase if they contain underscores.
 *  Keys that are not strings or do not contain underscores are not affected.
 *  e.g. @"this_is_underscored" becomes @"thisIsUnderscored"
 *
 *  @param deep A boolean indicating whether to recursively convert keys when a value happens to be
 *  a dictionary, or if the value is an array, searching for any dictionaries in the array to
 *  recursively convert.
 *
 *  @return A dictionary resulting from the conversion of underscored keys to camel case.
 */
- (NSDictionary *) dictionaryByConvertingUnderscoredStringKeysToCamelCase:(BOOL)deep;

/**
 *  All keys in the receiver of type NSString and formatted in camelCase are converted to underscores.
 *  Keys that are not strings or are not camelCase are not affected.
 *  e.g. @"thisIsCamelCase" becomes @"this_is_camel_case"
 *
 *  @param deep A boolean indicating whether to recursively convert keys when a value happens to be
 *  a dictionary, or if the value is an array, searching for any dictionaries in the array to
 *  recursively convert.
 *
 *  @return A dictionary resulting from the conversion of camel case keys to underscores.
 */
- (NSDictionary *) dictionaryByConvertingCamelCaseStringKeysToUnderscored:(BOOL)deep;

@end
