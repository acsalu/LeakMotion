//
//  LMShowRouteViewController.m
//  LeakMotion
//
//  Created by Gammamiaaa on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMShowRouteViewController.h"

@interface LMShowRouteViewController ()

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
    NSLog(@"data Array = %@", dataArray);
    [super viewDidLoad];
    
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_mapView];
    
    
    [self drawRouteWithJSONArray:dataArray];
    
    _mapView.delegate = self;
    [_mapView setNeedsDisplay];
    _mapView.showsUserLocation = YES;
    [self zoomIn:NULL];
	// Do any additional setup after loading the view.
}

- (IBAction)drawRouteWithJSONArray:(NSArray *)array{
    
    CLLocationCoordinate2D *coords = malloc( ([array count] + 1) * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < [array count]; i++) {
        
        NSNumber *lat = array[i][0];
        NSNumber *lng = array[i][1];
        NSLog(@" class =%@", [array[0][1] class]);
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)zoomIn:(id)sender{
    
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance( [[CLLocation alloc] initWithLatitude:25.082994 longitude:121.5823781].coordinate, 20000, 20000);
    [_mapView setRegion:region];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if([overlay isKindOfClass:[MKPolyline class]]){
        NSLog( @"is king of Class MKPolyline" );
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.fillColor = [UIColor blueColor];
        routeRenderer.lineWidth = 6;
        return  routeRenderer;
        
    }
    
    else return nil;
    
}


@end
