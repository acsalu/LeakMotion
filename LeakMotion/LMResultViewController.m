//
//  LMResultViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMResultViewController.h"
#import "LMFakeLobby.h"
#import "FlatUIKit.h"
#import "LMData.h"
#import <Social/Social.h>
#import "LMData.h"
#import "MBProgressHUD.h"

@interface LMResultViewController ()

@end

@implementation LMResultViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
        self.view.backgroundColor = [LMData redColor];
	
    _mapView = [LMData sharedData].mapView;
    _mapView.showsUserLocation = NO;
    [_mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
    [self.view addSubview:_mapView];

    
    _facebookShareButton.buttonColor = [UIColor colorWithRed:47.0/255 green:93.0/255 blue:150.0/255 alpha:1.0f];
    _facebookShareButton.shadowColor = [UIColor greenColor];
    _facebookShareButton.shadowHeight = 0.0f;
    _facebookShareButton.cornerRadius = 6.0f;
    _facebookShareButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_facebookShareButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_facebookShareButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    _doneButton.buttonColor = [LMData transparentWhiteColor];
    _doneButton.shadowColor = [UIColor greenColor];
    _doneButton.shadowHeight = 0.0f;
    _doneButton.cornerRadius = 6.0f;
    _doneButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    
}



- (IBAction)shareToFacebook:(id)sender
{
    NSLog(@"Share to Facebook");
    if ([LMData sharedData].accountStore) {
        NSDictionary *parameters = @{@"message": @"Y!Hack", ACFacebookAppIdKey: @"232104906954589"};
        SLRequest *facebookRequest =
        [SLRequest requestForServiceType:SLServiceTypeFacebook
                           requestMethod:SLRequestMethodPOST
                        URL:[NSURL URLWithString:@"https://graph.facebook.com/me/photos"]
                              parameters:parameters];
        
        UIGraphicsBeginImageContextWithOptions(self.mapView.frame.size, NO, 0.0);
        [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
        NSData *data = UIImagePNGRepresentation(image);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.labelText = @"Sharing";
        
        [facebookRequest addMultipartData:data
                                 withName:@"media"
                                     type:@"multipart/form-data"
                                 filename:@"leakmotion.jpg"];
        facebookRequest.account = [LMData sharedData].facebookAccount;
        
        [facebookRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            __block UIImageView *imageView;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageNamed:@"checkmark.png"];
                imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Completed";
                sleep(0.5);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            
            
            if (!error) {
                NSLog(@"Post successful!");

            } else {
                
            }
        }];
        
    } else {
        NSLog(@"No Facebook yet.");
    }

    
}

- (IBAction)backToLobby:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    LMFakeLobby *fakeLobby = (LMFakeLobby*)segue.destinationViewController;
    
    
}



@end
