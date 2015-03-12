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
//  UIImageView+PM.h
//  Created by Peter Meyers on 5/20/14.
//

#import <UIKit/UIKit.h>

/**
 *	The `UIImageViewDelegate` protocol defines the method used by UIImageView's delegate.
 */
@protocol UIImageViewDelegate <NSObject>


/**
 *  Obtains a UIImage instance using the supplied imageEntity. If successBlock is nil, the method sets the image property on imageView, otherwise
 *	the UIImage is passed to the successBlock.
 *
 *  @param imageView The image view whose image entity was just set.
 *  @param imageEntity The object that was just set on the image view.
 *  @param successBlock A block to do additional processing after a UIImage is successfully obtained by the UIImageViewDelegate using the image entity.
 *  @param failureBlock A block that handles an NSError if a UIImage is not successfully obtained by the UIImageViewDelegate using the image entity.
 *	@see -[UIImageView setImageEntity:]
 */
- (void) setImageView:(UIImageView *)imageView
       imageForEntity:(id)imageEntity
              success:(void (^)(UIImage *image))successBlock
              failure:(void (^)(NSError *error))failureBlock;

@end


@interface UIImageView (PMUtils)

/**
 *  Using the content mode of the reciever, this property computes the frame of the reciever's rendered 
 *  image within its bounds.
 */
@property (nonatomic, readonly) CGRect imageFrame;

/**
 *  @param delegate The object that acts as the delegate of the UIImageView class.
 */
+ (void) setDelegate:(id<UIImageViewDelegate>)delegate;

/**
 *  @return The object that was set asacts as the delegate of the UIImageView class using +[UIImageView setDelegate:]
 */
+ (id<UIImageViewDelegate>)delegate;

/**
 *	Use this method to send an object of any type to the receiver. This object is then sent to the delegate of UIImageView,
 *	which uses the image entity to generate a UIImage that is assigned to the image property of the reciever.
 *
 *  @param imageEntity An object that the UIImageView delegate will use to generate the receivers image.
 *	@see -[UIImageView setImageEntity:success:failure]
 */
- (void) setImageEntity:(id)imageEntity;

/**
 *	Use this method to send an object of any type to the receiver. This object is then sent to the delegate of UIImageView,
 *	which uses the image entity to generate a UIImage. That UIImage is then passed to the success parameter which you can 
 *	optionally process then set as the recievers image.
 *
 *  @param imageEntity An object that the UIImageView delegate will use to generate the receivers image.
 *	@param success A block that is called upon successful UIImage generation from the imageEntity by the UIImageView delegate.
 *	@param failure A block that is called if the UIImageView delegate is unable to generate a UIImage from the supplied image entity.
 */
- (void) setImageEntity:(id)imageEntity
                success:(void (^)(UIImage *image))success
                failure:(void (^)(NSError *error))failure;
@end





