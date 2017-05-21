//
//  WWXAxisView.h
//  JiaoYiHui
//
//  Created by ww on 2017/3/30.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWChartEntity;

@interface WWXAxisView : UIView

@property (nonatomic,assign) CGFloat leftSeparationDistance;

/****日期数组****/
@property (nonatomic,strong) NSArray <NSString *>*dateArray;

@property (nonatomic,assign) CGFloat candleWidth;

@property (nonatomic,assign) CGFloat horizontalSpacing;

@property (nonatomic,assign)NSInteger countOfshowCandle;

@property (nonatomic,strong) NSMutableArray *entityArray;

@property (nonatomic,assign) BOOL autoDisplayXAxis;

@property (nonatomic,copy) NSArray *xAxiscoordinateArray;

@property (nonatomic,assign) NSInteger xAxisCount;
/**
 屏幕显示的第一个index
 */
@property (nonatomic,assign) NSInteger firstIndex;

/**
 屏幕显示的最后一个index
 */
@property (nonatomic,assign) NSInteger lastIndex;

- (instancetype)initWithFrame:(CGRect)frame xAxisCount:(NSInteger)xAxisCount;

- (void)updateXAxisArray;

- (void)upDateArray:(NSArray<NSString *> *)dateArray candleWidth:(CGFloat)candleWidth horizontalSpacing:(CGFloat)horizontalSpacing countOfshowCandle:(CGFloat)countOfshowCandle entityArray:(NSArray< WWChartEntity *> *)entityArray;

@end
