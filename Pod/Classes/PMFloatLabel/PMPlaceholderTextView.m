//
//  PMPlaceholderTextView.m
//  Pods
//
//  Created by Peter Meyers on 1/9/15.
//
//

#import "PMPlaceholderTextView.h"
#import "PMProtocolInterceptor.h"

@interface PMPlaceholderTextView () <UITextViewDelegate>
@end

@implementation PMPlaceholderTextView
{
    PMProtocolInterceptor *_delegateInterceptor;
    NSMutableDictionary *_textAttributes;
    BOOL _delegateRespondsToDidBeginEditing;
    BOOL _delegateRespondsToDidChangeSelection;
    BOOL _delegateRespondsToShouldChangeTextInRange;
    BOOL _delegateRespondsToDidChange;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self PM_commonPMPlaceholderTextViewInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self PM_commonPMPlaceholderTextViewInit];
    }
    return self;
}

- (void) PM_commonPMPlaceholderTextViewInit
{
    _delegateInterceptor = [PMProtocolInterceptor interceptorWithMiddleMan:self
                                                               forProtocol:@protocol(UITextViewDelegate)];
    _textAttributes = [@{} mutableCopy];
    self.attributedText = self.attributedText;
    self.font = self.font;
    self.textColor = self.textColor;
    self.textAlignment = self.textAlignment;
    self.delegate = self.delegate;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    _delegateRespondsToDidBeginEditing = [delegate respondsToSelector:@selector(textViewDidBeginEditing:)];
    _delegateRespondsToDidChangeSelection = [delegate respondsToSelector:@selector(textViewDidChangeSelection:)];
    _delegateRespondsToShouldChangeTextInRange = [delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)];
    _delegateRespondsToDidChange = [delegate respondsToSelector:@selector(textViewDidChange:)];
    _delegateInterceptor.receiver = delegate;
    super.delegate = (id)_delegateInterceptor;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    super.attributedText = attributedText?: self.attributedPlaceholder;
    if (attributedText.length) {
        _textAttributes = [[attributedText attributesAtIndex:0 effectiveRange:NULL] mutableCopy];
    }
}

- (NSAttributedString *)attributedText
{
    return [super.attributedText isEqualToAttributedString:self.attributedPlaceholder]? nil : super.attributedText;
}

- (void)setText:(NSString *)text
{
    if (text.length) {
        super.attributedText = [[NSAttributedString alloc] initWithString:text attributes:_textAttributes];
    }
    else {
        super.attributedText = _attributedPlaceholder;
    }
}

- (NSString *)text
{
    return [super.text isEqualToString:self.attributedPlaceholder.string]? nil : super.text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    NSMutableParagraphStyle *ps = [_textAttributes[NSParagraphStyleAttributeName] mutableCopy];
    if (ps) {
        ps.alignment = textAlignment;
        _textAttributes[NSParagraphStyleAttributeName] = [ps copy];
    }
    if (self.attributedText.length) {
        super.textAlignment = textAlignment;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (textColor) {
        _textAttributes[NSForegroundColorAttributeName] = textColor;
    }
    else {
        [_textAttributes removeObjectForKey:NSForegroundColorAttributeName];
    }
    if (self.attributedText.length) {
        super.textColor = textColor;
    }
}

- (void)setFont:(UIFont *)font
{
    if (font) {
        _textAttributes[NSFontAttributeName] = font;
    }
    else {
        [_textAttributes removeObjectForKey:NSFontAttributeName];
    }
    if (self.attributedText.length) {
        super.font = font;
    }
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    if (self.attributedText.length == 0) {
        super.attributedText = attributedPlaceholder;
    }
    _attributedPlaceholder = [attributedPlaceholder copy];
}


#pragma mark - UITextViewDelegate Methods


- (void)textViewDidBeginEditing:(PMPlaceholderTextView *)textView
{
    if (textView.attributedText.length == 0 &&
        textView.selectedRange.location != 0) {
        textView.selectedRange = NSMakeRange(0, 0);
    }
    if (_delegateRespondsToDidBeginEditing) {
        [_delegateInterceptor.receiver textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidChangeSelection:(PMPlaceholderTextView *)textView
{
    if (textView.attributedText.length == 0 &&
        textView.selectedRange.location != 0) {
        textView.selectedRange = NSMakeRange(0, 0);
    }
    if (_delegateRespondsToDidChangeSelection) {
        [_delegateInterceptor.receiver textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(PMPlaceholderTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL change = _delegateRespondsToShouldChangeTextInRange? [_delegateInterceptor.receiver textView:textView shouldChangeTextInRange:range replacementText:text] : YES;
    if (change && text.length && textView.attributedText.length == 0) {
        super.attributedText = [[NSAttributedString alloc] initWithString:text attributes:_textAttributes];
        if (_delegateRespondsToDidChange) {
            [_delegateInterceptor.receiver textViewDidChange:textView];
        }
        return NO;
    }
    return change;
}

- (void) textViewDidChange:(PMPlaceholderTextView *)textView
{
    if (textView.attributedText.length == 0) {
        super.attributedText = textView.attributedPlaceholder;
    }
    if (_delegateRespondsToDidChange) {
        [_delegateInterceptor.receiver textViewDidChange:textView];
    }
}

@end
