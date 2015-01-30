//
//  PMFloatLabel.h
//  Pods
//
//  Created by Peter Meyers on 1/9/15.
//
//

#import <UIKit/UIKit.h>

@class PMFloatTextField;
@protocol PMFloatTextFieldDelegate <UITextFieldDelegate>

- (BOOL) floatTextField:(PMFloatTextField *)floatTextField shouldShowFloatLabelWithText:(BOOL)isText editing:(BOOL)isEditing;

@optional

- (CGFloat) floatTextField:(PMFloatTextField *)floatTextField floatLabelVerticalSpacing:(BOOL)isEditing;
- (NSAttributedString *) floatTextField:(PMFloatTextField *)floatTextField floatLabelAttributedString:(BOOL)isEditing;

@end


@interface PMFloatTextField : UITextField

@property(nonatomic, weak) id<PMFloatTextFieldDelegate> delegate;

@end
