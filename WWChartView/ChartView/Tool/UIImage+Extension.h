//
//  UIImage+Extension.h
//  PaiPaiDai
//
//  Created by c on 14-12-5.
//  Copyright (c) 2014年 adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)resizableImage:(NSString *)name;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
/*调整button的image的位置**/
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;
/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
+ (UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond url :(NSURL *)url;
/*********调整图片比例***********/
- (UIImage *)scaleImageToWidth:(CGFloat)width;

@end
