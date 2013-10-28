//
//  LMViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 10/27/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LMViewController ()

@end

@implementation LMViewController

- (IBAction)toggleAnimation:(UIButton *)sender
{
    if (_isAnimating) {
        
        [sender setTitle:@"Start Animation" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Stop Animation" forState:UIControlStateNormal];
    }
    
    self.isAnimating = !self.isAnimating;

}
@end
