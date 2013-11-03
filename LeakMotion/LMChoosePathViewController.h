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
@class LMDrawShapeView;

@interface LMChoosePathViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet FUIButton *startRunningButton;
@property (strong, nonatomic) UIScrollView *pathsScroll;
@property (strong, nonatomic) NSMutableArray *pathButtonsArray;
@property (strong, nonatomic) NSMutableArray *datasArray;
@property (nonatomic) BOOL oneOfTheButtonIsPressed;

//fucking animation on the map
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) CLLocation *startLoc;
@property (nonatomic) CLLocation *endLoc;
@property (nonatomic) NSNumber *globalCounterForAnimationTimer;
@property (nonatomic) float dLat;
@property (nonatomic) float dLon;

//fucking animation on the map 2, by costing a lot of storage...well, not htat much = =
@property (nonatomic) int animationIndex;
@property (strong, nonatomic) NSMutableArray *animationData;



@property (strong, nonatomic) FUIButton *submitButton;
@property (strong, nonatomic) LMDrawShapeView *canvas;

- (IBAction)showPath:(id)sender;
- (IBAction)backToLobby:(id)sender;
- (IBAction)startRunning:(id)sender;
- (IBAction)draw:(NSArray*) pathCoords with:(float)timeInterval;
- (IBAction)drawRanRouteWith:(CLLocation *)previousLocation and:(CLLocation *)currentLocation;
- (IBAction)drawRanRouteWith:(CLLocation *)previousLocation and:(CLLocation *)currentLocation with:(NSNumber*)index;
- (void) buttonPressed: (id)sender;
- (void)animatePathOnMapWith:(CLLocation*) startPoint and:(CLLocation*) endPoint;
- (void) timerFunctionToDrawPath;
- (NSMutableArray*) getAnimationCoordinatesWith:(NSArray*)dataArray;
- (void) timerFunctionWith;
@end
