//
//  WWLineChartView.m
//  ChartView
//
//  Created by ww on 16/6/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "WWLineChartView.h"
#import "UIView+Extension.h"
#import "WWXAxisView.h"
#import "NSString+DecimalNumber.h"
#import "WWLineScrollView.h"
#import "WWLineXAxisView.h"

@interface WWLineChartView()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) WWLineScrollView *scrollView;

@property (nonatomic,weak) WWLineXAxisView *xAxisView;

@property (nonatomic,assign,readwrite) CGFloat barChartY;

@end

@implementation WWLineChartView

@synthesize barChartY = _barChartY;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        
    }
    return self;
}

- (void)commonInit {
    self.candleMaxWidth = 15;
    self.candleMinWidth = 1;
    self.candleWidth = 8;
    CGFloat scrollViewWidth = self.bounds.size.width - self.leftSeparationDistance - self.rightSeparationDistance;

    WWLineScrollView *scrollView = [[WWLineScrollView alloc] initWithFrame:CGRectMake(self.leftSeparationDistance, self.topSeparationDistance, scrollViewWidth,self.bounds.size.height - self.topSeparationDistance)];
    scrollView.delegate = self;
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
        self.xAxisView.entityArray = self.scrollView.entityArray;
        self.xAxisView.dateArray = self.dateArray;
        self.xAxisView.countOfshowCandle = self.scrollView.countOfshowCandle;

        [self updaateXAxisIndexWithScrollView:scrollView];

    }];
    [self.scrollView setChartViewDidPitchCompletion:^(CGFloat candleWidth){
        if (_chartViewDidPitchCompletion) {
            _chartViewDidPitchCompletion(candleWidth);
        }
        [self updaateXAxisIndexWithScrollView:self.scrollView];
    }];
     WWLineXAxisView *xView = [[WWLineXAxisView alloc] initWithFrame:CGRectMake(self.leftSeparationDistance, self.scrollView.height- self.bottomSeparationDistance+self.topSeparationDistance, self.scrollView.bounds.size.width , self.bottomSeparationDistance) xAxisCount:4];
    [xView setupXAxisCount:2 customXAxisEnable:NO];
    xView.clipsToBounds = YES;
    [self addSubview:xView];
    self.xAxisView = xView;
    
    self.scrollView.xView = xView;
    
}

-(void)stroke
{
    [self.scrollView.entityArray removeAllObjects];
    self.xAxisView.entityArray = @[];
    
    self.scrollView.x = self.leftSeparationDistance;
    self.scrollView.width = self.bounds.size.width - self.leftSeparationDistance - self.rightSeparationDistance;
    self.xAxisView.x = self.leftSeparationDistance;

    if (self.dataArray.count) {
        
        if ([self.dataArray.firstObject isKindOfClass:[NSString class]]) {
            NSString *firstPointStr = self.dataArray.firstObject;
            CGPoint firstPoint = CGPointFromString(firstPointStr);
            
            NSString *lastPointStr = self.dataArray.lastObject;
            CGPoint lastPoint = CGPointFromString(lastPointStr);
            
            self.candleWidth = (lastPoint.x - firstPoint.x)/self.dataArray.count;
        }
        
        
        self.xAxisView.width = self.bounds.size.width - self.leftSeparationDistance - self.rightSeparationDistance;
        
        if ((self.candleWidth ) *(self.dataArray.count-1) <= self.scrollView.width) {
            self.scrollView.contentSize = CGSizeMake(self.bounds.size.width - self.leftSeparationDistance - self.rightSeparationDistance,0);
            self.xAxisView.scrollEnabled = NO;
        }else{
            self.scrollView.contentSize = CGSizeMake((self.candleWidth ) *self.dataArray.count,0);
            self.xAxisView.scrollEnabled = YES;

        }
        
        self.scrollView.bottomSeparationDistance = self.bottomSeparationDistance;
        self.xAxisView.width = self.width - self.leftSeparationDistance - self.rightSeparationDistance;

    }else{//修改宽度为0 隐藏底部
        self.xAxisView.width = 0;
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)setDataArray:(NSArray *)dataArray
{
    [super setDataArray:dataArray];
    self.scrollView.dataArray = dataArray;
}
- (void)setXAxiscoordinateArray:(NSArray<WWBarXAxisItem *> *)xAxiscoordinateArray
{
    [super setXAxiscoordinateArray:xAxiscoordinateArray];
    
    self.xAxisView.xAxiscoordinateArray = xAxiscoordinateArray;
}

- (void)setDateArray:(NSArray<NSString *> *)dateArray
{
    [super setDateArray:dateArray];
    self.xAxisView.dateArray = dateArray;
}

- (void)setCandleMinWidth:(CGFloat)candleMinWidth
{
    _candleMinWidth = candleMinWidth;
    self.scrollView.candleMinWidth = candleMinWidth;
}

- (void)setAnimation:(BOOL)animation
{
    _animation = animation;
    self.scrollView.animation = animation;
}

- (void)setYMAxValue:(CGFloat)yMAxValue
{
    _yMAxValue = yMAxValue;
    self.scrollView.yMAxValue = yMAxValue;
}

- (void)setZoomEnabled:(BOOL)zoomEnabled
{
    [super setZoomEnabled:zoomEnabled];
    self.scrollView.zoomEnabled = zoomEnabled;
}


- (void)setYMinValue:(CGFloat)yMinValue
{
    _yMinValue = yMinValue;
    self.scrollView.yMinValue = yMinValue;
}

- (void)setCandleMaxWidth:(CGFloat)candleMaxWidth
{
    _candleMaxWidth = candleMaxWidth;
    self.scrollView.candleMaxWidth = candleMaxWidth;
}

- (void)setCandleWidth:(CGFloat)candleWidth
{
    _candleWidth = candleWidth;
    self.scrollView.candleWidth = candleWidth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updaateXAxisIndexWithScrollView:scrollView];
}

- (void)updaateXAxisIndexWithScrollView:(UIScrollView *)scrollView
{
    if (self.scrollView.candleWidth <= 0) {
        return;
    }
    NSString *nb3 = [[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] priceByDividingBy:[NSString stringWithFormat:@"%f",self.scrollView.candleWidth]];
    NSString *str = [NSString notRounding:nb3 afterPoint:0 roundingMode:NSRoundUp];
    
    NSString *str2 = [NSString notRounding:nb3 afterPoint:0 roundingMode:NSRoundDown];
    self.xAxisView.firstIndex = str.integerValue;
    self.xAxisView.lastIndex = str2.integerValue + self.scrollView.countOfshowCandle;
    [self.xAxisView updateXAxisArray];

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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
