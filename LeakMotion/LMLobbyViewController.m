//
//  LMLobbyViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMLobbyViewController.h"
#import <AGMedallionView/AGMedallionView.h>

@interface LMLobbyViewController ()

- (void)showProfilePic;

@end

@implementation LMLobbyViewController

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
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view.
    [self showProfilePic];
    
    
}

- (void)showProfilePic
{
    AGMedallionView *medallionView = [[AGMedallionView alloc] init];
    medallionView.image = [UIImage imageNamed:@"profile-pic"];
    medallionView.center = CGPointMake(160, 100);
    [self.view addSubview:medallionView];
}



@end
