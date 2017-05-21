//
//  WWChartEntity.h
//  06-柱状图
//
//  Created by ww on 16/6/22.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WWChartEntity : NSObject

typedef struct __attribute__((objc_boxable)) {
    CGFloat x, y, width, height;
} WWRect;

@property (nonatomic,assign) CGRect rect;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong) CAShapeLayer *layer;

@property (nonatomic,assign) CGRect selectedRect;

//@property (nonatomic,strong) CAShapeLayer *selectedLayer;


@end
