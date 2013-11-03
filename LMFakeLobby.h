//
//  LMLobbyViewController.h
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMData.h"

@class AGMedallionView;
@class FUIButton;

@interface LMFakeLobby : UIViewController<LMDataDelegate>

@property (weak, nonatomic) IBOutlet FUIButton *pickPathButton;
@property (strong, nonatomic) AGMedallionView *medallionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *mapDemoView;

@property (nonatomic) int currentDemoIndex;
@property (strong, nonatomic) NSTimer *timer;

@end
