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
 *  Returns a JSON formatted string from the receiver.
 *
 *  @return JSON string form of the reciever, or nil if an internal error occurs.
 */
- (NSString *) JSONString;

@end
