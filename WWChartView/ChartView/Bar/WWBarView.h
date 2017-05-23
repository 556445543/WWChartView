//
//  WWBarView.h
//  JiaoYiHui
//
//  Created by ww on 16/7/14.
//  Copyright © 2016年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWChartBackGroundView.h"
#import "WWBarChartItem.h"
#import "WWBarXAxisItem.h"

@class WWChartEntity;
@interface WWBarView : WWChartBackGroundView
/**宽度*/
@property (nonatomic,assign) CGFloat candleWidth;
/**最大宽度*/
@property (nonatomic,assign)CGFloat candleMaxWidth;
/**最小宽度*/
@property (nonatomic,assign)CGFloat candleMinWidth;
/**是否允许动画**/
@property (nonatomic, assign) BOOL animation;
/**y轴最大值**/
@property (nonatomic,assign) CGFloat yMAxValue;
/*y轴最小值**/
@property (nonatomic,assign) CGFloat yMinValue;
/***柱条间距**/
@property (nonatomic,assign) CGFloat horizontalSpacing;
/**绘制柱状图颜色*/
@property (nonatomic,strong) UIColor *strokeColor;
@property (nonatomic,strong) WWBarChartItem *chartItemColor;

@property (nonatomic,assign) BOOL highlightLineShowEnabled;

/**
 如果为YES 需要设置 xAxisCount 的值来确定X轴上时间个数。
 如果为NO 则不需要
 */
@property (nonatomic,assign) BOOL autoDisplayXAxis;

@property (nonatomic,assign) NSInteger xAxisCount;

@property (nonatomic,copy) void(^chartViewDidPitchCompletion)(CGFloat candleWidth);

/***绘制线条方法***/

/*绘制的线 不支持 放大缩小**/
@property (nonatomic,copy) NSArray <NSNumber *> *lineDataArray;
@property (nonatomic,assign) CGFloat yLineMAxValue;
@property (nonatomic,assign) CGFloat yLineMinValue;
@property (nonatomic,copy) void (^chartLineCallBack)(NSInteger index);
@property (nonatomic,assign) CGFloat candleLineWidth;

@property (nonatomic,assign)CGFloat candleLineMaxWidth;

@property (nonatomic,assign)CGFloat candleLineMinWidth;


- (void)stroke;
@end

