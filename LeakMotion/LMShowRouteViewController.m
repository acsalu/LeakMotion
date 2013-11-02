//
//  LMShowRouteViewController.m
//  LeakMotion
//
//  Created by Gammamiaaa on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMShowRouteViewController.h"
#import "FlatUIKit.h"
#import "LMResultViewController.h"
#import "LMData.h"

@interface LMShowRouteViewController ()

- (void)giveUP:(id)sender;
- (void)setRunningInfoControlsHidden:(BOOL)hidden;

@end

@implementation LMShowRouteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSString *dataString = @"[[25.082994755492088, 121.58237814903259], [25.0832571155483, 121.58102631568909], [25.081838421136208, 121.58114433288574], [25.07980752175368, 121.58273220062256], [25.08092500644412, 121.58591866493225], [25.081916158242098, 121.58597230911255], [25.08205219805865, 121.5845239162445], [25.08161492668174, 121.58316135406494]]";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    //NSLog(@"data Array = %@", dataArray);
    [super viewDidLoad];
    
    //test
    //NSLog(@"the previous lat before anything %f", self.previousLocation.coordinate.latitude);
    //NSLog(@"the previous lon before anything %f", self.previousLocation.coordinate.longitude);
    
    //init views
    _mapView = [LMData sharedData].mapView;
    [self.view addSubview:_mapView];
    

    
    
    //turn into NO after drowing route,
    self.drawRoute = YES;
    [self drawRouteWithJSONArray:dataArray];
    
    _mapView.delegate = self;
    [_mapView setNeedsDisplay];
    _mapView.showsUserLocation = YES;

    [self zoomIn:NULL];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];

    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    
    _doneButton = [[FUIButton alloc] initWithFrame:CGRectMake(50, 496, 220, 52)];
    
    _doneButton.buttonColor = [UIColor turquoiseColor];
    _doneButton.shadowColor = [UIColor greenColor];
    _doneButton.shadowHeight = 0.0f;
    _doneButton.cornerRadius = 6.0f;
    _doneButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [_doneButton setTitle:@"Give Up" forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(giveUP:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_doneButton];
    
    
    [self setRunningInfoControlsHidden:YES];
    
    
    
    self.countDownTime = 3;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.willDismiss) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)countDown
{
    if (self.countDownTime == 0) {
        NSLog(@"GO!");
        [self.timer invalidate];
        
        UIImageView *countDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"countdowngo", self.countDownTime]]];
        countDownImageView.center = CGPointMake(160, 270);
        [self.view addSubview:countDownImageView];
        
        countDownImageView.transform = CGAffineTransformMakeScale(3.3, 3.3);
        [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            countDownImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here

            
            double delayInSeconds = 0.6;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [countDownImageView removeFromSuperview];
                [self setRunningInfoControlsHidden:NO];
                [self startRunning];
            });
        }];
        
        
    } else {
        NSLog(@"%d", self.countDownTime);
        UIImageView *countDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"countdown%d", self.countDownTime]]];
        countDownImageView.center = CGPointMake(160, 270);
        [self.view addSubview:countDownImageView];

        countDownImageView.transform = CGAffineTransformMakeScale(3.3, 3.3);
        [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            countDownImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // if you want to do something once the animation finishes, put it here
            [countDownImageView removeFromSuperview];
        }];
        
        --self.countDownTime;

    }
}

- (void)setRunningInfoControlsHidden:(BOOL)hidden
{
    _doneButton.hidden = hidden;
    
    _averageSpeedLabel.hidden = hidden;
    _ranDistanceLabel.hidden = hidden;
    _timerLabel.hidden = hidden;
    
    _averageSpeedIcon.hidden = hidden;
    _ranDistanceIcon.hidden = hidden;
    _timerIcon.hidden = hidden;

}

- (void)startRunning
{
    NSLog(@"start button pressed");
    _startTime = CACurrentMediaTime();
    NSLog(@"start time = %f", _startTime);
    
    
    _startDate = [NSDate date];
    _dateFormatter = [[NSDateFormatter alloc] init];
    
    [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8.0]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/24.0
                                              target:self
                                            selector:@selector(updateTimerLabel)
                                            userInfo:nil repeats:YES];
}

- (void)updateTimerLabel
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:_startDate];
    if (timeInterval >= 60.0f) {
        [_dateFormatter setDateFormat:@"m:ss.SS "];
    } else {
        [_dateFormatter setDateFormat:@"ss.SS "];
    }
    
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *timeString=[_dateFormatter stringFromDate:timerDate];
    _timerLabel.text = timeString;
}




