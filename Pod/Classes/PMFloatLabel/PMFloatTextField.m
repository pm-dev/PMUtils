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


- (BOOL)textField:(PMFloatTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 && string.length) {
        [self refreshFloatLabelWithText:YES];
    }
    else if (textField.text.length == range.length && string.length == 0) {
        [self refreshFloatLabelWithText:NO];
    }
    if (_delegateRespondsToShouldChangeCharacters) {
        return [_delegateInterceptor.receiver textField:textField
                          shouldChangeCharactersInRange:range
                                      replacementString:string];
    }
    return YES;
}

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
