//
//  WWChartBackGroundView.h 
//
//  Created by ww on 16/6/24.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWBarXAxisItem;

@interface WWChartBackGroundView : UIView
/***背景图***/
@property (nonatomic,strong) UIImageView *backgroundImageView;
/***中点Y值坐标 *****/
@property (nonatomic,assign,readonly) CGFloat barChartY;
/**能否横向放大缩小*/
@property (nonatomic,assign) BOOL zoomEnabled;
/**绘制y轴*/
@property (nonatomic,assign) BOOL drawYAxisEnable;
/** drawYAxisEnable 为YES 可用
    autoDisplayXAxis 为NO 则绘制坐标值**/
@property (nonatomic,copy) NSArray <WWBarXAxisItem *>*xAxiscoordinateArray;

/*****视图顶部间距******/
@property (nonatomic,assign,readonly) CGFloat topSeparationDistance;
/*****视图底部间距******/
@property (nonatomic,assign,readonly) CGFloat bottomSeparationDistance;
/*****视图左边间距******/
@property (nonatomic,assign,readonly) CGFloat leftSeparationDistance;
/*****视图右边间距******/
@property (nonatomic,assign,readonly) CGFloat rightSeparationDistance;
/*****X坐标轴上的值******/
//@property (nonatomic,copy) NSArray *xisXLabelArray;

@property (nonatomic,copy) NSArray <NSString *> *yisYLabelArray;

@property (nonatomic,copy) NSArray *dataArray;

@property (nonatomic,copy) void(^chartViewDidClickedCompletion)(NSInteger);

/******  是否画出中点线*******/
@property (nonatomic,assign) BOOL drawCenterLineEnabled;
/****日期数组****/
@property (nonatomic,copy) NSArray <NSString *>*dateArray;

/*****无数据提示label******/
@property (nonatomic,strong) UILabel *PromptLabel;

/****左边y轴坐标  优先给出 根据坐标值算出左边距离***/
@property (nonatomic,copy) NSArray <NSString *> *yisYLeftLabelArray;

/**y坐标值距离 如果为nil 则根据横线个数 horizontalLineCount 自动计算宽度 */
@property (nonatomic,copy) NSString *yAxisDistance;

/*****水平线线距离******/
@property (nonatomic,assign) CGFloat horizontalLinePitch;

/**水平线个数*/
@property (nonatomic,assign) NSUInteger horizontalLineCount;

@property (nonatomic,strong) UIColor *leftYAxisColor;

@property (nonatomic,strong) UIColor *rightYAxisColor;

@end


