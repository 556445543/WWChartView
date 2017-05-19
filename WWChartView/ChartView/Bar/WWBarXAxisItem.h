//
//  WWBarXAxisItem.h
//  JiaoYiHui
//
//  Created by ww on 2017/4/26.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWBarXAxisItem : NSObject

@property(nonatomic,copy) NSString *coordinateAxisX;

@property(nonatomic,assign) CGRect rect;

+(instancetype)itemModelWithCoordinateAxisX:(NSString *)coordinateAxisX rect:(CGRect)rect;

@end
