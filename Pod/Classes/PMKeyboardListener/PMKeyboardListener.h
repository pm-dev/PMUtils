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

/**
 *  Call this method to start observing changes to the keyboard state.
 */
+ (void) startListening;

/**
 *  Returns the current state of the kayboard.
 *
 *  @return The current state of the keyboard.
 */
+ (PMKeyboardState) keyboardState;

/**
 *  The current frame of the keyboard OR if animating, the frame that
 *  the keyboard is animating to.
 *
 *  @return The keyboard frame.
 */
+ (CGRect) keyboardFrame;

@end
