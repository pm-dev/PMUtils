//
//  UITableViewCell+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 11/12/14.
//
//

#import "UITableViewCell+PMUtils.h"

@implementation UITableViewCell (PMUtils)

+ (NSString *)defaultReuseIdentifier
{
    return NSStringFromClass(self);
}

@end
