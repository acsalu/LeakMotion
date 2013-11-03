//
//  LMChoosePathViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMChoosePathViewController.h"
#import "AFNetworking.h"
#import "FlatUIKit.h"
#import <QuartzCore/QuartzCore.h>
#import "LMData.h"

@interface LMChoosePathViewController ()

- (void)fetchPath;



@end

@implementation LMChoosePathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.dismissButton.layer.borderWidth = 1.2f;
    self.dismissButton.layer.cornerRadius = 3;
    self.dismissButton.layer.borderColor = [[UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1.0f] CGColor];

    _pathsScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 405, 320, 78)];
    [_pathsScroll setContentSize:CGSizeMake(7 * 70 + 6 * 8, 78)];
    [_pathsScroll setAlwaysBounceVertical:NO];
    [_pathsScroll setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_pathsScroll];
    
    NSMutableArray *fileNamesArray = [[NSMutableArray alloc]initWithCapacity:7];
    for (int i = 0; i < 7; i++) {
        fileNamesArray[i] = [NSString stringWithFormat:@"path-heart-%i", i+1];
    }
    
    _pathButtonsArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    //test data
    NSString *dataString = @"[[25.082994755492088, 121.58237814903259], [25.0832571155483, 121.58102631568909], [25.081838421136208, 121.58114433288574], [25.07980752175368, 121.58273220062256], [25.08092500644412, 121.58591866493225], [25.081916158242098, 121.58597230911255], [25.08205219805865, 121.5845239162445], [25.08161492668174, 121.58316135406494]]";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    
    NSLog(@"getAnimationCoords %@",[self getAnimationCoordinatesWith:dataArray]);
    NSLog(@"length = %d",[[self getAnimationCoordinatesWith:dataArray] count]);
    
    
    for (int i = 0; i < 7; i++) {
        
        //fake the data Array
        _datasArray[i] = dataArray;
        
        int x = 6 * (i+1) + i * 70;
        int y = 4;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x, y, 70, 70)];
        [button setBackgroundImage:[UIImage imageNamed:fileNamesArray[i]] forState:UIControlStateNormal];
        //[button setValue:dataArray forKey:@"dataArray"];
        [button setTag:i];
        [button addTarget:self action:@selector(pathButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_pathsScroll addSubview:button];
        _pathButtonsArray[i] = button;
    }
    
    //NSLog(@"the button value Array = %@", [(UIButton*)_pathButtonsArray[0] getValue:@"dataArray"]);
    
    
//    self.startRunningButton.layer.backgroundColor = [[UIColor greenColor] CGColor];
//    self.startRunningButton.layer.cornerRadius = 3;

    _startRunningButton.buttonColor = [UIColor turquoiseColor];
    _startRunningButton.shadowColor = [UIColor greenColor];
    _startRunningButton.shadowHeight = 0.0f;
    _startRunningButton.cornerRadius = 6.0f;
    _startRunningButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_startRunningButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_startRunningButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    
    _globalCounterForAnimationTimer = 0;
    //self.mapView = [LMData sharedData].mapView;
    
    [self.view addSubview:[LMData sharedData].mapView];
    [LMData sharedData].mapView.delegate = self;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance( [[CLLocation alloc] initWithLatitude:40.1487 longitude:-102.89].coordinate, 5000, 5000);
    [[[LMData sharedData]mapView] setRegion:region];


    
    
    
    
}

- (void)fetchPath
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *prams = @{@"map":@"Acsa is very handsome."};
    [manager POST:@"http://leakmotion-dev.herokuapp.com/" parameters:prams
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *response = [[NSString alloc] initWithData:responseObject
                                                       encoding:NSUTF8StringEncoding];
            NSLog(@"[response] %@", response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"[fail %@]", error);
    }];
}

#pragma mark - IBActions


- (IBAction)showPath:(id)sender
{
}

- (IBAction)backToLobby:(id)sender
{
    NSLog(@"back to lobby");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startRunning:(id)sender
{
    [self performSegueWithIdentifier:@"StartRunning" sender:self];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    /*
    CLLocation *location = locations[0];
    self.currentCoordinate = location.coordinate;
    
    NSLog(@"current location: (%.4f, %.4f)", self.currentCoordinate.latitude, self.currentCoordinate.longitude);
    
    MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(self.currentCoordinate, 800, 800)];
    
    [self.mapView setRegion:region animated:YES];
     */
     
}


#pragma mark - StoryBoard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.locationManager stopUpdatingLocation];
}

