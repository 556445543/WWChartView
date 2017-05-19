
//
//  WWTool.m
//
//  Created by ww on 16/6/24.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "WWTool.h"

@implementation WWTool
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}
//做ios版本之间的适配
//不同的ios版本,调用不同的方法,实现相同的功能
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode
{
//    NSLog(@"版本号:%f",[[[UIDevice currentDevice]systemVersion]doubleValue]);
    CGSize s;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0) {
//        NSLog(@"ios7以后版本");
        NSDictionary *dic=@{NSFontAttributeName:font};
        NSMutableDictionary  *mdic=[NSMutableDictionary dictionary];
        [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        [mdic setObject:font forKey:NSFontAttributeName];
        s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:mdic context:nil].size;
    }
    else
    {
        NSLog(@"ios7之前版本");
        s=[str sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    }
    return s;
}


+ (CABasicAnimation *)addAnimationForKeypath:(NSString *)keyPath
                                   fromValue:(CGFloat)fromValue
                                     toValue:(CGFloat)toValue
                                    duration:(CGFloat)duration
                                    delegate:(id)delegate
                                       layer:(CAShapeLayer *)layer{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.delegate = delegate;
    animation.fillMode = kCAFillModeRemoved;
    animation.autoreverses = NO;
    //    animation.delegate = self;
    [layer addAnimation:animation forKey:keyPath];
    return animation;
}


+ (CATextLayer *)textLayerWithRect:(CGRect)rect position:(CGPoint)position date:(NSString *)date textColor:(UIColor *)textColor currentView:(UIView *)view
{
    CATextLayer *textLayer = [self textLayerWithRect:rect date:date textColor:textColor currentView:view];
    textLayer.position = position;
    return textLayer;
}

+ (CATextLayer *)textLayerWithRect:(CGRect)rect date:(NSString *)date textColor:(UIColor *)textColor currentView:(UIView *)view
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.string = date;
    textLayer.alignmentMode = kCAAlignmentCenter;
    //    textLayer.wrapped = YES;
    
    textLayer.font = (__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:8]);
    textLayer.foregroundColor = textColor.CGColor;
    textLayer.frame = rect;
    textLayer.fontSize = 6;
    [view.layer addSublayer:textLayer];
    return textLayer;
}


@end
