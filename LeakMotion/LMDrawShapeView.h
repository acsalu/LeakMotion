//
//  LMDrawShapeView.h
//  LeakMotion
//
//  Created by Acsa Lu on 10/28/13.
//  Copyright (c) 2013 com.penser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMDrawShapeView : UIView

@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) UIBezierPath *currentPath;

@property (nonatomic, strong) UIColor *strokeColor;

@end