- (void)draw:(NSArray *)pathCoords with:(float)timeInterval {
 
    //timer
    for (int i = 0; i < pathCoords.count; i++) {
        
        NSNumber *firstLat = pathCoords[i][0];
        NSNumber *firstLng = pathCoords[i][1];
        NSNumber *secondLat = pathCoords[i+1][0];
        NSNumber *secondLng = pathCoords[i+1][1];
        
        CLLocation *firstCoord = [[CLLocation alloc]initWithLatitude:[firstLat floatValue] longitude:[firstLng floatValue]];
        CLLocation *secondCoord = [[CLLocation alloc]initWithLatitude:[secondLat floatValue] longitude:[secondLng floatValue]];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(drawRanRouteWith:and:with:) userInfo:@{@"previousLocation": firstCoord, @"currentLocation": secondCoord, @"index":_globalCounterForAnimationTimer}  repeats:YES];
        
        [timer fire];
    }
    
}

//a function that draws on the map with two coordinates
- (IBAction)drawRanRouteWith:(CLLocation *)previousLocation and:(CLLocation *)currentLocation{
    
    if (previousLocation.coordinate.latitude == 0) return;
    if (previousLocation.coordinate.longitude == 0 ) return;
    if (currentLocation.coordinate.latitude == 0) return;
    if (currentLocation.coordinate.longitude == 0) return;
    CLLocationCoordinate2D *coords = malloc(2 * sizeof(CLLocationCoordinate2D));
    coords[0] = previousLocation.coordinate;
    coords[1] = currentLocation.coordinate;
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:2];
    [[[LMData sharedData]mapView] addOverlay:line];
    
}


//continuous call
- (IBAction)drawRanRouteWith:(CLLocation *)previousLocation and:(CLLocation *)currentLocation with:(NSNumber*)index{
    
    int idx = [index integerValue];
    
    if (previousLocation.coordinate.latitude == 0) return;
    if (previousLocation.coordinate.longitude == 0 ) return;
    if (currentLocation.coordinate.latitude == 0) return;
    if (currentLocation.coordinate.longitude == 0) return;
    
    float dLat = (currentLocation.coordinate.latitude - previousLocation.coordinate.latitude)/100;
    float dLng = (currentLocation.coordinate.longitude - previousLocation.coordinate.longitude)/100;
    
    CLLocationCoordinate2D *coords = malloc(2 * sizeof(CLLocationCoordinate2D));
    CLLocation *firstLocation = [[CLLocation alloc]initWithLatitude:(previousLocation.coordinate.latitude + idx * dLat) longitude:(previousLocation.coordinate.longitude + idx * dLng)];
    CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:(previousLocation.coordinate.latitude + (idx+1) * dLat) longitude: previousLocation.coordinate.longitude + (idx+1) * dLng];
    
    coords[0] = firstLocation.coordinate;
    coords[1] = secondLocation.coordinate;
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:2];
    [[[LMData sharedData]mapView] addOverlay:line];
    
    if ([_globalCounterForAnimationTimer isEqualToNumber:@99]) {
        [_timer invalidate];
        _globalCounterForAnimationTimer = 0;
    }
}


- (void) pathButtonPressed: (UIButton*)sender{
    
    /*
    NSArray *edges = _datasArray[sender.tag];
    
    //NSInteger index = [sender tag];
    //NSArray *dataArray = _datasArray[index];
    //[self draw:dataArray with:0.8];
    //test loc1 and loc2;
    CLLocation *loc1 = [[CLLogitcation alloc] initWithLatitude:40.148767 longitude:-102.919922];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:40.076627 longitude:-101.876221];
    //[self animatePathOnMapWith:loc1 and:loc2];
    
    _startLoc = loc1;
    _dLat = (loc2.coordinate.latitude - loc1.coordinate.latitude)/100;
    _dLon = (loc2.coordinate.longitude - loc1.coordinate.longitude)/100;
    NSLog(@"_dLat = %f", _dLat);
    NSLog(@"_dLon = %f", _dLon);
    _endLoc = [[CLLocation alloc] initWithLatitude:(loc1.coordinate.latitude + _dLat) longitude:(loc1.coordinate.longitude + _dLon)];
    _globalCounterForAnimationTimer = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFunctionToDrawPath) userInfo:Nil repeats:YES];
    */
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(25.081176, 121.583244);
    MKCoordinateRegion adjustRegion = [[[LMData sharedData]mapView] regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 590, 590)];
    [[[LMData sharedData] mapView] setRegion:adjustRegion animated:YES];
    
    NSString *dataString = @"[[25.082994755492088, 121.58237814903259], [25.0832571155483, 121.58102631568909], [25.081838421136208, 121.58114433288574], [25.07980752175368, 121.58273220062256], [25.08092500644412, 121.58591866493225], [25.081916158242098, 121.58597230911255], [25.08205219805865, 121.5845239162445], [25.08161492668174, 121.58316135406494]]";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    _animationData = [self getAnimationCoordinatesWith:dataArray];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFunctionWith) userInfo:@{@"animationData": _animationData} repeats:YES];
    
}

