//
//  NSObject+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 8/13/14.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (PMUtils)

/**
 *  Use this method to verify an object is of a specific type.
 *
 *  @param aClass The class to check against.
 *
 *  @return Returns self if self is an instance of aClass. Otherwise nil.
 */
- (instancetype) ifKindOfClass:(Class)aClass;

@end
