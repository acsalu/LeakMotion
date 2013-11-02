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

@class FUIButton;

@interface LMShowRouteViewController : UIViewController
<MKMapViewDelegate,CLLocationManagerDelegate>

@property(weak, nonatomic) MKMapView *mapView;
@property(nonatomic)BOOL willDismiss;
@property (weak, nonatomic) IBOutlet UILabel *averageSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *ranDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *averageSpeedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ranDistanceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *timerIcon;


//for drawing ran route.
//update path
@property (strong, nonatomic) CLLocationManager *locationManager;
// the bool to indicate whether is drawing the path to run or the path ran by the user.
@property (nonatomic) BOOL drawRoute;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLLocation *previousLocation;
@property (nonatomic) double startTime;
@property (nonatomic) float totalRanLength;


@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int countDownTime;


@property (strong, nonatomic) FUIButton *doneButton;



@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *startDate;

@property (readonly) float averageSpeed;

- (IBAction)zoomIn:(id)sender;
- (IBAction)drawRouteWithJSONArray:(NSArray*)array;
- (IBAction)drawRanRouteWith:(CLLocation*)previousLocation and:(CLLocation*)currentLocation;
- (NSString *)totalRanLengthString;
- (void)startRunning;
- (NSNumber*)getAverageSpeed;

@end
