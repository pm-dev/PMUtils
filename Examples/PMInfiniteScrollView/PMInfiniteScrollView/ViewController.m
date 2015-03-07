//
//  ViewController.m
//  PMInfiniteScrollView
//
//  Created by Peter Meyers on 3/7/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMMapView.h"

@interface ViewController () <PMMapViewDelegate>
@property (weak, nonatomic) IBOutlet PMMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)mapViewDidDoubleTapToZoom:(PMMapView *)mapView {
    NSLog(@"Did double tap to zoom");
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Did Scroll");
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"Did Zoom");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"Did begin dragging");
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"Will end dragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"Did end dragging");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"Will begin decelerating");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"Did end decelerating");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"Did end scrolling");
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"Will begin zooming");
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"Did end zooming");
}



@end
