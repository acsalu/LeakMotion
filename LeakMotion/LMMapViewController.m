//
//  LMMapViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 10/28/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface LMMapViewController ()


@end

@implementation LMMapViewController {
    GMSMapView *mapView_;
}

- (void)loadView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
}

@end
