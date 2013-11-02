//
//  LMResultViewController.h
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FUIButton;
@class MBProgressHUD;

@interface LMResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet FUIButton *facebookShareButton;
@property (weak, nonatomic) IBOutlet FUIButton *doneButton;
@property (weak, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction)shareToFacebook:(id)sender;
- (IBAction)backToLobby:(id)sender;

@end
