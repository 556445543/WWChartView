//
//  UIImage+Extension.m
//  PaiPaiDai
//
//  Created by c on 14-12-5.
//  Copyright (c) 2014年 adinnet. All rights reserved.
//

#import "UIImage+Extension.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Extension)
+ (UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h/2, w, w, h)];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self resizableImage:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
// --------------------------------------------------
// Resize an image
// --------------------------------------------------
- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height {
    
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4*destW,
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resultImage;
}
+(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond url :(NSURL *)url
{
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数是视频第几秒，第二个参数时每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    //保存到相册
    //    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    //    CGImageRelease(cgImage);
    return image;
}


-(UIImage *)scaleImageToWidth:(CGFloat)width
{
    // 提示: 不要使用比例, 如果所有图片都按照指定比例来缩放, 图片太小就看不见了
    // 1. 判断宽度，如果小于指定宽度直接返回当前图像
    if (self.size.width < width) {
        return self;
    }
    // 2. 计算等比例缩放的高度
    CGFloat height = width * self.size.height / self.size.width;
    
    // 3. 图像的上下文
    CGSize s =CGSizeMake(width, height);
    // 提示：一旦开启上下文，所有的绘图都在当前上下文中
    UIGraphicsBeginImageContext(s);
    
    // 在制定区域中缩放绘制完整图像

    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    
    // 4. 获取绘制结果
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    
    // 6. 返回结果
    return result;

}
@end
