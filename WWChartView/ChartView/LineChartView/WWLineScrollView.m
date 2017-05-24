
//
//  WWLineScrollView.m
//  JiaoYiHui
//
//  Created by ww on 2017/4/17.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import "WWLineScrollView.h"
#import "NSString+DecimalNumber.h"
#import "WWTool.h"
#import "UIView+Extension.h"
#import "WWChartEntity.h"
#import "WWLineXAxisView.h"

static const CGFloat radius=1.8f;

@interface WWLineScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate,CAAnimationDelegate>

@property (nonatomic,strong)UIPinchGestureRecognizer * pinGesture;

@property (nonatomic,strong)UILongPressGestureRecognizer * longPressGesture;

@property (nonatomic,strong)UITapGestureRecognizer * tapGesture;

@property (nonatomic,assign)CGFloat lastPinScale;
/*****竖线距离******/
@property (nonatomic,assign) CGFloat verticalLinePitch;

@property (nonatomic,assign)NSInteger highlightLineCurrentIndex;

@property (nonatomic,assign)NSInteger lastHighlightLineCurrentIndex;

@property (nonatomic,assign)BOOL highlightLineCurrentEnabled;

@property (nonatomic,strong) CAShapeLayer *yFollowLineLayer;
/***手势拖动 的 中心圆点**/
@property (nonatomic,strong) CAShapeLayer *centerPointLayer;

@property (nonatomic,assign) CGFloat yFollowLinePointX;

@property (nonatomic,strong) CAShapeLayer *xFollowLineLayer;

@property (nonatomic,strong)  CAGradientLayer *backgroundGradientLayer;
/***中点Y值坐标*****/
@property (nonatomic,assign) CGFloat barChartY;

@end

@implementation WWLineScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
//        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = YES;
        [self addGestureRecognizer:self.pinGesture];
        [self addGestureRecognizer:self.longPressGesture];
//        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
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
        if ([sublayer isKindOfClass:[CAGradientLayer class]]) {
            [self.backgroundGradientLayer removeFromSuperlayer];
            _backgroundGradientLayer = nil;
        }
    }
    
    [self stroke];
}

- (void)stroke
{
    CGFloat h = 0;
    [self.entityArray removeAllObjects];
   
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    self.barChartY = (self.height);
    
    CAShapeLayer *barlayer = [CAShapeLayer layer];
    UIBezierPath * gradinentPath= [UIBezierPath bezierPath];
    CAShapeLayer *gradientLayer = [CAShapeLayer layer];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    NSMutableArray *animates = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        
        if (self.yMAxValue == 0 || self.yMinValue == 0) {
            self.barChartY = 0;
        }else{

            self.barChartY = (self.bounds.size.height - self.bottomSeparationDistance )* (self.yMAxValue/(self.yMAxValue + self.yMinValue)) ;
            
        }
        CGPoint point = CGPointZero;
        if ([self.dataArray[i] isKindOfClass:[NSString class]]) {
            NSString *pointStr = self.dataArray[i];
            point = CGPointFromString(pointStr);
           
            }else{
            
                h = [self.dataArray[i] doubleValue];

                if (h>0) {
                    if (self.yMAxValue == 0) {
                        h = CGFLOAT_MIN;
                    }else{
                    
                        h = h /self.yMAxValue  * (self.barChartY);
                        h = ceil(h);
                    }
                
                }else {
                    if (self.yMinValue == 0) {
                        h = CGFLOAT_MIN;
                    }else{
                    
                        h = h /self.yMinValue * (self.height - self.barChartY - self.bottomSeparationDistance );
                    
                    }
                
                }
            h = -h;
            CGFloat startX = (self.candleWidth * (i )) ;

            point = CGPointMake(startX, self.barChartY + h );

        }
        
        barlayer.lineCap = kCALineCapButt;
        barlayer.fillColor = [UIColor clearColor].CGColor;
        barlayer.strokeColor = [WWTool colorWithHexString:@"#4aa3df"].CGColor;
        barlayer.path = path.CGPath;
        
        [self.layer insertSublayer:barlayer atIndex:2];
        
        WWChartEntity *entity = [WWChartEntity new];
        entity.rect =CGRectMake(point.x, point.y, self.candleWidth, h);
        entity.index = i;
        [self.entityArray addObject:entity];
        
#pragma mark - 绘制 渐进底色 以及线条
        if ( i == 0 ){
            [path moveToPoint:CGPointMake(point.x, point.y)];
            if (self.dataArray.count > 1) {
                [path addLineToPoint:point];
                
                [gradinentPath moveToPoint:CGPointMake(point.x, self.height)];
                [gradinentPath addLineToPoint:CGPointMake(point.x, point.y)];
            }
        }
        
        else {
            [path addLineToPoint:point];
            [gradinentPath addLineToPoint:CGPointMake(point.x, point.y)];
        }
        
        barlayer.path = path.CGPath;
        
        if (self.dataArray.count -1 == i) {//数组取出最后一个点
            if (self.dataArray.count > 1) {
                
                [gradinentPath addLineToPoint:CGPointMake(point.x, self.height )];
                
                [path addLineToPoint:point];
                [gradinentPath closePath];
                
            }
            
        }
        
        gradientLayer.path = gradinentPath.CGPath;
        
        gradientLayer.strokeColor = [UIColor clearColor].CGColor;
        
        self.backgroundGradientLayer.mask = gradientLayer;
        
        if (self.animation) {
            CABasicAnimation *animate = [WWTool addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:.5 delegate:nil layer:barlayer];
            [animates addObject:animate];
        }
        
        
    }
    

    if (self.animation) {
        
        group.animations = animates;
        group.removedOnCompletion = NO;
        group.delegate = self;
        // 始终保持最新的效果
        group.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:group forKey:nil];
        
        [self scrollsToBottomAnimated:NO];

    }
    if (_chartViewDidLoadCompletion) {
        _chartViewDidLoadCompletion(self.barChartY);
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.animation = NO;
}
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (UIPinchGestureRecognizer *)pinGesture
{
    if (!_pinGesture) {
        _pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGestureAction:)];
        _pinGesture.delegate = self;
        
    }
    return _pinGesture;
}

