//
//  NSEntityDescription+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 2/26/15.
//
//

#import "NSEntityDescription+PMUtils.h"
#import "NSString+PMUtils.h"

@implementation NSEntityDescription (PMUtils)

- (NSString *) idAttributeName
{
    // User --> userId
    return [[self.name stringByLowercasingFirstLetter] stringByAppendingString:@"Id"];
}


@end
