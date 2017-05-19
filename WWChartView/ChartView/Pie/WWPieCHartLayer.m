//
//  WWPieCHartLayer.m
//  Pie
//
//  Created by ww on 16/6/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "WWPieCHartLayer.h"

@implementation WWPieCHartLayer
- (void)strokeBoard:(CAShapeLayer*)shapLayer{
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = @0.0;
    strokeAnimation.toValue = @1.0;
    strokeAnimation.duration = .5;
    strokeAnimation.fillMode = kCAFillModeForwards;
    
    [shapLayer addAnimation:strokeAnimation forKey:nil];
    
}

- (void)addArcAnimationForKeypath:(NSString *)keyPath
                        fromValue:(CGFloat)fromValue
                          toValue:(CGFloat)toValue
                         duration:(CGFloat)duration
                         delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.delegate = delegate;
    animation.fillMode = kCAFillModeForwards;
//    animation.autoreverses = NO;
    [self addAnimation:animation forKey:keyPath];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
