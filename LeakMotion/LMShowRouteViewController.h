//
//  LMShowRouteViewController.h
//  LeakMotion
//
//  Created by Gammamiaaa on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LMShowRouteViewController : UIViewController
<MKMapViewDelegate,CLLocationManagerDelegate>

@property(weak, nonatomic) MKMapView *mapView;
@property(nonatomic)BOOL willDismiss;
@property(strong, nonatomic) UILabel *AverageSpeedLabel;
@property(strong, nonatomic) UILabel *ranDistanceLabel;
@property(strong, nonatomic) IBOutlet UIButton *startRunButton;


//for drawing ran route.
//update path
@property (strong, nonatomic) CLLocationManager *locationManager;
// the bool to indicate whether is drawing the path to run or the path ran by the user.
@property (nonatomic) BOOL drawRoute;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLLocation *previousLocation;
@property (nonatomic) double startTime;
@property (nonatomic) float totalRanLength;


- (IBAction)zoomIn:(id)sender;
- (IBAction)drawRouteWithJSONArray:(NSArray*)array;
- (IBAction)drawRanRouteWith:(CLLocation*)previousLocation and:(CLLocation*)currentLocation;
- (NSNumber*)getTotalRanLength;
- (void)startRunning:(id)startButton;
- (NSNumber*)getAverageSpeed;

@end
