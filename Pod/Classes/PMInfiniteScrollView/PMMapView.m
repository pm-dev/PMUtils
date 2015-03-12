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
//  PMMapView.m
//  Pods
//
//  Created by Peter Meyers on 9/30/14.
//
//

#import "PMMapView.h"
#import "PMInfiniteScrollView.h"

@interface PMMapView () <UIGestureRecognizerDelegate>

@end

@implementation PMMapView
{
    PMInfiniteScrollView *_infiniteScrollView;
    BOOL _delegateImplementsDidDoubleTapToZoom;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self PM_commonPMMapViewInit];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self PM_commonPMMapViewInit];
    }
    return self;
}

- (void) setDelegate:(id<PMMapViewDelegate>)delegate
{
    super.delegate = delegate;
    _infiniteScrollView.delegate = (id<PMInfiniteScrollViewDelegate>)delegate;
    _delegateImplementsDidDoubleTapToZoom = [delegate respondsToSelector:@selector(mapViewDidDoubleTapToZoom:)];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Internal Methods

- (void) PM_didDoubleTapMapView
{
    if (_delegateImplementsDidDoubleTapToZoom) {
        [self.delegate mapViewDidDoubleTapToZoom:self];
    }
}

- (void) PM_commonPMMapViewInit
{
    // Add scroll view's gesture recognizer to self. When the scroll view sends UIScrollViewDelegate methods triggered by those gesture recognizers
    // these methods will be forwarded on to self.delegate.
    _infiniteScrollView = [[PMInfiniteScrollView alloc] initWithFrame:self.bounds];
    _infiniteScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _infiniteScrollView.infiniteDirection = PMDirectionVertical | PMDirectionHorizontal;
    _infiniteScrollView.minimumZoomScale = 0.0;
    _infiniteScrollView.maximumZoomScale = CGFLOAT_MAX;
    _infiniteScrollView.delegate = (id<PMInfiniteScrollViewDelegate>)self.delegate;
    [self addGestureRecognizer:_infiniteScrollView.panGestureRecognizer];
    [self addGestureRecognizer:_infiniteScrollView.pinchGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PM_didDoubleTapMapView)];
    tap.numberOfTapsRequired = 2;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

@end
