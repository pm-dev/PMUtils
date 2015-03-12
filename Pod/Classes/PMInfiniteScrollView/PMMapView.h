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
////  PMMapView.h
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
