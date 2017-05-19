//
//  WWPieCHartLayer.h
//  Pie
//
//  Created by ww on 16/6/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWPieCHartLayer : CAShapeLayer
// layer位置
@property (nonatomic, assign) NSInteger index;
// 所占百分比
@property (nonatomic, assign) CGFloat percent;
// 显示text
@property (nonatomic, strong) NSString *text;
// info
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
- (void)addArcAnimationForKeypath:(NSString *)keyPath
                        fromValue:(CGFloat)fromValue
                          toValue:(CGFloat)toValue
                         duration:(CGFloat)duration
                         delegate:(id)delegate;
@end
