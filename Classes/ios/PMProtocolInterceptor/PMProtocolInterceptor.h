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
//  PMProtocolInterceptor.h
//  Created by Peter Meyers on 3/25/14.
//

#import <Foundation/Foundation.h>

/**
 *  PMProtocolInterceptor is a useful class that allows an object acting as a middle man to receive protocol messages,
 *	before those messages are forwarded to another object. An example of where this would be useful is in a subclass
 *	of UIScrollView that needs to recieve some of its scroll view delegate calls. PMProtocolInterceptor prevents the subclass
 *	from needing to forward each individual protocol method to a new delegate of a different name.
 *	Set an instance of this class as a delegate or dataSource to an object.
 */
@interface PMProtocolInterceptor : NSObject

/**
 *  The protocols that are being intercepted. (read-only)
 */
@property (nonatomic, readonly, copy) NSSet * interceptedProtocols;

/**
 *  The object that will receive the protocol methods after middleMan has had a chance to process
 *	the message and forward it on.
 */
@property (nonatomic, weak) id receiver;

/**
 *  The object that will receive protocol messages sent to the interceptor. This object is responsible for 
 *	forwarding the message to receiver.
 */
@property (nonatomic, weak, readonly) id middleMan;

/**
 *  Initializes a protocol interceptor with a middle man and a single protocol.
 *
 *  @param middleMan           The object that will receive protocol messages sent to the interceptor. This object is responsible for
 *	forwarding the message to receiver.
 *  @param interceptedProtocol A protocol specifying the methods the interceptor will attempt to forward to its middleMan.
 *
 *  @return A protocol interceptor.
 */
- (instancetype)initWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol;

/**
 *  Initializes a protocol interceptor with a middle man and a set of protocols.
 *
 *  @param middleMan           The object that will receive protocol messages sent to the interceptor. This object is responsible for
 *	forwarding the message to receiver.
 *  @param interceptedProtocols A set of protocols specifying the methods the interceptor will attempt to forward to its middleMan.
 *
 *  @return A protocol interceptor.
 */
- (instancetype)initWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols;

/**
 *  Returns a protocol interceptor with a middle man and a single protocol.
 *
 *  @param middleMan           The object that will receive protocol messages sent to the interceptor. This object is responsible for
 *	forwarding the message to receiver.
 *  @param interceptedProtocol A protocol specifying the methods the interceptor will attempt to forward to its middleMan.
 *
 *  @return A protocol interceptor.
 */
+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocol:(Protocol *)interceptedProtocol;

/**
 *  Returns a protocol interceptor with a middle man and a set of protocols.
 *
 *  @param middleMan           The object that will receive protocol messages sent to the interceptor. This object is responsible for
 *	forwarding the message to receiver.
 *  @param interceptedProtocols A set of protocols specifying the methods the interceptor will attempt to forward to its middleMan.
 *
 *  @return A protocol interceptor.
 */
+ (instancetype)interceptorWithMiddleMan:(id)middleMan forProtocols:(NSSet *)interceptedProtocols;


@end
