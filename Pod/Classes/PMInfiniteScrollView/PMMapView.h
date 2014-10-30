//
//  PMMapView.h
//  Pods
//
//  Created by Peter Meyers on 9/30/14.
//
//

#import <MapKit/MapKit.h>

@class PMMapView;
@protocol PMMapViewDelegate <MKMapViewDelegate, UIScrollViewDelegate>

@optional
- (void) mapViewDidDoubleTapToZoom:(PMMapView *)mapView;

@end

@interface PMMapView : MKMapView

@property (nonatomic, weak) id <PMMapViewDelegate> delegate;

@end
