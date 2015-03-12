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
//  PMFloatLabel.m
//  Pods
//
//  Created by Peter Meyers on 1/9/15.
//
//

#import "PMFloatTextField.h"
#import "PMProtocolInterceptor.h"

@interface PMFloatTextField () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *floatingLabel;
@end

@implementation PMFloatTextField
{
    PMProtocolInterceptor *_delegateInterceptor;
    CGFloat _verticalSpacing;
    BOOL _hasContent;
    BOOL _delegateRespondsToShouldChangeCharacters;
    BOOL _delegateRespondsToDidBeginEditing;
    BOOL _delegateRespondsToDidEndEditing;
    BOOL _delegateRespondsToAttributedTextForEditing;
    BOOL _delegateRespondsToVerticalSpacing;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self PM_commonPMFloatLabelInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self PM_commonPMFloatLabelInit];
    }
    return self;
}

- (void) PM_commonPMFloatLabelInit
{
    _delegateInterceptor = [PMProtocolInterceptor interceptorWithMiddleMan:self
                                                               forProtocol:@protocol(UITextFieldDelegate)];
    [self setDelegate:self.delegate];
    self.floatingLabel = [[UILabel alloc] init];
    self.floatingLabel.alpha = 0.0f;
    [self addTarget:self action:@selector(editingDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.floatingLabel];
    self.clipsToBounds = NO;
}

- (void)setDelegate:(id<PMFloatTextFieldDelegate>)delegate
{
    _delegateRespondsToShouldChangeCharacters = [delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)];
    _delegateRespondsToDidBeginEditing = [delegate respondsToSelector:@selector(textFieldDidBeginEditing:)];
    _delegateRespondsToDidEndEditing = [delegate respondsToSelector:@selector(textFieldDidEndEditing:)];
    _delegateRespondsToAttributedTextForEditing = [delegate respondsToSelector:@selector(floatTextField:floatLabelAttributedString:)];
    _delegateRespondsToVerticalSpacing = [delegate respondsToSelector:@selector(floatTextField:floatLabelVerticalSpacing:)];
    _delegateInterceptor.receiver = delegate;
    super.delegate = delegate? (id)_delegateInterceptor : nil;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshFloatLabelWithText:text.length];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self refreshFloatLabelWithText:attributedText.length];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.floatingLabel sizeToFit];
    CGFloat lineHeight = [self.font lineHeight];
    CGFloat textYOrigin = floorf((self.bounds.size.height - lineHeight) / 2.0f);
    CGRect frame = self.floatingLabel.frame;
    switch (self.textAlignment) {
        case NSTextAlignmentRight:
            frame.origin.x = self.bounds.size.width - frame.size.width;
            break;
        case NSTextAlignmentCenter:
            frame.origin.x = floorf((self.bounds.size.width - frame.size.width) / 2.0f);
            break;
        case NSTextAlignmentLeft:
        case NSTextAlignmentJustified:
        case NSTextAlignmentNatural:
            frame.origin.x = 0.0f;
            break;
    }
    frame.origin.y = textYOrigin - _verticalSpacing - frame.size.height;
    self.floatingLabel.frame = frame;
}


#pragma mark - UITextFieldDelegate Methods


- (void)textFieldDidBeginEditing:(PMFloatTextField *)textField
{
    [self refreshFloatLabelWithText:self.text.length];
    if (_delegateRespondsToDidBeginEditing) {
        [_delegateInterceptor.receiver textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(PMFloatTextField *)textField
{
    [self refreshFloatLabelWithText:self.text.length];
    if (_delegateRespondsToDidEndEditing) {
        [_delegateInterceptor.receiver textFieldDidEndEditing:textField];
    }
}

- (void) editingDidChange:(PMFloatTextField *)textField
{
    if ((textField.text.length > 0) != _hasContent) {
        _hasContent = !_hasContent;
        [self refreshFloatLabelWithText:_hasContent];
    }
}


#pragma mark - Internal Methods


- (void) refreshFloatLabelWithText:(BOOL)text
{
    BOOL showWithInput = [self.delegate floatTextField:self shouldShowFloatLabelWithText:text editing:self.isEditing];
    
    if (showWithInput) {
        if (_delegateRespondsToVerticalSpacing) {
            _verticalSpacing = [self.delegate floatTextField:self floatLabelVerticalSpacing:self.isEditing];
        }
        if (_delegateRespondsToAttributedTextForEditing) {
            self.floatingLabel.attributedText = [self.delegate floatTextField:self floatLabelAttributedString:self.isEditing];
        }
        else {
            self.floatingLabel.text = self.attributedPlaceholder.string?: self.placeholder;
        }
        
        if (self.floatingLabel.alpha != 1.0f) {
            [self setNeedsLayout];
            [self layoutIfNeeded]; // Make sure floatLabel has the correct frame.
            self.floatingLabel.transform = CGAffineTransformMakeTranslation(0.0, self.floatingLabel.frame.size.height/3.0f);
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.floatingLabel.transform = CGAffineTransformIdentity;
                                 self.floatingLabel.alpha = 1.0f;
                             } completion:nil];
        }
    }
    else {
        if (self.floatingLabel.alpha != 0.0f) {
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.floatingLabel.alpha = 0.0f;
                             } completion:nil];
        }
    }
}

@end
