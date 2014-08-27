//
//  NSArray+PMUtils.h
//  Pods
//
//  Created by Peter Meyers on 8/26/14.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (PMUtils)


/**
 *  Compares the receiving array to another array. Two arrays are identical if they each hold the same 
 *  number of objects and objects at a given index in each array have pointer equality.
 *
 *  @param otherArray An array.
 *
 *  @return YES if the contents of otherArray have pointer equality to the contents of the receiving array, otherwise NO.
 */
- (BOOL) isItenticalToArray:(NSArray *)otherArray;

@end
