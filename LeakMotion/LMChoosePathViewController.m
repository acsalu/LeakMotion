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

    
    
    _pathsScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 370, 320, 78)];
    [_pathsScroll setContentSize:CGSizeMake(7 * 70 + 6 * 8, 78)];
    [_pathsScroll setAlwaysBounceVertical:NO];
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
    
    for (int i = 0; i < 7; i++) {
        
        //fake the data Array
        _datasArray[i] = dataArray;
        
        int x = 4 * (i+1) + i * 70;
        int y = 4;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x, y, 70, 70)];
        [button setBackgroundImage:[UIImage imageNamed:fileNamesArray[i]] forState:UIControlStateNormal];
        //[button setValue:dataArray forKey:@"dataArray"];
        [button setTag:i];
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
    
    
    self.mapView = [LMData sharedData].mapView;
    [self.view insertSubview:self.mapView belowSubview:self.dismissButton];
    self.mapView.delegate = self;

    
    //test loc1 and loc2;
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:40.148767 longitude:-102.919922];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:40.076627 longitude:-101.876221];
    [self animatePathOnMapWith:loc1 and:loc2];
    
    
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
    CLLocation *location = locations[0];
    self.currentCoordinate = location.coordinate;
    
    NSLog(@"current location: (%.4f, %.4f)", self.currentCoordinate.latitude, self.currentCoordinate.longitude);
    
    MKCoordinateRegion region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(self.currentCoordinate, 800, 800)];
    
    [self.mapView setRegion:region animated:YES];
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
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(drawRanRouteWith:and:) userInfo:@{@"previousLocation": firstCoord, @"currentLocation": secondCoord}  repeats:YES];
        [timer fire];
    }
    
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


- (void) pathButtonPressed: (UIButton*)sender{
    
    NSInteger index = [sender tag];
    NSArray *dataArray = _datasArray[index];
    [self draw:dataArray with:0.8];
    
    
}

- (void)animatePathOnMapWith:(CLLocation*) startPoint and:(CLLocation*) endPoint{
    
    float dLat = (endPoint.coordinate.latitude - startPoint.coordinate.latitude)/100;
    float dLng = (endPoint.coordinate.longitude - startPoint.coordinate.longitude)/100;
    
    
    for (int i = 0; i < 100; i++) {
        CLLocation *firstLocation = [[CLLocation alloc]initWithLatitude:(startPoint.coordinate.latitude + i * dLat) longitude:(startPoint.coordinate.longitude + i * dLng)];
        CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:(startPoint.coordinate.latitude + (i+1) * dLat) longitude: startPoint.coordinate.longitude + (i+1) * dLng];
        
        double delayInSeconds = 0.007;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self drawRanRouteWith:firstLocation and:secondLocation];
        });
        
        
    }
    
}

@end
