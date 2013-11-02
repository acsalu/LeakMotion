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

@interface LMLobbyViewController : UIViewController<LMDataDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pickPathButton;
@property (strong, nonatomic) AGMedallionView *medallionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end
