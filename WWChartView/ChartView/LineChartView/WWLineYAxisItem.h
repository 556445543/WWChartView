//
//  WWLineYAxisItem.h
//  JiaoYiHui
//
//  Created by ww on 2017/5/8.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWLineYAxisItem : NSObject
@property(nonatomic,copy) NSString *coordinateAxisY;

@property(nonatomic,assign) CGRect rect;

+(instancetype)itemModelWithCoordinateAxisY:(NSString *)coordinateAxisX rect:(CGRect)rect;
@end
