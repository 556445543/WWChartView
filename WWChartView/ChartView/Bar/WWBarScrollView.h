//
//  WWBarScrollView.h
//  JiaoYiHui
//
//  Created by ww on 2017/4/19.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWChartEntity,WWXAxisView,WWBarChartItem;

@interface WWBarScrollView : UIScrollView
/*****视图底部间距******/
@property (nonatomic,assign) CGFloat bottomSeparationDistance;
/***柱条间距**/
@property (nonatomic,assign) CGFloat horizontalSpacing;

@property (nonatomic,copy) NSArray *dataArray;

@property (nonatomic,strong) WWBarChartItem *chartItemColor;

@property (nonatomic,assign) CGFloat candleWidth;
/**最大宽度*/
@property (nonatomic,assign)CGFloat candleMaxWidth;
/**最小宽度*/
@property (nonatomic,assign)CGFloat candleMinWidth;
/**能否放大缩小*/
@property (nonatomic,assign)BOOL zoomEnabled;

@property (nonatomic,assign) CGFloat yMAxValue;

@property (nonatomic,assign) CGFloat yMinValue;

@property (nonatomic,assign,readonly)NSInteger countOfshowCandle;

@property (nonatomic, assign) BOOL animation;

@property (nonatomic,strong,readonly) NSMutableArray<WWChartEntity *> *entityArray;

@property (nonatomic,assign) BOOL highlightLineShowEnabled;

@property (nonatomic,copy) void(^chartViewDidClickedCompletion)(NSInteger);

@property (nonatomic,copy) void(^chartViewDidLoadCompletion)(CGFloat barChartY);

@property (nonatomic,copy) void(^chartViewDidPitchCompletion)(CGFloat candleWidth);

/*绘制的线 不支持 放大缩小**/
@property (nonatomic,copy) NSArray <NSNumber *> *lineDataArray;
@property (nonatomic,assign) CGFloat yLineMAxValue;
@property (nonatomic,assign) CGFloat yLineMinValue;
@property (nonatomic,copy) void (^chartLineCallBack)(NSInteger index);
@property (nonatomic,assign) CGFloat candleLineWidth;

@property (nonatomic,assign)CGFloat candleLineMaxWidth;

@property (nonatomic,assign)CGFloat candleLineMinWidth;
@end
