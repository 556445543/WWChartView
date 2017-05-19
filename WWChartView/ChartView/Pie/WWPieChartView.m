//
//  WWPieChartView.m
//  Pie
//
//  Created by ww on 16/6/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "WWPieChartView.h"
#import "WWPieChartDataItem.h"
#import "WWChartEntity.h"
#import "WWPieCHartLayer.h"
#import "UIImage+Extension.h"
#import "WWTool.h"

#define radiusCenterX [UIScreen mainScreen].bounds.size.width * 0.35
#define radiusCenterY [UIScreen mainScreen].bounds.size.height * 0.5
#define   kDegreesToRadians(degrees)  ((3.1415926 * degrees)/ 180)
#define radiusCenter CGPointMake(self.bounds.size.width * 0.35, self.bounds.size.height *0.5)

extern NSInteger const WWNoDatapromptLabelTag;
extern NSInteger const WWBgImageViewTag;
/****外圆半径**/
static const CGFloat outerCircleRadius = 36;
/***内圆半径***/
static const CGFloat innerCircleRadius = 10;


@interface WWPieChartView()<CAAnimationDelegate>

@property (nonatomic,strong) NSMutableArray<WWPieCHartLayer *> *entityArray;

@property (nonatomic,assign) CGFloat circleMaxX;

@property (strong, nonatomic) CAShapeLayer *sectorHighlight;

@property (nonatomic,assign) BOOL isFinish;

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) CAShapeLayer *pieLayer;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic) NSMutableArray *endPercentages;

@property (nonatomic,strong) CAShapeLayer *borderLayer;

@end

@implementation WWPieChartView
-(UIView *)backgroundView
{
    if (!_backgroundView) {
        CGFloat backGroundX = radiusCenterX + 44;
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(backGroundX, 0, self.frame.size.width - backGroundX, self.bounds.size.height)];
        
        _backgroundView.tag = 100;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}
-(CAShapeLayer *)borderLayer
{
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        _borderLayer.strokeColor = [UIColor redColor].CGColor;
    }
    return _borderLayer;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commitinit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commitinit];
    }
    return self;
}

-(void)commitinit
{
    [self addSubview:self.backgroundView];
    _pieLayer = [CAShapeLayer layer];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(radiusCenter.x-40, radiusCenter.y-40, 80, 80)];
    NSMutableArray *endPercentages = [NSMutableArray new];
    self.endPercentages = endPercentages;
    [self addSubview:_contentView];
    [_contentView.layer addSublayer:_pieLayer];
    
    _contentView.tag = 100;
}

-(NSMutableArray *)entityArray
{
    if (!_entityArray) {
        _entityArray = [NSMutableArray array];
    }
    return _entityArray;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    [super setDataArray:dataArray];
    for (NSInteger i =self.subviews.count -1; i>= 0; i--) {
        UIView *sublayer = self.subviews[i];
        if ([sublayer isKindOfClass:[UILabel class]] && sublayer.tag != WWNoDatapromptLabelTag && sublayer.tag != WWBgImageViewTag) {
            [sublayer removeFromSuperview];
        }
        if ([sublayer isKindOfClass:[UIView class]] && (sublayer.tag != 100 && sublayer.tag != WWNoDatapromptLabelTag && sublayer.tag != WWBgImageViewTag)) {
            [sublayer removeFromSuperview];
            sublayer = nil;
        }
    }
    
    [self setNeedsDisplay];
    
    for (NSInteger i =self.backgroundView.subviews.count -1; i>= 0; i--) {
        UIView *sublayer = self.backgroundView.subviews[i];
        if ([sublayer isKindOfClass:[UILabel class]] && sublayer.tag != WWNoDatapromptLabelTag) {
            [sublayer removeFromSuperview];
        }
        if ([sublayer isKindOfClass:[UIView class]] && (sublayer.tag != 100) && sublayer.tag != WWNoDatapromptLabelTag) {
            [sublayer removeFromSuperview];
            sublayer = nil;
        }
    }
    
    CGFloat dotWidth = 6;
    CGFloat dotHeight = 6;
    CGFloat dotX = 20;
    
    CGFloat distance = (self.bounds.size.height ) / 5;
    for (NSInteger i = 1 ; i <= self.dataArray.count; i ++) {
        WWPieChartDataItem *item = self.dataArray[i-1];
        CGFloat dotY = distance * i;
        
        UIView *dot =[[UIView alloc] initWithFrame:CGRectMake(dotX, dotY, dotWidth, dotHeight)];
        UIImageView *imageDotView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:item.color size:CGSizeMake(dotWidth, dotHeight)]];
        
        imageDotView.frame = dot.frame;
        imageDotView.layer.cornerRadius =3;
        dot.backgroundColor = item.color;
        
        dot.layer.cornerRadius = 3;
        [self.backgroundView addSubview:imageDotView];
        CGFloat lblX = dotX + dotWidth + 6;
        CGFloat lblY = dotY - 3;
        CGFloat labelMaxWidth = self.bounds.size.width - self.backgroundView.frame.origin.x + dotX + dotWidth;

        CGFloat lblWidth = labelMaxWidth;
        CGFloat lblHeight = 11;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
        [self.backgroundView addSubview:label];
        
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor lightTextColor];
        label.text = item.textDescription;
    }
}


- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.contentView.bounds),CGRectGetMidY(self.contentView.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    
    circle.fillColor   = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd   = endPercentage;
    circle.lineWidth   = borderWidth;
    circle.path        = path.CGPath;
    
    
    return circle;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat startA = 0;
    CGFloat angle = 0;
    CGFloat endA = 0;
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    for (NSInteger i =self.pieLayer.sublayers.count -1; i>= 0; i--) {
        CALayer *sublayer = self.pieLayer.sublayers[i];
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
        if ([sublayer isKindOfClass:[CATextLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
    }
    
    [self.sectorHighlight removeFromSuperlayer];
    [self.entityArray removeAllObjects];
    [self.endPercentages removeAllObjects];
    if (self.dataArray.count <=0) {
        return;
    }
    for (NSInteger i =0; i< self.dataArray.count; i++) {
        
        WWPieChartDataItem *item = self.dataArray[i];
        
        startA = endA;
        angle = item.value / 100.0;
        endA = startA + angle;
        [self.endPercentages addObject:@(endA)];
        
        CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:outerCircleRadius
                                                           borderWidth:innerCircleRadius
                                                             fillColor:[UIColor clearColor]
                                                           borderColor:item.color
                                                       startPercentage:startA
                                                         endPercentage:endA];
        
        [_pieLayer addSublayer:currentPieLayer];
        
    }
    
    CAShapeLayer *maskLayer = [self newCircleLayerWithRadius:outerCircleRadius
                                                 borderWidth:innerCircleRadius
                                                   fillColor:[UIColor clearColor]
                                                 borderColor:[UIColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];
    self.pieLayer.mask = maskLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = .5;
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.delegate  = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [maskLayer addAnimation:animation forKey:@"circleAnimation"];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 当前坐标系上的点转换到按钮上的点
    CGPoint btnP = [self convertPoint:point toView:self.contentView];
    
    // 判断点在不在按钮上
    if ([self.contentView pointInside:btnP withEvent:event]) {
        // 点在按钮上
        return self.contentView;
    }else{
        //        return [super hitTest:point withEvent:event];
        return nil;
    }
}

// Touches Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.dataArray.count <= 0) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:_contentView];
        [self didTouchAt:touchLocation];
    }
}
- (CGFloat) findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference{
    //Find angle of line Passing In Reference And Center
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
    CGFloat percentage = (angleOfLine + M_PI/2)/(2 * M_PI);
    return (reference.x - center.x) > 0 ? percentage : percentage + .5;
}
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index{
    if (_endPercentages.count <= 0) {
        return 0;
    }
    return [_endPercentages[index] floatValue];
}
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index{
    if(index == 0){
        return 0;
    }
    
    return [_endPercentages[index - 1] floatValue];
}
- (void)didTouchAt:(CGPoint)touchLocation
{
    CGPoint circleCenter = CGPointMake(_contentView.bounds.size.width/2, _contentView.bounds.size.height/2);
    
    CGFloat distanceFromCenter = sqrtf(powf((touchLocation.y - circleCenter.y),2) + powf((touchLocation.x - circleCenter.x),2));
    
    if (distanceFromCenter < outerCircleRadius - innerCircleRadius ) {

        [self.sectorHighlight removeFromSuperlayer];
        return;
    }
    
    CGFloat percentage = [self findPercentageOfAngleInCircle:circleCenter fromPoint:touchLocation];
    int index = 0;
    while (percentage > [self endPercentageForItemAtIndex:index]) {
        index ++;
    }
    
    if (self.sectorHighlight)
        [self.sectorHighlight removeFromSuperlayer];
    
    WWPieChartDataItem *item = self.dataArray[index];
    CGFloat red,green,blue,alpha;
    UIColor *old = item.color;
    [old getRed:&red green:&green blue:&blue alpha:&alpha];
    alpha /= 2;
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    CGFloat startPercentage = [self startPercentageForItemAtIndex:index];
    CGFloat endPercentage   = [self endPercentageForItemAtIndex:index];
    
    self.sectorHighlight = [self newCircleLayerWithRadius:outerCircleRadius + 6
                                              borderWidth:innerCircleRadius
                                                fillColor:[UIColor clearColor]
                                              borderColor:newColor
                                          startPercentage:startPercentage
                                            endPercentage:endPercentage];
    
    if (self.chartViewDidClickedCompletion) {
        self.chartViewDidClickedCompletion(index);
    }
    
    [_contentView.layer addSublayer:self.sectorHighlight];

}

- (UIColor *)colorRandom
{
    // 0 ~ 255 / 255
    // OC:0 ~ 1
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
