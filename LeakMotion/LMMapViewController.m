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

@implementation LMMapViewController

- (void)viewDidLoad
{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];
    
    
    
}

# pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    self.currentCoordinate = location.coordinate;
    
    NSLog(@"current location: (%.4f, %.4f)", self.currentCoordinate.latitude, self.currentCoordinate.longitude);
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(24, 120.5);
    MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 800, 800)];
    
    [self.mapView setRegion:region animated:YES];
}



@end
