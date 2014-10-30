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
