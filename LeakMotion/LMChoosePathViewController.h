//
//  LMChoosePathViewController.h
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class FUIButton;

@interface LMChoosePathViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet FUIButton *startRunningButton;
@property (strong, nonatomic) UIScrollView *pathsScroll;
@property (strong, nonatomic) NSMutableArray *pathButtonsArray;
@property (strong, nonatomic) NSMutableArray *datasArray;


- (IBAction)showPath:(id)sender;
- (IBAction)backToLobby:(id)sender;
- (IBAction)startRunning:(id)sender;
- (IBAction)draw:(NSArray*) pathCoords with:(float)timeInterval;
- (IBAction)drawRanRouteWith:(CLLocation *)previousLocation and:(CLLocation *)currentLocation;
- (void) buttonPressed: (id)sender;
- (void)animatePathOnMapWith:(CLLocation*) startPoint and:(CLLocation*) endPoint;

@end
