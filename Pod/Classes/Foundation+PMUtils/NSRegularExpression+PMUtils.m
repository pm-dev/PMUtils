//
//  NSRegularExpression+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import "NSRegularExpression+PMUtils.h"

@implementation NSRegularExpression (PMUtils)


- (NSString *)stringByReplacingMatchesInString:(NSString *)string
                                       options:(NSMatchingOptions)options
                                         range:(NSRange)range
                                      template:(NSString *)templateString
                                    withString:(NSString * (^) (NSString *match))replacementWithMatch
{
    __block NSMutableString *mutableString = [string mutableCopy];
    __block NSInteger offset = 0;
    
    [self enumerateMatchesInString:string options:options range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange resultRange = result.range;
        resultRange.location += offset;
        NSString *match = [self replacementStringForResult:result inString:mutableString offset:offset template:templateString];
        NSString *replacement = replacementWithMatch(match);
        [mutableString replaceCharactersInRange:resultRange withString:replacement];
        offset += (replacement.length - resultRange.length);
    }];
    
    return [mutableString copy];
}


@end
