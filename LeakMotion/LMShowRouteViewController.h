//
//  LMShowRouteViewController.h
//  LeakMotion
//
//  Created by Gammamiaaa on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LMShowRouteViewController : UIViewController
<MKMapViewDelegate>

@property(strong, nonatomic) MKMapView *mapView;
@property(nonatomic)BOOL willDismiss;


- (IBAction)zoomIn:(id)sender;
- (IBAction)drawRouteWithJSONArray:(NSArray*)array;


@end
