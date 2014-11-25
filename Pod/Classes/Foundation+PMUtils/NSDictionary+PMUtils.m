//
//  NSDictionary+PMUtils.m
//  Pods
//
//  Created by Peter Meyers on 10/2/14.
//
//

#import "NSDictionary+PMUtils.h"

@implementation NSDictionary (PMUtils)

- (NSString *) JSONString
{
    if (self.count) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSAssert(!error, @"Error serializing dictionary %@. Error: %@", self, error);
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"{}";
}

- (NSDictionary *) dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mutableSelf = [NSMutableDictionary dictionaryWithDictionary:self];
    [mutableSelf addEntriesFromDictionary:dictionary];
    return [mutableSelf copy];
}

@end
