//
//  WWBarView.m
//  JiaoYiHui
//
//  Created by ww on 16/7/14.
//  Copyright © 2016年 weihui. All rights reserved.
//

#import "WWBarView.h"
#import "WWChartEntity.h"
#import "UIView+Extension.h"
#import "WWTool.h"
#import "WWXAxisView.h"
#import "NSString+DecimalNumber.h"
#import "WWBarScrollView.h"

@interface WWBarView()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray<WWChartEntity *> *entityArray;

@property (nonatomic,weak) WWBarScrollView *scrollView;

@property (nonatomic,weak) WWXAxisView *xAxisView;

@property (nonatomic,assign,readwrite) CGFloat barChartY;

@end

@implementation WWBarView

@synthesize barChartY = _barChartY;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        
    }
    return self;
}

- (void)commonInit {
    self.candleMaxWidth = 30;
    self.candleMinWidth = 1;
    self.candleWidth = 8;
    self.horizontalSpacing = 14;
    self.candleLineWidth = self.candleWidth;
    CGFloat scrollViewWidth = self.bounds.size.width - self.leftSeparationDistance - self.rightSeparationDistance;
    WWBarScrollView *scrollView = [[WWBarScrollView alloc] initWithFrame:CGRectMake(self.leftSeparationDistance, self.topSeparationDistance, scrollViewWidth,self.bounds.size.height - self.topSeparationDistance)];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    __weak __typeof(self)weakSelf = self;
    
    [self.scrollView setChartViewDidClickedCompletion:^(NSInteger tag) {
        if (weakSelf.chartViewDidClickedCompletion) {
            weakSelf.chartViewDidClickedCompletion(tag);
        }
    }];
    
    [self.scrollView setChartViewDidLoadCompletion:^(CGFloat barChartY){
        self.barChartY = barChartY;
        [weakSelf.xAxisView upDateArray:weakSelf.dateArray
                            candleWidth:weakSelf.candleWidth
                      horizontalSpacing:weakSelf.horizontalSpacing
                      countOfshowCandle:weakSelf.scrollView.countOfshowCandle
                            entityArray:weakSelf.entityArray];
        
        weakSelf.xAxisView.leftSeparationDistance = weakSelf.leftSeparationDistance;
        weakSelf.xAxisView.entityArray = weakSelf.scrollView.entityArray;
        [weakSelf updateXAxisIndexWithScrollView:scrollView];
        
    }];
    [self.scrollView setChartViewDidPitchCompletion:^(CGFloat candleWidth){
        weakSelf.xAxisView.width = weakSelf.scrollView.contentSize.width;
        if (_chartViewDidPitchCompletion) {
            _chartViewDidPitchCompletion(candleWidth);
        }

    }];
    
    WWXAxisView *xView = [[WWXAxisView alloc] initWithFrame:CGRectMake(0, self.scrollView.bounds.size.height - self.bottomSeparationDistance , self.scrollView.bounds.size.width, self.bottomSeparationDistance) xAxisCount:4];
    xView.clipsToBounds = NO;
    xView.autoDisplayXAxis = self.autoDisplayXAxis;
    
    [self.scrollView addSubview:xView];
    self.xAxisView = xView;
    
}

- (void)stroke
{
    self.scrollView.x = self.leftSeparationDistance;
    self.scrollView.width = self.bounds.size.width - self.leftSeparationDistance - self.rightSeparationDistance;
    
    if (self.dataArray.count) {
        self.scrollView.contentSize = CGSizeMake(self.leftSeparationDistance +(self.candleWidth + self.horizontalSpacing) *self.dataArray.count +self.candleWidth/2 + self.horizontalSpacing/2,0);
        self.xAxisView.width = self.scrollView.contentSize.width;
        
        self.scrollView.bottomSeparationDistance = self.bottomSeparationDistance;
       
        self.scrollView.chartItemColor.strokeTopColor = self.chartItemColor.strokeTopColor;
        self.scrollView.chartItemColor.strokeBottomColor = self.chartItemColor.strokeBottomColor;
    }else{
        self.xAxisView.width = 0;
    }
    
    if (self.leftSeparationDistance +(self.candleWidth + self.horizontalSpacing) *self.dataArray.count < self.bounds.size.width) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width,0);
    }
    
    if (!self.autoDisplayXAxis) {
        self.xAxisView.xAxiscoordinateArray = self.xAxiscoordinateArray;
    }
    [self setNeedsLayout];
    
    [self setNeedsDisplay];
}

