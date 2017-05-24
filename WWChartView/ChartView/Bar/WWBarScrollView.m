

//
//  WWBarScrollView.m
//  JiaoYiHui
//
//  Created by ww on 2017/4/19.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import "WWBarScrollView.h"
#import "WWChartEntity.h"
#import "UIView+Extension.h"
#import "WWTool.h"
#import "WWXAxisView.h"
#import "NSString+DecimalNumber.h"
#import "WWBarChartItem.h"

static const CGFloat radius=2.f;

@interface WWBarScrollView ()<CAAnimationDelegate,UIGestureRecognizerDelegate>

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

@property (nonatomic,strong) CAShapeLayer *selectedLayer;

@property (nonatomic,strong) CAShapeLayer *borderLayer;

@property (nonatomic,strong,readwrite) NSMutableArray<WWChartEntity *> *entityArray;

/***手势拖动 的 中心圆点**/
@property (nonatomic,strong) CAShapeLayer *centerPointLayer;

@property (nonatomic,assign) CGFloat yFollowLinePointX;

@property (nonatomic,strong) CAShapeLayer *xFollowLineLayer;

@property (nonatomic,strong)  CAGradientLayer *backgroundGradientLayer;
/***中点Y值坐标*****/
@property (nonatomic,assign) CGFloat barChartY;

@end

@implementation WWBarScrollView

-(NSMutableArray *)entityArray
{
    if (!_entityArray) {
        _entityArray = [NSMutableArray array];
    }
    return _entityArray;
}

