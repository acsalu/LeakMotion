//
//  LMLocationManager.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMLocationManager.h"

@implementation LMLocationManager

+ (LMLocationManager *)sharedLocationManager
{
    LMLocationManager *locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        locationManager = [[LMLocationManager alloc] init];
//        locationManager.locationManager = [[CLLocationManager alloc] init];
//        locationManager.locationManager.set
    });
    
    return locationManager;
}

@end
