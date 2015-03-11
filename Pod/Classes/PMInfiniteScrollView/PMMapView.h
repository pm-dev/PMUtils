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

/**
 *  Tells the delegate that the user zoomed in a map view by double tapping.
 *
 *  @param mapView The map view that was zoomed.
 */
- (void) mapViewDidDoubleTapToZoom:(PMMapView *)mapView;

@end

@interface PMMapView : MKMapView

/**
 *  PMMapView is useful because this delegate not only recieves 
 *  MKMapViewDelegate but UIScrollViewDelegate calls as well. The object that acts
 *  as the delegate of the map view. The delegate must adopt the PMMapViewDelegate protocol.
 *  The map view field maintains a weak reference to the delegate object.
 *
 */
@property (nonatomic, weak) id <PMMapViewDelegate> delegate;

@end
