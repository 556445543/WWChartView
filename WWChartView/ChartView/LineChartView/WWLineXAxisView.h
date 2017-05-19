//
//  WWLineXAxisView.h
//  JiaoYiHui
//
//  Created by ww on 2017/4/19.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWChartEntity;
@interface WWLineXAxisView : UIView
/****日期数组****/
@property (nonatomic,copy) NSArray *dateArray;

@property (nonatomic,copy) NSArray *entityArray;

@property (nonatomic,copy) NSArray *xAxiscoordinateArray;

@property (nonatomic,assign)NSInteger countOfshowCandle;

@property (nonatomic,assign) NSInteger xAxisCount;

@property (nonatomic,assign) BOOL scrollEnabled;
/**
 屏幕显示的第一个index
 */
@property (nonatomic,assign) NSInteger firstIndex;

/**
 屏幕显示的最后一个index
 */
@property (nonatomic,assign) NSInteger lastIndex;

- (instancetype)initWithFrame:(CGRect)frame xAxisCount:(NSInteger)xAxisCount;

- (void)setupXAxisCount:(NSInteger)xAxisCount customXAxisEnable:(BOOL)customXAxisEnable;

- (void)updateXAxisArray;

@end