- (void)updateXAxisIndexWithScrollView:(UIScrollView *)scrollView
{
    
    NSString *offset = [[NSString stringWithFormat:@"%f",scrollView.contentOffset.x - self.horizontalSpacing/2] priceByDividingBy:[NSString stringWithFormat:@"%f",self.scrollView.candleWidth+self.horizontalSpacing]];
    NSString *offsetUp = [NSString notRounding:offset afterPoint:0 roundingMode:NSRoundUp];
    
    NSString *offsetDown = [NSString notRounding:offset afterPoint:0 roundingMode:NSRoundDown];
    self.xAxisView.firstIndex = offsetUp.integerValue;
    
    self.xAxisView.lastIndex = offsetDown.integerValue + self.scrollView.countOfshowCandle;
    [self.xAxisView updateXAxisArray];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateXAxisIndexWithScrollView:scrollView];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self updateXAxisIndexWithScrollView:scrollView];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self updateXAxisIndexWithScrollView:scrollView];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];

    for (NSInteger i =self.layer.sublayers.count -1; i>= 0; i--) {
        CALayer *sublayer = self.layer.sublayers[i];
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
        if ([sublayer isKindOfClass:[CATextLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
        
    }
    [self.scrollView setNeedsDisplay];

}

- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    if (offset > 0)
    {
        [self.scrollView setContentOffset:CGPointMake(offset,0 ) animated:animated];
    }
}
#pragma mark - getter -setter method

- (void)setDateArray:(NSArray<NSString *> *)dateArray
{
    [super setDateArray:dateArray];
    self.xAxisView.dateArray = dateArray;
}

- (void)setXAxisCount:(NSInteger)xAxisCount
{
    _xAxisCount = xAxisCount;
    self.xAxisView.xAxisCount = xAxisCount;
}

- (void)setAutoDisplayXAxis:(BOOL)autoDisplayXAxis
{
    _autoDisplayXAxis = autoDisplayXAxis;
    self.xAxisView.autoDisplayXAxis = autoDisplayXAxis;
}

- (void)setDataArray:(NSArray *)dataArray
{
    [super setDataArray:dataArray];
    self.scrollView.dataArray = dataArray;
}

- (void)setCandleWidth:(CGFloat)candleWidth
{
    _candleWidth = candleWidth;
    self.scrollView.candleWidth = candleWidth;
}
- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing
{
    _horizontalSpacing = horizontalSpacing;
    self.scrollView.horizontalSpacing = horizontalSpacing;
}

- (void)setCandleMaxWidth:(CGFloat)candleMaxWidth
{
    _candleMaxWidth = candleMaxWidth;
    self.scrollView.candleMaxWidth = candleMaxWidth;
}

- (void)setCandleMinWidth:(CGFloat)candleMinWidth
{
    _candleMinWidth = candleMinWidth;
    self.scrollView.candleMinWidth = candleMinWidth;
}

-(void)setAnimation:(BOOL)animation
{
    _animation = animation;
    self.scrollView.animation = animation;
}

- (void)setYMAxValue:(CGFloat)yMAxValue
{
    _yMAxValue = yMAxValue;
    self.scrollView.yMAxValue = yMAxValue;
}

- (void)setYMinValue:(CGFloat)yMinValue
{
    _yMinValue = yMinValue;
    self.scrollView.yMinValue = yMinValue;
}

- (void)setZoomEnabled:(BOOL)zoomEnabled
{
    [super setZoomEnabled:zoomEnabled];
    self.scrollView.zoomEnabled = zoomEnabled;
}

- (void)setHighlightLineShowEnabled:(BOOL)highlightLineShowEnabled
{
    _highlightLineShowEnabled = highlightLineShowEnabled;
    self.scrollView.highlightLineShowEnabled = highlightLineShowEnabled;
}

- (void)setYLineMAxValue:(CGFloat)yLineMAxValue
{
    _yLineMAxValue = yLineMAxValue;
    self.scrollView.yLineMAxValue = yLineMAxValue;
}

- (void)setYLineMinValue:(CGFloat)yLineMinValue
{
    _yLineMinValue = yLineMinValue;
    self.scrollView.yLineMinValue = yLineMinValue;
}

- (void)setCandleLineWidth:(CGFloat)candleLineWidth
{
    _candleLineWidth = candleLineWidth;
    self.scrollView.candleLineWidth = candleLineWidth;
}

- (void)setLineDataArray:(NSArray<NSNumber *> *)lineDataArray
{
    _lineDataArray = [lineDataArray copy];
    self.scrollView.lineDataArray = lineDataArray;
}

- (NSMutableArray *)entityArray
{
    if (!_entityArray) {
        _entityArray = [NSMutableArray array];
    }
    return _entityArray;
}

- (WWBarChartItem *)chartItemColor
{
    if (!_chartItemColor) {
        _chartItemColor = [WWBarChartItem new];
    }
    return _chartItemColor;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
