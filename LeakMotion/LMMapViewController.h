//
//  LMMapViewController.h
//  LeakMotion
//
//  Created by Acsa Lu on 10/28/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LMMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;

@end
