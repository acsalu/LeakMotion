//
//  LMChoosePathViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMChoosePathViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <FlatUIKit/FlatUIKit.h>
#import <QuartzCore/QuartzCore.h>

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


- (IBAction)showPath:(id)sender {
}

- (IBAction)backToLobby:(id)sender
{
    NSLog(@"back to lobby");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