- (void)handlePinGestureAction:(UIPinchGestureRecognizer *)recognizer
{
    if (!self.zoomEnabled) {
        return;
    }
    
    recognizer.scale= recognizer.scale-self.lastPinScale + 1;
    
    self.verticalLinePitch *= recognizer.scale;
    self.candleWidth = recognizer.scale * self.candleWidth;
    CGFloat xAxisVerticalLineDefaultPitch = self.width / 6;

    if(self.candleWidth > self.candleMaxWidth){
        
        CGFloat ratio = self.candleWidth / self.candleMaxWidth;
        
        self.candleWidth = self.candleMaxWidth;
        
        self.verticalLinePitch = xAxisVerticalLineDefaultPitch * ratio;
                
    }else if(self.candleWidth <= self.candleMinWidth){
        
        self.candleWidth = self.candleMinWidth;
        self.verticalLinePitch = xAxisVerticalLineDefaultPitch;
        
    }

    [self setNeedsDisplay];
    
    self.lastPinScale = recognizer.scale;
    
    self.contentSize = CGSizeMake((self.candleWidth ) *self.dataArray.count,0);
    if (_chartViewDidPitchCompletion) {
        _chartViewDidPitchCompletion(self.candleWidth);
    }
}

- (NSInteger)countOfshowCandle{
    if (self.candleWidth == 0) {
        return 0;
    }
    NSString *nb3 = [[NSString stringWithFormat:@"%f",self.width] priceByDividingBy:[NSString stringWithFormat:@"%f",self.candleWidth]];
    NSString *str2 = [NSString notRounding:nb3 afterPoint:0 roundingMode:NSRoundDown];
    
    return str2.integerValue;
}

- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.contentSize.width - self.bounds.size.width;
    if (offset > 0)
    {
        [self setContentOffset:CGPointMake(offset,0 ) animated:animated];
    }
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureAction:)];
        _longPressGesture.minimumPressDuration = 0.5;
    }
    return _longPressGesture;
}

- (void)handleLongPressGestureAction:(UILongPressGestureRecognizer *)recognizer
{
    if (!self.entityArray.count) {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.highlightLineCurrentEnabled = NO;
        [self.yFollowLineLayer removeFromSuperlayer];
        self.yFollowLineLayer = nil;
        [self.xFollowLineLayer removeFromSuperlayer];
        self.xFollowLineLayer = nil;
        [self.centerPointLayer removeFromSuperlayer];
        self.centerPointLayer = nil;
        self.lastHighlightLineCurrentIndex = 0;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint  point = [recognizer locationInView:self];
        self.highlightLineCurrentEnabled = YES;
        [self getHighlightByTouchPoint:point];
        
        WWChartEntity *entity = self.entityArray[self.highlightLineCurrentIndex];
        
        if (!self.lastHighlightLineCurrentIndex || self.highlightLineCurrentIndex != self.lastHighlightLineCurrentIndex) {
            self.lastHighlightLineCurrentIndex = self.highlightLineCurrentIndex;
            
            UIBezierPath *drawYLine=[UIBezierPath bezierPath];
            [drawYLine moveToPoint:CGPointMake(entity.rect.origin.x, 0)];
            [drawYLine addLineToPoint:CGPointMake(entity.rect.origin.x, self.height)];
            self.yFollowLineLayer.path=drawYLine.CGPath;
            
            UIBezierPath *drawXLine=[UIBezierPath bezierPath];
            [drawXLine moveToPoint:CGPointMake(0,entity.rect.origin.y)];
            [drawXLine addLineToPoint:CGPointMake( self.contentSize.width, entity.rect.origin.y)];
            
            self.xFollowLineLayer.path = drawXLine.CGPath;
            [self.layer addSublayer:self.xFollowLineLayer];
            [self.layer addSublayer:self.yFollowLineLayer];
            
            //绘制 十字线中点
            UIBezierPath *drawPoint=[UIBezierPath bezierPath];
            [drawPoint addArcWithCenter:CGPointMake(entity.rect.origin.x,  entity.rect.origin.y) radius:radius  startAngle:M_PI*0 endAngle:M_PI*2 clockwise:YES];
            
            self.centerPointLayer.path = drawPoint.CGPath;
            [self.layer addSublayer:self.centerPointLayer];
            if (self.chartViewDidClickedCompletion) {
                self.chartViewDidClickedCompletion(entity.index);
            }
        }
        
    }
    
}

