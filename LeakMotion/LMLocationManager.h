//
//  LMLocationManager.h
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LMLocationManager : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;

+ (CLLocationManager *)sharedLocationManager;

@end
