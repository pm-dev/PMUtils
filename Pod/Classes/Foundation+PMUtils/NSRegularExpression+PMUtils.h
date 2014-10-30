//
//  NSRegularExpression+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (PMUtils)


/**
 *  Used to perform substitution for multiple matches on a given input string. The receiver looks for matches on a given input string and replaces the contents of each match
 *  with a string supplied by the 'replacementWithMatch' block.
 *
 *  @param string               The string to search.
 *  @param options              The matching options to report. See “NSMatchingOptions” for the supported values.
 *  @param range                The range of the string to test.
 *  @param templateString       The template string to use when creating each match. Use $0 to see the entire match. See “Flag Options” for the format of template.
 *  @param replacementWithMatch A block that takes a match string as input and returns the string that will replace the match.
 *
 *  @return A replacement string.
 */
- (NSString *)stringByReplacingMatchesInString:(NSString *)string
                                       options:(NSMatchingOptions)options
                                         range:(NSRange)range
                                      template:(NSString *)templateString
                                    withString:(NSString* (^) (NSString* match))replacementWithMatch;

@end
