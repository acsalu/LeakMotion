//
//  LMViewController.h
//  LeakMotion
//
//  Created by Acsa Lu on 10/27/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *compass;


@property (weak, nonatomic) IBOutlet UIButton *animateButton;
@property (nonatomic) BOOL isAnimating;


- (IBAction)toggleAnimation:(UIButton *)sender;
- (IBAction)testServer:(id)sender;

@end
