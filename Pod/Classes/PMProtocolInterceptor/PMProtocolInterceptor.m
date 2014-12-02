// Copyright (c) 2013-2014 Peter Meyers
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  PMProtocolInterceptor.m
//  Created by Peter Meyers on 3/25/14.
//
//

#import  <objc/runtime.h>
#import "PMProtocolInterceptor.h"

static inline BOOL selector_belongsToProtocol(SEL selector, Protocol * protocol)
{
    // Reference: https://gist.github.com/numist/3838169
    for (int optionbits = 0; optionbits < (1 << 2); optionbits++) {
        BOOL required = optionbits & 1;
        BOOL instance = !(optionbits & (1 << 1));
        
        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, required, instance);
        if (hasMethod.name || hasMethod.types) {
            return YES;
        }
    }
    return NO;
}

@implementation PMProtocolInterceptor


- (instancetype)initWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol
{
    self = [super init];
    if (self) {
        _interceptedProtocols = [NSSet setWithObject:interceptedProtocol];
        _middleMan = middleMan;
    }
    return self;
}

- (instancetype)initWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols
{
    self = [super init];
    if (self) {
        _interceptedProtocols = [interceptedProtocols copy];
        _middleMan = middleMan;
    }
    return self;
}

+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol
{
    return [[self alloc] initWithMiddleMan:middleMan forProtocol:interceptedProtocol];
}

+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols
{
    return [[self alloc] initWithMiddleMan:middleMan forProtocols:interceptedProtocols];
}

- (void) setReceiver:(id)receiver
{
    if ([receiver isKindOfClass:[PMProtocolInterceptor class]]) {
        NSLog(@"Caution! Setting a PMProtocolInterceptor as another PMProtocolInterceptor's receiver can be unpredictable.");
    }
    _receiver = receiver;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self PM_isSelectorContainedInInterceptedProtocols:aSelector]) {
        return self.middleMan;
    }
    if ([self.receiver respondsToSelector:aSelector]) {
        return self.receiver;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector] &&
        [self PM_isSelectorContainedInInterceptedProtocols:aSelector]) {
        return YES;
    }
    if ([self.receiver respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}

#pragma mark - Private Methods

- (BOOL)PM_isSelectorContainedInInterceptedProtocols:(SEL)aSelector
{
    __block BOOL isSelectorContainedInInterceptedProtocols = NO;
    
    [self.interceptedProtocols enumerateObjectsUsingBlock:^(Protocol * protocol, BOOL *stop) {
        isSelectorContainedInInterceptedProtocols = selector_belongsToProtocol(aSelector, protocol);
        *stop = isSelectorContainedInInterceptedProtocols;
    }];
    return isSelectorContainedInInterceptedProtocols;
}

@end
