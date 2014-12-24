//
//  UITextField+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 12/23/14.
//
//

#import <UIKit/UIKit.h>

@interface UITextField (PMUtils)

- (BOOL) shouldChangeCharactersInRange:(NSRange)range
                     replacementString:(NSString *)string
                              maxChars:(NSUInteger)maxChars;

@end
