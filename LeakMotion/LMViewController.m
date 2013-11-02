//
//  LMViewController.m
//  LeakMotion
//
//  Created by Acsa Lu on 10/27/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/AFNetworking.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

NSString *kRotationDirectionClockwise = @"clockwise";
NSString *kRotationDirectionCounterClockwise = @"counterclockwise";

@interface LMViewController ()

@end

@implementation LMViewController

- (IBAction)toggleAnimation:(UIButton *)sender
{
    if (_isAnimating) {
        [sender setTitle:@"Start Animation" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Stop Animation" forState:UIControlStateNormal];
        
        [self.compass.layer addAnimation:[self randomRotationAnimationForDirection:kRotationDirectionClockwise] forKey:@"transform"];
        
        
    }
    
    self.isAnimating = !self.isAnimating;
}

- (IBAction)testServer:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *prams = @{@"map":@"Acsa is very handsome."};
    [manager POST:@"http://leakmotion-dev.herokuapp.com/"
       parameters:prams
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"[response] %@", response);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"[fail %@]", error);
}];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:[self.compass.layer animationForKey:@"transform"]]) {
        NSLog(@"anim finished");
        CABasicAnimation *rotationAnim = (CABasicAnimation *) anim;

        
        self.isAnimating = NO;
        [self.animateButton setTitle:@"Start Animation" forState:UIControlStateNormal];
    }
}

- (CABasicAnimation *)randomRotationAnimationForDirection:(NSString *)direction
{
    double startRotationValue = [[[self.compass.layer presentationLayer] valueForKey:@"transform.rotation.z"] doubleValue];
    
    
    float degreesVariance = arc4random() % 60 + 30;
    CATransform3D zRotationFrom = CATransform3DMakeRotation(startRotationValue, 0, 0, 1.0);
    CATransform3D zRotationTo = CATransform3DMakeRotation(startRotationValue + DEGREES_TO_RADIANS(degreesVariance), 0, 0, 1.0);

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [rotationAnimation setDelegate:self];
    
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:zRotationFrom];
    rotationAnimation.toValue=[NSValue valueWithCATransform3D:zRotationTo];
    
    rotationAnimation.duration = 1.0;
    rotationAnimation.speed = 3.0;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    //        rotationAnimation.repeatCount = 1e100f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    
    if ([direction isEqualToString:kRotationDirectionClockwise]) {
        
    } else {
        
    }
    
    return rotationAnimation;
}


@end
