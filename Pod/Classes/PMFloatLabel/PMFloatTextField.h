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

@optional
- (NSDictionary *) floatTextField:(PMFloatTextField *)floatTextField
     attributesForEditingFloatLabel:(BOOL)editing;

@end


@interface PMFloatTextField : UITextField

@property(nonatomic, weak) id<PMFloatTextFieldDelegate> delegate;

@end