- (void)getHighlightByTouchPoint:(CGPoint) point
{
    if (self.candleWidth <= 0) {
        return;
    }
    // 十字线偏移量
    NSString *offsetX = [[NSString stringWithFormat:@"%f",point.x] priceByDividingBy:[NSString stringWithFormat:@"%f",self.candleWidth]];
    NSString *highlightIndex = [NSString notRounding:offsetX afterPoint:0 roundingMode:NSRoundDown];
    
    self.highlightLineCurrentIndex = highlightIndex.integerValue;
    if (self.highlightLineCurrentIndex == NSNotFound || self.highlightLineCurrentIndex < 0) {
        self.highlightLineCurrentIndex = 0;
    }
    if (self.highlightLineCurrentIndex >= self.entityArray.count && self.entityArray.count != 0) {
        self.highlightLineCurrentIndex = self.entityArray.count - 1;
    }
    
}

#pragma mark - getter method
- (CAGradientLayer *)backgroundGradientLayer
{
    if (!_backgroundGradientLayer) {
        _backgroundGradientLayer = [CAGradientLayer layer];
        _backgroundGradientLayer.frame = CGRectMake(0, 0, self.contentSize.width , self.frame.size.height - self.bottomSeparationDistance);
        _backgroundGradientLayer.startPoint = CGPointMake(0, 0);
        _backgroundGradientLayer.endPoint = CGPointMake(0, 1);
        
        //    //设定颜色分割点
        _backgroundGradientLayer.locations = @[@(0.0),@(1.0)];

        _backgroundGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:.6].CGColor ,
                                            (__bridge id)[UIColor clearColor].CGColor];
//        _backgroundGradientLayer.colors = @[backColor,padeColor];
        [self.layer addSublayer:_backgroundGradientLayer];
    }
    return _backgroundGradientLayer;
}
- (CAShapeLayer *)xFollowLineLayer
{
    if (!_xFollowLineLayer) {
        _xFollowLineLayer = [[CAShapeLayer alloc] init];
        _xFollowLineLayer.strokeColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        _xFollowLineLayer.fillColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
    }
    return _xFollowLineLayer;
}

- (CAShapeLayer *)centerPointLayer
{
    if (!_centerPointLayer) {
        _centerPointLayer=[CAShapeLayer layer];
        
        _centerPointLayer.strokeColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        _centerPointLayer.fillColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        
    }
    return _centerPointLayer;
}

- (CAShapeLayer *)yFollowLineLayer
{
    if (!_yFollowLineLayer) {
        _yFollowLineLayer = [[CAShapeLayer alloc]init];
        _yFollowLineLayer.strokeColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        _yFollowLineLayer.fillColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
    }
    return _yFollowLineLayer;
}
- (NSMutableArray *)entityArray
{
    if (!_entityArray) {
        _entityArray = [NSMutableArray array];
    }
    return _entityArray;
}

//- (UITapGestureRecognizer *)tapGesture
//{
//    if (!_tapGesture) {
//        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGestureAction:)];
//    }
//    return _tapGesture;
//}
//- (void)handleTapGestureAction:(UIGestureRecognizer *)recognizer
//{
//    [self setNeedsDisplay];
//    CGPoint point = [recognizer locationInView:self.scrollView];
//    for (NSInteger i =0;i<self.entityArray.count;i++) {
//        WWChartEntity *entity = self.entityArray[i];
//        
//        if (CGRectContainsPoint(entity.rect, point)) {
//            
//            if (self.chartViewDidClickedCompletion) {
//                self.chartViewDidClickedCompletion(entity.index);
//            }
//        }
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
