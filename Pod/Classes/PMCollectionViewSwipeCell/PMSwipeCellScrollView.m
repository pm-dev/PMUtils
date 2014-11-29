//
//  PMSwipeCellScrollView.m
//  Pods
//
//  Created by Peter Meyers on 11/28/14.
//
//

#import "PMSwipeCellScrollView.h"

@implementation PMSwipeCellScrollView


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSwipeCellScrollViewInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonSwipeCellScrollViewInit];
}

- (void) commonSwipeCellScrollViewInit
{
    self.showsHorizontalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.scrollEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging){
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
    else {
        [super touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [self.nextResponder touchesEnded: touches withEvent:event];
    }
    else {
        [super touchesEnded: touches withEvent: event];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        CGPoint translation = [self.panGestureRecognizer translationInView:self.panGestureRecognizer.view];
        return fabsf(translation.y) <= fabsf(translation.x);
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}
/*
 * If the user is actively scrolling the collection view,
 * don't allow this scroll view's gesture recognizer to trigger.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:gestureRecognizer.view];
        return fabsf(velocity.y) <= 0.25f;
    }
    return YES;
}


@end
