//
//  NSNumber+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 3/6/15.
//
//

#import <Foundation/Foundation.h>

@interface NSNumber (PMUtils)

/**
 *  Returns NO if the receiver is equal to [NSNumber numberWithInt:0], otherwise YES.
 *
 *  @return NO if the receiver is equal to [NSNumber numberWithInt:0], otherwise YES
 */
@property (nonatomic, readonly) BOOL isNonZero;

@end
