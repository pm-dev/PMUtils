//
//  PMPlaceholderTextView.h
//  Pods
//
//  Created by Peter Meyers on 1/9/15.
//
//

#import <UIKit/UIKit.h>

@interface PMPlaceholderTextView : UITextView

/**
 *  The attributed string displayed in the text view when -text and -attributedText has no content.
 */
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;

@end