- (NSMutableArray*) getAnimationCoordinatesWith:(NSArray*)dataArray{

    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [dataArray count]; ++i) {
     
        NSNumber *startLat = dataArray[i][0];
        NSNumber *startLng = dataArray[i][1];
        NSNumber *endLat;
        NSNumber *endLng;
        if( i != [dataArray count]-1){
            endLat = dataArray[i+1][0];
            endLng = dataArray[i+1][1];
        }
        else{
            endLat = dataArray[0][0];
            endLng = dataArray[0][1];
        }
        
        float dLat = ([endLat floatValue] - [startLat floatValue])/35;
        float dLng = ([endLng floatValue] - [startLng floatValue])/35;
        [array addObject:@[startLat, startLng]];
        
        for (int j = 0; j < 35; j++) {
            //NSNumber *tempStartLat = [NSNumber numberWithFloat:([startLat floatValue] + dLat * j)];
            //NSNumber *tempStartLng = [NSNumber numberWithFloat:([startLng floatValue] + dLng * j)];
            NSNumber *tempEndLat = [NSNumber numberWithFloat:([startLat floatValue] + dLat * (j+1))];
            NSNumber *tempEndLng = [NSNumber numberWithFloat:([startLng floatValue] + dLng * (j+1))];
            [array addObject:@[tempEndLat, tempEndLng]];
        }
    }
    return array;
}

- (void) timerFunctionWith{

    NSLog(@"in timer Function with");
    
    float lat1 = [_animationData[_animationIndex][0] floatValue];
    float lng1 = [_animationData[_animationIndex][1] floatValue];
    float lat2 = [_animationData[_animationIndex+1][0] floatValue];
    float lng2 = [_animationData[_animationIndex+1][1] floatValue];
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    //draw
    [self drawRanRouteWith:loc1 and:loc2];
    //update
    if(_animationIndex != [_animationData count]-2)
        _animationIndex++;
    else{
        [_timer invalidate];
    }
    //
    
}

- (void) timerFunctionToDrawPath{
    
    NSLog(@"start = %@", _startLoc);
    NSLog(@"end = %@", _endLoc);
    
    [self drawRanRouteWith:_startLoc and:_endLoc];
    _startLoc = _endLoc;
    _endLoc = [[CLLocation alloc] initWithLatitude:(_endLoc.coordinate.latitude + _dLat) longitude:(_endLoc.coordinate.longitude + _dLon)];
    _globalCounterForAnimationTimer = [NSNumber numberWithInt:[_globalCounterForAnimationTimer integerValue] + 1];
    NSLog(@"counter = %d",[_globalCounterForAnimationTimer integerValue]);
    
    if([_globalCounterForAnimationTimer isEqualToNumber:@(99)]){
        
        NSLog(@"in 99");
        [_timer invalidate];
        
    }
    
    //update index
    
}

- (void) animatePathOnMapWith:(CLLocation*) startPoint and:(CLLocation*) endPoint{
    
    
    NSLog(@"in animatePath on map");
    float dLat = (endPoint.coordinate.latitude - startPoint.coordinate.latitude)/100;
    float dLng = (endPoint.coordinate.longitude - startPoint.coordinate.longitude)/100;
    //CLLocation *firstLocation = [[CLLocation alloc]initWithLatitude:(startPoint.coordinate.latitude + i * dLat) longitude:(startPoint.coordinate.longitude + i * dLng)];
    //CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:(startPoint.coordinate.latitude + (i+1) * dLat) longitude: startPoint.coordinate.longitude + (i+1) * dLng];
    //_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawRanRouteWith:and:with:) userInfo:@{@"previousLocation": startPoint, @"currentLocation": endPoint, @"index": _globalCounterForAnimationTimer} repeats:YES];
    
    for (int i = 0; i < 100; i++) {
        CLLocation *firstLocation = [[CLLocation alloc]initWithLatitude:(startPoint.coordinate.latitude + i * dLat) longitude:(startPoint.coordinate.longitude + i * dLng)];
        CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:(startPoint.coordinate.latitude + (i+1) * dLat) longitude: startPoint.coordinate.longitude + (i+1) * dLng];
     
        /*
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self drawRanRouteWith:firstLocation and:secondLocation];
        });
        */
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
            //[self drawRanRouteWith:firstLocation and:secondLocation];
            
        //});
        
    }
    
}

#pragma mark - mapview delegate method

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if([overlay isKindOfClass:[MKPolyline class]]){
        NSLog( @"is in draw full path" );
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:0.65];
        routeRenderer.fillColor = [UIColor blueColor];
        routeRenderer.lineWidth = 6;
        return  routeRenderer;
        
    }
    else return nil;
    
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers{
  
    
    
}

@end
