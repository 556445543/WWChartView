



//
//  WWLineYAxisItem.m
//  JiaoYiHui
//
//  Created by ww on 2017/5/8.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import "WWLineYAxisItem.h"

@implementation WWLineYAxisItem
+(instancetype)itemModelWithCoordinateAxisY:(NSString *)coordinateAxisY rect:(CGRect)rect
{
    
    WWLineYAxisItem *itemModel = [[WWLineYAxisItem alloc] init];
    itemModel.coordinateAxisY = coordinateAxisY;
    itemModel.rect = rect;
    return itemModel;
}
@end
