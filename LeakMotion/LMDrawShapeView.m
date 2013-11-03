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
    if ((self = [super initWithFrame:frame])) {
        _strokeColor = [UIColor whiteColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches allObjects][0] locationInView:self];
    //    NSLog(@"touchesBegan at (%.2f, %.2f)", point.x, point.y);
    
    self.currentPath = [UIBezierPath bezierPath];
    self.currentPath.lineWidth = 2.0f;
    [self.currentPath moveToPoint:point];
    [self.paths addObject:self.currentPath];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches allObjects][0] locationInView:self];
    //    NSLog(@"touchesMoved at (%.2f, %.2f)", point.x, point.y);
    
    [self.currentPath addLineToPoint:point];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches allObjects][0] locationInView:self];
    //    NSLog(@"touchesEnded at (%.2f, %.2f)", point.x, point.y);
    [self invalidateIntrinsicContentSize];
}


- (void)drawRect:(CGRect)rect
{
    [_strokeColor set];
    for (UIBezierPath *path in self.paths) [path stroke];
}

# pragma - mark accessor methods

- (NSMutableArray *)paths
{
    // lazy instantiation
    if (!_paths) _paths = [NSMutableArray array];
    return _paths;
}

@end