-(CAShapeLayer *)xFollowLineLayer
{
    if (!_xFollowLineLayer) {
        _xFollowLineLayer = [[CAShapeLayer alloc] init];
        _xFollowLineLayer.strokeColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        _xFollowLineLayer.fillColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
    }
    return _xFollowLineLayer;
}
-(CAShapeLayer *)selectedLayer
{
    if (!_selectedLayer) {
        _selectedLayer = [CAShapeLayer layer];
        _selectedLayer.fillColor = [UIColor clearColor].CGColor;
        _selectedLayer.strokeColor = [WWTool colorWithHexString:@"#1B1F22"].CGColor;
    }
    return _selectedLayer;
}
-(CAShapeLayer *)borderLayer
{
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.fillColor  = [UIColor clearColor].CGColor;
        _borderLayer.strokeColor    = [UIColor redColor].CGColor;
    }
    return _borderLayer;
}
-(CAShapeLayer *)yFollowLineLayer
{
    if (!_yFollowLineLayer) {
        _yFollowLineLayer = [[CAShapeLayer alloc]init];
        _yFollowLineLayer.strokeColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        _yFollowLineLayer.fillColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
    }
    return _yFollowLineLayer;
}
-(WWBarChartItem *)chartItemColor
{
    if (!_chartItemColor) {
        _chartItemColor = [WWBarChartItem new];
    }
    return _chartItemColor;
}
- (NSInteger)countOfshowCandle{
    if (self.candleWidth + self.horizontalSpacing == 0) {
        return 0;
    }
    NSString *count = [[NSString stringWithFormat:@"%f",self.width ] priceByDividingBy:[NSString stringWithFormat:@"%f",self.candleWidth + self.horizontalSpacing]];
    NSString *countStr = [NSString notRounding:count afterPoint:0 roundingMode:NSRoundDown];
    return countStr.integerValue;
}

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
        [self addGestureRecognizer:self.tapGesture];
        [self.pinGesture requireGestureRecognizerToFail:self.longPressGesture];
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
    }
    [self stroke];
    [self strokeLine];
}
- (void)stroke
{    
    CGFloat h = 0;
    [self.entityArray removeAllObjects];
    if ((self.candleWidth + self.horizontalSpacing) *self.dataArray.count < self.bounds.size.width) {
        self.scrollEnabled = NO;
    }else{
        self.scrollEnabled = YES;
    }
    CAAnimationGroup *group = [CAAnimationGroup animation];
    NSMutableArray *animates = @[].mutableCopy;
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        CAShapeLayer *barlayer = [CAShapeLayer layer];
        
        if (self.yMAxValue == 0) {
            self.barChartY = self.height - self.bottomSeparationDistance;
        }else{
            self.barChartY = (self.height - self.bottomSeparationDistance)* (self.yMAxValue/(self.yMAxValue + self.yMinValue)) ;
        }
        h = [self.dataArray[i] doubleValue];
        if (h>0) {
            if (self.yMAxValue == 0) {
                h = CGFLOAT_MIN;
            }else{
                h = h /self.yMAxValue  * (self.barChartY );
            }
            
        }else {
            if (self.yMinValue == 0) {
                h = CGFLOAT_MIN;
            }else{
                h = h /self.yMinValue * (self.height - self.barChartY - self.bottomSeparationDistance);
            }
        }
        if (h>0) {
            barlayer.strokeColor = self.chartItemColor.strokeTopColor.CGColor;
        }else{
            barlayer.strokeColor = self.chartItemColor.strokeBottomColor.CGColor;
        }
        h = -h;
        
        CGRect rect = CGRectZero;
        
        barlayer.lineCap = kCALineCapButt;
        barlayer.lineWidth = self.candleWidth;
        
        UIBezierPath *path = [UIBezierPath bezierPath];

        [path moveToPoint:CGPointMake((i ) * (self.candleWidth + self.horizontalSpacing) +self.candleWidth/2+self.horizontalSpacing/2 , self.barChartY)];

        [path addLineToPoint:CGPointMake((i ) * (self.candleWidth + self.horizontalSpacing) +self.candleWidth/2+self.horizontalSpacing/2 , self.barChartY+h)];
        
        rect = CGRectMake((i) * (self.candleWidth + self.horizontalSpacing) +self.horizontalSpacing/2, self.barChartY, self.candleWidth, h);
        
        barlayer.path = path.CGPath;
        [self.layer addSublayer:barlayer];
        
        if (self.animation) {
            
            CABasicAnimation *animate = [WWTool addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:.5 delegate:nil layer:barlayer];
            [animates addObject:animate];
        }
        
        WWChartEntity *entity = [WWChartEntity new];
        entity.rect = rect;
        entity.index = i;
        entity.layer = barlayer;
        [self.entityArray addObject:entity];
        
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
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.contentSize.width - self.bounds.size.width;
    if (offset > 0)
    {
        [self setContentOffset:CGPointMake(offset,0 ) animated:animated];
    }
}
-(void)strokeLine
{
    CGFloat h = 0;
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    self.barChartY = (self.height - self.bottomSeparationDistance);
    
    CAShapeLayer *barlayer = [CAShapeLayer layer];
    UIBezierPath * gradinentPath=[[UIBezierPath alloc] init];
    CAShapeLayer *arc = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i < self.lineDataArray.count; i++) {
        h = [self.lineDataArray[i] doubleValue];
        
        if (h>0) {
            if (self.yLineMAxValue <=0) {
                self.yLineMAxValue = 1;
            }
            if (self.yLineMAxValue == 0 || self.yLineMAxValue == NSNotFound || self.yLineMinValue == NSNotFound) {
                h = CGFLOAT_MIN;
                
            }else{
                h = [self.lineDataArray[i] doubleValue] /self.yLineMAxValue  * (self.barChartY);
            }
        }else {
            if (self.yLineMinValue == 0) {
                h = CGFLOAT_MIN;
            }else{
                h = h /self.yLineMinValue * (self.height - self.barChartY - self.bottomSeparationDistance );
            }
            
        }
        h = -h;
        
        CGFloat startX = ((self.candleLineWidth) * (i )+self.candleWidth/2 + self.horizontalSpacing/2 )  ;
        
        CGPoint point = CGPointMake(startX, self.barChartY + h );
        
        barlayer.lineCap = kCALineCapButt;
        barlayer.fillColor = [UIColor clearColor].CGColor;
        barlayer.strokeColor = [WWTool colorWithHexString:@"#3C87FE"].CGColor;
        barlayer.path = path.CGPath;
        [self.layer addSublayer:barlayer];
        
        UIBezierPath *drawPoint=[UIBezierPath bezierPath];
        [drawPoint addArcWithCenter:point radius:radius startAngle:M_PI*0 endAngle:M_PI*2 clockwise:YES];
        
        CAShapeLayer *pointLayer = [CAShapeLayer layer];
        pointLayer.path=drawPoint.CGPath;
        pointLayer.strokeColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        pointLayer.fillColor = [WWTool colorWithHexString:@"#1E68B3"].CGColor;
        [self.layer addSublayer:pointLayer];
        
#pragma mark - 绘制 渐进底色
        if (self.lineDataArray.count -1 == i) {
            if (self.lineDataArray.count > 1) {
                [path addLineToPoint:point];
                
            }
        }else if ( i == 0 ){
            [path moveToPoint:CGPointMake(point.x, point.y)];
            if (self.lineDataArray.count > 1) {
                [path addLineToPoint:point];
            }
            
        }
        
        else {
            [path addLineToPoint:point];
        }
        
        barlayer.path = path.CGPath;
        
        arc.path = gradinentPath.CGPath;
        
        arc.strokeColor = [UIColor clearColor].CGColor;
        
        if (self.animation) {
            [WWTool addAnimationForKeypath:@"strokeEnd" fromValue:0 toValue:1 duration:.5 delegate:nil layer:barlayer];
        }
        
    }
    
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
    self.candleLineWidth = recognizer.scale * self.candleLineWidth;
    CGFloat xAxisVerticalLineDefaultPitch = self.width / 6;
    if(self.candleWidth > self.candleMaxWidth){
        [UIView animateWithDuration:.25 animations:^{
            CGFloat ratio = self.candleWidth / self.candleMaxWidth;
            
            self.candleWidth = self.candleMaxWidth;
            
            self.verticalLinePitch = xAxisVerticalLineDefaultPitch * ratio;
            
        }];
        
    }else if(self.candleWidth < self.candleMinWidth){
        [UIView animateWithDuration:.25 animations:^{
            self.candleWidth = self.candleMinWidth;
            self.verticalLinePitch = xAxisVerticalLineDefaultPitch;
        }];
        
    }
    if(self.candleLineWidth > self.candleLineMaxWidth){ //line
        [UIView animateWithDuration:.25 animations:^{
            
            self.candleLineWidth = self.candleLineMaxWidth;
            
        }];
        
    }else if(self.candleLineWidth < self.candleLineMinWidth){
        [UIView animateWithDuration:.25 animations:^{
            self.candleLineWidth = self.candleLineMinWidth;
        }];
        
    }
    
    [self setNeedsDisplay];
    
    self.lastPinScale = recognizer.scale;
    self.contentSize = CGSizeMake((self.candleWidth + self.horizontalSpacing) *self.dataArray.count,0);
    
    if (_chartViewDidPitchCompletion) {
        _chartViewDidPitchCompletion(self.candleWidth);
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
    if (!self.highlightLineShowEnabled || !self.entityArray.count) {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.highlightLineCurrentEnabled = NO;
        [self.yFollowLineLayer removeFromSuperlayer];
        self.yFollowLineLayer = nil;
        [self.xFollowLineLayer removeFromSuperlayer];
        self.xFollowLineLayer = nil;
        self.lastHighlightLineCurrentIndex = 0;

    }
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [recognizer locationInView:self];
        [self getHighlightByTouchPoint:point];
        WWChartEntity *entity = self.entityArray[self.highlightLineCurrentIndex];
        if (!self.lastHighlightLineCurrentIndex || self.highlightLineCurrentIndex != self.lastHighlightLineCurrentIndex) {
            self.lastHighlightLineCurrentIndex = self.highlightLineCurrentIndex;
            
            [self setupShadowLayerWithentity:entity];
            if (self.chartViewDidClickedCompletion) {
                self.chartViewDidClickedCompletion(entity.index);
            }
            
        }
        
    }
    
}
- (void)getHighlightByTouchPoint:(CGPoint) point
{
    // 十字线偏移量
    self.highlightLineCurrentIndex =   (NSInteger)((point.x)/(self.candleWidth + self.horizontalSpacing));
    if (self.highlightLineCurrentIndex == NSNotFound || self.highlightLineCurrentIndex < 0) {
        self.highlightLineCurrentIndex = 0;
    }
    if (self.highlightLineCurrentIndex >= self.entityArray.count && self.entityArray.count != 0) {
        self.highlightLineCurrentIndex = self.entityArray.count - 1;
    }
}
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGestureAction:)];
    }
    return _tapGesture;
}
- (void)handleTapGestureAction:(UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    for (NSInteger i =0;i<self.entityArray.count;i++) {
        WWChartEntity *entity = self.entityArray[i];
        
        if (CGRectContainsPoint(entity.rect, point)) {
            
            [self setupShadowLayerWithentity:entity];
            
            if (self.chartViewDidClickedCompletion) {
                self.chartViewDidClickedCompletion(entity.index);
            }
        }
    }
    
}

-(void)setupShadowLayerWithentity:(WWChartEntity *)entity
{
    [self.borderLayer removeFromSuperlayer];
    
    [self.selectedLayer removeFromSuperlayer];
    self.selectedLayer.path = entity.layer.path;
    self.selectedLayer.lineWidth = self.candleWidth;
    
    [self.layer addSublayer:self.selectedLayer];
    UIBezierPath *bers = [UIBezierPath bezierPathWithRect:CGRectMake(entity.rect.origin.x ,entity.rect.origin.y, entity.rect.size.width, entity.rect.size.height)];
    
    self.borderLayer.path = bers.CGPath;
    
    self.borderLayer.strokeColor = entity.layer.strokeColor;
    [self.layer addSublayer:self.borderLayer];
    
}

@end
