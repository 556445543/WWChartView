//
//  WWTool.h
//
//  Created by ww on 16/6/24.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WWTool : NSObject
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode;

+ (UIColor *) colorWithHexString: (NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (CABasicAnimation *)addAnimationForKeypath:(NSString *)keyPath
                                   fromValue:(CGFloat)fromValue
                                     toValue:(CGFloat)toValue
                                    duration:(CGFloat)duration
                                    delegate:(id)delegate
                                       layer:(CAShapeLayer *)layer;

+ (CATextLayer *)textLayerWithRect:(CGRect)rect position:(CGPoint)position date:(NSString *)date textColor:(UIColor *)textColor currentView:(UIView *)view;

+ (CATextLayer *)textLayerWithRect:(CGRect)rect date:(NSString *)date textColor:(UIColor *)textColor currentView:(UIView *)view;

@end