- (IBAction)drawRouteWithJSONArray:(NSArray *)array{
    
    CLLocationCoordinate2D *coords = malloc( ([array count] + 1) * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < [array count]; i++) {
        
        NSNumber *lat = array[i][0];
        NSNumber *lng = array[i][1];
        //NSLog(@" class =%@", [array[0][1] class]);
        CLLocation *coord = [[CLLocation alloc] initWithLatitude: [lat floatValue]  longitude: [lng floatValue]];
        coords[i] = coord.coordinate;
        
    }
    
    //add the first node agian to make it a closed path.
    NSNumber *firstLat = array[0][0];
    NSNumber *firstLng = array[0][1];
    CLLocation *firstCoord = [[CLLocation alloc]initWithLatitude:[firstLat floatValue] longitude:[firstLng floatValue]];
    coords[ [array count] ] = firstCoord.coordinate;
    
    MKPolyline *route = [MKPolyline polylineWithCoordinates:coords count:[array count] + 1];
    [_mapView addOverlay:route];
    
    
}

- (IBAction)drawRanRouteWith:(CLLocation *)previousLocation and:(CLLocation *)currentLocation{
    
    if (previousLocation.coordinate.latitude == 0) return;
    if (previousLocation.coordinate.longitude == 0 ) return;
    if (currentLocation.coordinate.latitude == 0) return;
    if (currentLocation.coordinate.longitude == 0) return;
    CLLocationCoordinate2D *coords = malloc(2 * sizeof(CLLocationCoordinate2D));
    coords[0] = previousLocation.coordinate;
    coords[1] = currentLocation.coordinate;
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:2];
    [_mapView addOverlay:line];

}



-(IBAction)zoomIn:(id)sender{

    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance( [[CLLocation alloc] initWithLatitude:25.057686 longitude:121.614532].coordinate, 1000, 1000);
    [_mapView setRegion:region];
    
}

# pragma mark - mapview delegate method

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if([overlay isKindOfClass:[MKPolyline class]] && self.drawRoute == YES){
        self.drawRoute = NO;
        NSLog( @"is in draw full path" );
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.fillColor = [UIColor blueColor];
        routeRenderer.lineWidth = 6;
        return  routeRenderer;
        
    }
    else if(self.drawRoute == NO){
        
        NSLog(@"in draw ran path");
        MKPolyline *drawRoute = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc]initWithPolyline:drawRoute];
        routeRenderer.strokeColor = [UIColor redColor];
        routeRenderer.fillColor = [UIColor redColor];
        routeRenderer.lineWidth = 4;
        return routeRenderer;
        
    }
    else return nil;
    
}

- (void)giveUP:(id)sender
{
    NSLog(@"give up haha");
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    [self performSegueWithIdentifier:@"ViewResult" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewResult"]) {
        self.willDismiss = YES;
    }
}


# pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"in did Update location");
    
    CLLocation *location = [locations lastObject];
    //[_averageSpeedLabel setText:[NSString stringWithFormat:@"%f", location.coordinate.latitude]];
    
    // if it's the first time to start the run, theres no previous location
    if (self.previousLocation.coordinate.latitude == 0) {
        NSLog(@"in latitude == 0");
        self.previousLocation = location;
        self.previousLocation = location;
    }
    else{
        if( _currentLocation.coordinate.latitude != 0){
            //_previousLocation = _currentLocation;
        }
        _previousLocation = _currentLocation;
        self.currentLocation = location;
        //draw path.
        [self drawRanRouteWith:self.previousLocation and:self.currentLocation];
        //calculate distance and show it.
        [_averageSpeedLabel setText:[NSString stringWithFormat:@"%.2f m/s", self.averageSpeed]];
        //calculate current sum distance
        [_ranDistanceLabel setText:[[self getTotalRanLength] stringValue]];
        
    }
    
    
    
    //NSLog(@"current location: (%.4f, %.4f)", self.currentCoordinate , self.currentCoordinate.longitude);
    //CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(24, 120.5);
    
    //NSString *currentSpeed = [NSString stringWithFormat:@"%f", location.speed];
    
    //MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 800, 800)];
    //[self.mapView setRegion:region animated:YES];
}

- (NSNumber*)getTotalRanLength{

    CLLocationDistance distance = [self.currentLocation distanceFromLocation:self.previousLocation];
    self.totalRanLength = self.totalRanLength + distance;
    return [NSNumber numberWithFloat:self.totalRanLength];

}




- (float)averageSpeed{
    
    float totalTime = CACurrentMediaTime() - _startTime;
    float averageSpeed = [[self getTotalRanLength] floatValue]/ totalTime;
    return averageSpeed;
}

@end
