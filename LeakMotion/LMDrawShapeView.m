//
//  LMDrawShapeView.m
//  LeakMotion
//
//  Created by Acsa Lu on 10/28/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import "LMDrawShapeView.h"

@implementation LMDrawShapeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.path = [NSMutableArray arrayWithCapacity:100];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.path addObject:[NSValue valueWithCGPoint:touchPoint]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.path addObject:[NSValue valueWithCGPoint:touchPoint]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.path addObject:[NSValue valueWithCGPoint:touchPoint]];
    NSLog(@"%@", self.path);
    
}



@end
