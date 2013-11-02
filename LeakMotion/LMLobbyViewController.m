//
//  LMLobbyViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMLobbyViewController.h"
#import <AGMedallionView/AGMedallionView.h>
#import "LMData.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface LMLobbyViewController ()

- (void)showProfilePic;

@end

@implementation LMLobbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
    
    [LMData sharedData].delegate = self;
    [[LMData sharedData] facebook];
//    [self showProfilePic];
    
    _pickPathButton.layer.cornerRadius = 3;
    _pickPathButton.layer.backgroundColor = [[UIColor blackColor] CGColor];
    

    
}

- (void)showProfilePic
{
    AGMedallionView *medallionView = [[AGMedallionView alloc] init];
    medallionView.image = [LMData sharedData].profilePic;
    medallionView.center = CGPointMake(160, 100);
    [self.view addSubview:medallionView];
}

#pragma mark - LMDataDelegate methods

- (void)data:(LMData *)data finishedFacebookMeQueryWithFacebookId:(NSString *)facebookId
{
//    _medallionView = [[AGMedallionView alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", facebookId]];
    [_profileImageView setImageWithURL:url];
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.cornerRadius = 50;
    
    
    
    
    
    
//    _medallionView.image =  self.profileImageView.image;
//    _medallionView.center = CGPointMake(160, 100);
//    [self.view addSubview:_medallionView];
}

@end
