//
//  LMLobbyViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMFakeLobby.h"
#import <AGMedallionView/AGMedallionView.h>
#import "LMData.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "FlatUIKit.h"

@interface LMFakeLobby ()

- (void)showProfilePic;
- (void)presentMapDemo;

@end

@implementation LMFakeLobby

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
    
    _pickPathButton.buttonColor = [LMData transparentWhiteColor];
    _pickPathButton.shadowColor = [UIColor greenColor];
    _pickPathButton.shadowHeight = 0.0f;
    _pickPathButton.cornerRadius = 6.0f;
    _pickPathButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_pickPathButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_pickPathButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.profileView.bounds];
    //    self.profileView.layer.masksToBounds = NO;
    //    self.profileView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    self.profileView.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    //    self.profileView.layer.shadowOpacity = 0.1f;
    //    self.profileView.layer.shadowPath = shadowPath.CGPath;
    
    self.view.backgroundColor = [LMData redColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [LMData sharedData].delegate = self;
    [[LMData sharedData] facebook];
    [self showProfilePic];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(presentMapDemo) userInfo:nil repeats:YES];
}

- (void)presentMapDemo
{
    UIImage *toImage = [UIImage imageNamed:[NSString stringWithFormat:@"map-demo-%d", (self.currentDemoIndex++) % 7]];
    [UIView transitionWithView:self.view
                      duration:0.25f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.mapDemoView.image = toImage;
                    } completion:nil];
    _mapDemoView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mapDemoView.layer.shadowOffset = CGSizeMake(2, 2);
    _mapDemoView.layer.shadowOpacity = .7;
    _mapDemoView.layer.shadowRadius = 3.0;
    _mapDemoView.clipsToBounds = NO;
}

- (void)showProfilePic
{
    AGMedallionView *medallionView = [[AGMedallionView alloc] init];
    medallionView.image = [UIImage imageNamed:@"profile-pic"];
    medallionView.center = CGPointMake(85, 113);
    medallionView.frame = CGRectMake(medallionView.frame.origin.x, medallionView.frame.origin.y, 110, 110);
    [self.view addSubview:medallionView];
}

#pragma mark - LMDataDelegate methods

- (void)data:(LMData *)data finishedFacebookMeQueryWithFacebookId:(NSString *)facebookId andName:(NSString *)name
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.timer invalidate];
}
@end
