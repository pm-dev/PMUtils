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
    BOOL _delegateRespondsToShouldChangeCharacters;
    BOOL _delegateRespondsToDidBeginEditing;
    BOOL _delegateRespondsToDidEndEditing;
    BOOL _delegateRespondsToAttributedTextForEditing;
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
    _delegateRespondsToAttributedTextForEditing = [delegate respondsToSelector:@selector(floatTextField:attributesForEditingFloatLabel:)];
    _delegateInterceptor.receiver = delegate;
    super.delegate = (id)_delegateInterceptor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.floatingLabel sizeToFit];
    CGRect frame = self.floatingLabel.frame;
    frame.origin.y = -frame.size.height;
    self.floatingLabel.frame = frame;
}


#pragma mark - UITextFieldDelegate Methods


- (BOOL)textField:(PMFloatTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 && string.length) {
        [self showFloatingLabel];
    }
    else if (textField.text.length == range.length && string.length == 0) {
        [self hideFloatingLabel];
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
    if (_delegateRespondsToAttributedTextForEditing) {
        NSDictionary *attributes = [self.delegate floatTextField:textField attributesForEditingFloatLabel:YES];
        NSString *string = (self.attributedPlaceholder.string?: self.placeholder);
        self.floatingLabel.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                            attributes:attributes];
    }
    else {
        self.floatingLabel.text = self.attributedPlaceholder.string?: self.placeholder;
    }
    if (_delegateRespondsToDidBeginEditing) {
        [_delegateInterceptor.receiver textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(PMFloatTextField *)textField
{
    if (_delegateRespondsToAttributedTextForEditing) {
        NSDictionary *attributes = [self.delegate floatTextField:textField attributesForEditingFloatLabel:NO];
        NSString *string = (self.attributedPlaceholder.string?: self.placeholder);
        self.floatingLabel.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                            attributes:attributes];
    }
    else {
        self.floatingLabel.text = self.attributedPlaceholder.string?: self.placeholder;
    }
    if (_delegateRespondsToDidEndEditing) {
        [_delegateInterceptor.receiver textFieldDidEndEditing:textField];
    }
}


#pragma mark - Internal Methods


- (void) showFloatingLabel
{
    if (self.floatingLabel.text.length || self.floatingLabel.attributedText.length) {
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

- (void) hideFloatingLabel
{
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.floatingLabel.alpha = 0.0f;
                     } completion:nil];
}

@end
