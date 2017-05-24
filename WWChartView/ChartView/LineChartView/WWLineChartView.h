//
//  WWLineChartView.h
//  ChartView
//
//  Created by ww on 16/6/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWChartBackGroundView.h"
#import "WWLineYAxisItem.h"
#import "WWBarXAxisItem.h"

@interface WWLineChartView : WWChartBackGroundView

/**
 点与点之间的距离 
 */
@property (nonatomic,assign) CGFloat candleWidth;

@property (nonatomic,assign)CGFloat candleMaxWidth;

@property (nonatomic,assign)CGFloat candleMinWidth;

@property (nonatomic, assign) BOOL animation;
/***间距**/
@property (nonatomic,assign) CGFloat horizontalSpacing;

@property (nonatomic,assign) CGFloat yMAxValue;
@property (nonatomic,assign) CGFloat yMinValue;

@property (nonatomic,copy) void(^chartViewDidPitchCompletion)(CGFloat candleWidth);

- (void)stroke;

@end
