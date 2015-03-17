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
//  PMPlaceholderTextView.m
//  Pods
//
//  Created by Peter Meyers on 1/9/15.
//
//

#import "PMPlaceholderTextView.h"
#import "PMProtocolInterceptor.h"

@interface PMPlaceholderTextView () <UITextViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *textAttributes;
@end

@implementation PMPlaceholderTextView
{
    PMProtocolInterceptor *_delegateInterceptor;
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
    self.attributedText = self.attributedText;
    self.font = self.font?: self.textAttributes[NSFontAttributeName];
    self.textColor = self.textColor?: self.textAttributes[NSForegroundColorAttributeName];
    NSMutableParagraphStyle *ps = self.textAttributes[NSParagraphStyleAttributeName];
    self.textAlignment = self.textAlignment?: ps.alignment;
    self.delegate = self.delegate;
}

- (NSMutableDictionary *)textAttributes
{
    if (!_textAttributes) {
        _textAttributes = [@{} mutableCopy];
    }
    return _textAttributes;
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
        self.textAttributes = [[attributedText attributesAtIndex:0 effectiveRange:NULL] mutableCopy];
    }
}

- (NSAttributedString *)attributedText
{
    return [super.attributedText isEqualToAttributedString:self.attributedPlaceholder]? nil : super.attributedText;
}

- (void)setText:(NSString *)text
{
    if (text.length) {
        super.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.textAttributes];
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
    NSMutableParagraphStyle *ps = [self.textAttributes[NSParagraphStyleAttributeName] mutableCopy];
    if (ps) {
        ps.alignment = textAlignment;
        self.textAttributes[NSParagraphStyleAttributeName] = [ps copy];
    }
    if (self.attributedText.length) {
        super.textAlignment = textAlignment;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (textColor) {
        self.textAttributes[NSForegroundColorAttributeName] = textColor;
    }
    else {
        [self.textAttributes removeObjectForKey:NSForegroundColorAttributeName];
    }
    if (self.attributedText.length) {
        super.textColor = textColor;
    }
}

- (void)setFont:(UIFont *)font
{
    if (font) {
        self.textAttributes[NSFontAttributeName] = font;
    }
    else {
        [self.textAttributes removeObjectForKey:NSFontAttributeName];
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
    static BOOL isSetting = NO;
    if (!isSetting) {
        BOOL change = _delegateRespondsToShouldChangeTextInRange? [_delegateInterceptor.receiver textView:textView shouldChangeTextInRange:range replacementText:text] : YES;
        if (change && text.length && textView.attributedText.length == 0) {
            isSetting = YES;
            super.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.textAttributes];
            isSetting = NO;
            if (_delegateRespondsToDidChange) {
                [_delegateInterceptor.receiver textViewDidChange:textView];
            }
            return NO;
        }
        return change;
    }
    return NO;
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
