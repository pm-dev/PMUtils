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
//  UIImageView+PM.m
//  Created by Peter Meyers on 5/20/14.
//

#import "UIImageView+PMUtils.h"
#import <objc/runtime.h>

@implementation UIImageView (PMUtils)

- (CGRect)imageFrame
{
    if (self.image) {
        
        CGFloat extraWidth = self.bounds.size.width - self.image.size.width;
        CGFloat extraHeight = self.bounds.size.height - self.image.size.height;
        
        switch (self.contentMode) {
                
            case UIViewContentModeRedraw:
            case UIViewContentModeScaleToFill:
                return self.bounds;
                
            case UIViewContentModeCenter:
                return CGRectMake(extraWidth/2.0f, extraHeight/2.0f, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeTop:
                return CGRectMake(extraWidth/2.0f, 0.0f, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeBottom:
                return CGRectMake(extraWidth/2.0f, extraHeight, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeLeft:
                return CGRectMake(0.0f, extraHeight/2.0f, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeRight:
                return CGRectMake(extraWidth, extraHeight/2.0f, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeTopLeft:
                return CGRectMake(0.0f, 0.0f, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeTopRight:
                return CGRectMake(extraWidth, 0.0f, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeBottomLeft:
                return CGRectMake(0.0f, extraHeight, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeBottomRight:
                return CGRectMake(extraWidth, extraHeight, self.image.size.width, self.image.size.height);
                
            case UIViewContentModeScaleAspectFill:
            {
                CGFloat imageRatio = self.image.size.width / self.image.size.height;
                CGFloat viewRatio = self.bounds.size.width / self.bounds.size.height;
                
                if (imageRatio < viewRatio) { // Fill to width
                    
                    CGFloat scale = self.bounds.size.width / self.image.size.width;
                    CGFloat height = scale * self.image.size.height;
                    CGFloat y = (self.bounds.size.height - height) / 2.0f;
                    return CGRectMake(0.0f, y, self.bounds.size.width, height);
                }
                else if (imageRatio > viewRatio) { // Fill to height
                    
                    CGFloat scale = self.bounds.size.height / self.image.size.height;
                    CGFloat width = scale * self.image.size.width;
                    CGFloat x = (self.bounds.size.width - width) / 2.0f;
                    return CGRectMake(x, 0.0f, width, self.bounds.size.height);
                }
                return self.bounds;
            }
            case UIViewContentModeScaleAspectFit:
            {
                CGFloat imageRatio = self.image.size.width / self.image.size.height;
                CGFloat viewRatio = self.bounds.size.width / self.bounds.size.height;
                
                if (imageRatio < viewRatio) { // Fit to height
                    
                    CGFloat scale = self.bounds.size.height / self.image.size.height;
                    CGFloat width = scale * self.image.size.width;
                    CGFloat x = (self.bounds.size.width - width) / 2.0f;
                    return CGRectMake(x, 0.0f, width, self.bounds.size.height);
                }
                else if (imageRatio > viewRatio) { // Fit to width
                    
                    CGFloat scale = self.bounds.size.width / self.image.size.width;
                    CGFloat height = scale * self.image.size.height;
                    CGFloat y = (self.bounds.size.height - height) / 2.0f;
                    return CGRectMake(0.0f, y, self.bounds.size.width, height);
                }
                return self.bounds;
            }
        }
    }
    return CGRectZero;
}

- (void) setImageEntity:(id)imageEntity
{
    [self setImageEntity:imageEntity success:nil failure:nil];
}

- (void) setImageEntity:(id)imageEntity
                success:(void (^)(UIImage *image))success
                failure:(void (^)(NSError *error))failure;
{
    id<UIImageViewDelegate> delegate = [UIImageView delegate];
    NSParameterAssert(delegate);
    [delegate setImageView:self imageForEntity:imageEntity success:success failure:failure];
}

+ (void) setDelegate:(id<UIImageViewDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id<UIImageViewDelegate>)delegate
{
    return (id<UIImageViewDelegate>)objc_getAssociatedObject(self, @selector(delegate));
}

@end
