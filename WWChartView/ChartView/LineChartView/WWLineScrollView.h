//
//  WWLineScrollView.h
//  JiaoYiHui
//
//  Created by ww on 2017/4/17.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWChartEntity,WWXAxisView,WWLineXAxisView;
@interface WWLineScrollView : UIScrollView
/*****视图底部间距******/
@property (nonatomic,assign) CGFloat bottomSeparationDistance;

@property (nonatomic,copy) NSArray *dataArray;

@property (nonatomic,weak) WWLineXAxisView *xView;

@property (nonatomic,assign) CGFloat candleWidth;
/**最大宽度*/
@property (nonatomic,assign)CGFloat candleMaxWidth;
/**最小宽度*/
@property (nonatomic,assign)CGFloat candleMinWidth;
/**能否放大缩小*/
@property (nonatomic,assign)BOOL zoomEnabled;

@property (nonatomic,copy) void(^chartViewDidClickedCompletion)(NSInteger);

@property (nonatomic,copy) void(^chartViewDidLoadCompletion)(CGFloat barChartY);

@property (nonatomic,copy) void(^chartViewDidPitchCompletion)(CGFloat candleWidth);

@property (nonatomic,assign) CGFloat yMAxValue;

@property (nonatomic,assign) CGFloat yMinValue;

@property (nonatomic,assign)NSInteger countOfshowCandle;

@property (nonatomic, assign) BOOL animation;

@property (nonatomic,strong) NSMutableArray<WWChartEntity *> *entityArray;

@property (nonatomic,assign) BOOL drawPointAXis;

- (void)scrollsToBottomAnimated:(BOOL)animated;

- (void)stroke;

@end
