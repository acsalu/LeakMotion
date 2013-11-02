//
//  LMData.h
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class LMData;

@protocol LMDataDelegate <NSObject>

@optional
- (void)data:(LMData *)data finishedFacebookMeQueryWithFacebookId:(NSString *)facebookId andName:(NSString *)name;

@end


@interface LMData : NSObject

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) UIImage *profilePic;
@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *userName;
@property (weak, nonatomic) id<LMDataDelegate> delegate;
@property (strong, nonatomic) MKMapView *mapView;

+ (LMData *)sharedData;
- (void)facebook;

@end
