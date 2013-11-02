//
//  LMResultViewController.h
//  LeakMotion
//
//  Created by Acsa Lu on 11/2/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FUIButton;

@interface LMResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet FUIButton *facebookShareButton;
@property (weak, nonatomic) IBOutlet FUIButton *doneButton;

- (IBAction)shareToFacebook:(id)sender;
- (IBAction)backToLobby:(id)sender;

@end
