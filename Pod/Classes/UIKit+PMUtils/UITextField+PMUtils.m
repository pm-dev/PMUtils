//
//  UITextField+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 12/23/14.
//
//

#import "UITextField+PMUtils.h"

@implementation UITextField (PMUtils)

- (BOOL) shouldChangeCharactersInRange:(NSRange)range
                     replacementString:(NSString *)string
                              maxChars:(NSUInteger)maxChars
{
    NSString *newString = [self.text stringByReplacingCharactersInRange:range withString:string];
    return (newString.length <= maxChars);
}

@end
