


//
//  WWBarXAxisItem.m
//  JiaoYiHui
//
//  Created by ww on 2017/4/26.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import "WWBarXAxisItem.h"

@implementation WWBarXAxisItem

+(instancetype)itemModelWithCoordinateAxisX:(NSString *)coordinateAxisX rect:(CGRect)rect
{
    
    WWBarXAxisItem *itemModel = [[WWBarXAxisItem alloc] init];
    itemModel.coordinateAxisX = coordinateAxisX;
    itemModel.rect = rect;
    return itemModel;
}

@end
