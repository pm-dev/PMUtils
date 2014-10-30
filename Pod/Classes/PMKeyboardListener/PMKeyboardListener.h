//
//  PMKeyboardListener.h
//  Pods
//
//  Created by Peter Meyers on 10/21/14.
//
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, PMKeyboardState)
{
    PMKeyboardStateHidden,
    PMKeyboardStateAppearing,
    PMKeyboardStateVisible,
    PMKeyboardStateDisappearing
};

@interface PMKeyboardListener : NSObject

+ (PMKeyboardState) keyboardState;
+ (CGRect) keyboardFrame;

@end
