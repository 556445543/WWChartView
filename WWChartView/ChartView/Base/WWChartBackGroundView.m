
//
//  WWChartBackGroundView.m
//
//  Created by ww on 16/6/24.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "WWChartBackGroundView.h"
#import "WWTool.h"
#import "UIView+Extension.h"
#import "WWBarXAxisItem.h"

static CGFloat const xAxisLeftPitch = 10;
static CGFloat const xAxisRightPitch = 18;

static CGFloat const yAxisTopPitch = 10;
static CGFloat const yAxisBottomPitch = 18;

NSInteger const WWNoDatapromptLabelTag = 10032;
NSInteger const WWBgImageViewTag = 124;

@interface WWChartBackGroundView()<CAAnimationDelegate>

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (strong,nonatomic) CAShapeLayer *horizontalLineLayer;

/*****视图顶部间距******/
@property (nonatomic,assign,readwrite) CGFloat topSeparationDistance;
/*****视图底部间距******/
@property (nonatomic,assign,readwrite) CGFloat bottomSeparationDistance;
/*****视图左边间距******/
@property (nonatomic,assign,readwrite) CGFloat leftSeparationDistance;
/*****视图右边间距******/
@property (nonatomic,assign,readwrite) CGFloat rightSeparationDistance;

@property (nonatomic,strong) NSMutableArray *rightTextLayers;

@property (nonatomic,strong) NSMutableArray *leftTextLayers;
/***中点Y值坐标*****/
@property (nonatomic,assign,readwrite) CGFloat barChartY;

@end

@implementation WWChartBackGroundView


-(CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        //初始化渐变层
        _gradientLayer = [CAGradientLayer layer];
        
        _gradientLayer.frame = self.bounds;
        //        [self.layer insertSublayer:self.gradientLayer atIndex:0];
        //    [self.layer addSublayer:self.gradientLayer];
        
        //设置渐变颜色方向
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        
        //设定颜色组
        _gradientLayer.colors = @[(__bridge id)[WWTool colorWithHexString:@"#1B1F23"].CGColor,
                                  (__bridge id)[WWTool colorWithHexString:@"#4D5663"].CGColor,
                                  (__bridge id)[WWTool colorWithHexString:@"#1B1F23"].CGColor,
                                  ];
        //设定颜色分割点
        _gradientLayer.locations = @[@(0.0),@(0.25f),@(1.75f)];
        
    }
    return _gradientLayer;
}

- (NSMutableArray *)leftTextLayers
{
    if (!_leftTextLayers) {
        _leftTextLayers =@[].mutableCopy;
    }
    return _leftTextLayers;
}

- (NSMutableArray *)rightTextLayers
{
    if (!_rightTextLayers) {
        _rightTextLayers =@[].mutableCopy;
    }
    return _rightTextLayers;

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
        
    }
    return self;
}

-(void)commitInit
{
    self.leftSeparationDistance = xAxisLeftPitch;
    self.rightSeparationDistance = xAxisRightPitch;
    self.topSeparationDistance = yAxisTopPitch;
    self.bottomSeparationDistance = yAxisBottomPitch;
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    //    self.clipsToBounds = YES;
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chartbg@2x"]];
    [self addSubview:iv];
    iv.tag = WWBgImageViewTag;
    iv.frame = self.bounds;
    self.backgroundImageView = iv;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.PromptLabel = label;
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"";
    label.textColor = [UIColor lightTextColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = YES;
    label.tag = WWNoDatapromptLabelTag;
    self.PromptLabel = label;
    [self addSubview:label];
    
}

-(void)setYisYLabelArray:(NSArray<NSString *> *)yisYLabelArray
{
    _yisYLabelArray = yisYLabelArray;
    
    CGFloat max = xAxisRightPitch;
    if (!yisYLabelArray.count) {
        self.rightSeparationDistance = xAxisRightPitch;
    }
    for (NSString *str in yisYLabelArray) {
        CGSize textSize = [WWTool sizeOfStr:str andFont:[UIFont systemFontOfSize:6] andMaxSize:CGSizeMake(30, 20) andLineBreakMode:NSLineBreakByWordWrapping];
        
        if (max < textSize.width) {
            max = textSize.width;
        }
        self.rightSeparationDistance = max;
        
    }
    
}
-(void)setYisYLeftLabelArray:(NSArray *)yisYLeftLabelArray
{
    _yisYLeftLabelArray = yisYLeftLabelArray;
    CGFloat max = xAxisLeftPitch;

    if (!yisYLeftLabelArray.count) {
        self.leftSeparationDistance = xAxisLeftPitch;
    }
    for (NSString *str in yisYLeftLabelArray) {
        CGSize textSize = [WWTool sizeOfStr:str andFont:[UIFont systemFontOfSize:6] andMaxSize:CGSizeMake(30, 20) andLineBreakMode:NSLineBreakByWordWrapping];
        
        if (max < textSize.width) {
            max = textSize.width;
        }
        self.leftSeparationDistance = max;
        
    }

}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    if (dataArray.count <= 0) {
        self.PromptLabel.hidden = NO;
    }else{
        self.PromptLabel.hidden = YES;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.dataArray.count <= 0) {
        return;
    }
    CGFloat yDistance = 0;
    if (!self.yAxisDistance) {
        yDistance = (self.bounds.size.height - self.topSeparationDistance - self.bottomSeparationDistance)/(self.horizontalLineCount -1);
    }else{
        yDistance = self.yAxisDistance.doubleValue;
    }
    
    for (NSInteger i = 1;i <= self.yisYLabelArray.count; i ++) {
        CGFloat startY = self.topSeparationDistance+ yDistance * (i-1);
        CGFloat endY = startY;
        
        [WWTool textLayerWithRect:CGRectMake(self.bounds.size.width - self.rightSeparationDistance, endY -2, self.rightSeparationDistance, 20) date:self.yisYLabelArray[i-1] textColor:self.rightYAxisColor currentView:self];

    }
    
    //drawing center line
    if (self.drawCenterLineEnabled) {
        [self setupGridLineWithStartPoint:CGPointMake(self.leftSeparationDistance, self.barChartY + self.topSeparationDistance) endPoint:CGPointMake(self.bounds.size.width - self.rightSeparationDistance,self.barChartY+ self.topSeparationDistance) lineColor:[UIColor blackColor]];
    }
    
    //    drawing Horizontal Line
    for (NSInteger i = 1; i <= self.horizontalLineCount; i ++) {
        CGFloat startX = self.leftSeparationDistance;
        CGFloat startY = self.topSeparationDistance + self.horizontalLinePitch * (i-1);
        CGFloat endX = self.bounds.size.width - self.rightSeparationDistance ;
        CGFloat endY = startY;
        
        self.horizontalLineLayer = [self setupGridLineWithStartPoint:CGPointMake(startX, startY) endPoint:CGPointMake(endX,endY) lineColor:[UIColor grayColor]];
        
    }
    //drawing Vertical Line
//        CGFloat distance = (self.bounds.size.width - xAxisLeftPitch - xAxisRightPitch) / 6;
//        distance = self.verticalLinePitch;
//        for (NSInteger i = 1; i <= 5; i ++) {
//            CGFloat startX = distance * i;
//            CGFloat startY = self.topSeparationDistance;
//            CGFloat endX = distance * i;
//            CGFloat endY = self.bounds.size.height - self.bottomSeparationDistance;
//    
//            [self setupGridLineWithStartPoint:CGPointMake(startX, startY) endPoint:CGPointMake(endX,endY) lineColor:[UIColor grayColor]];
//        }
    
    
    if (self.drawYAxisEnable) {
        for (NSInteger i = 0; i < self.xAxiscoordinateArray.count; i++) {
            WWBarXAxisItem *item = self.xAxiscoordinateArray[i];
            CGRect rect = item.rect;

            [self setupGridLineWithStartPoint:CGPointMake(self.leftSeparationDistance + rect.origin.x , self.topSeparationDistance)
                                     endPoint:CGPointMake(self.leftSeparationDistance + rect.origin.x , self.height - self.bottomSeparationDistance)
                                    lineColor:[UIColor grayColor]];
            
        }

    }

    for (NSInteger i = 1; i <= self.yisYLeftLabelArray.count; i ++) {//左边y轴坐标 label
        CGFloat startY = self.topSeparationDistance+ yDistance * (i-1);
        CGFloat endY = startY;
        
        [WWTool textLayerWithRect:CGRectMake(0, endY -2, self.leftSeparationDistance, 20) date:self.yisYLeftLabelArray[i-1] textColor:self.leftYAxisColor currentView:self];
    }
    
    
}


-(CAShapeLayer *)setupGridLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor
{
    CAShapeLayer *gridLineLayer = [CAShapeLayer layer];
    gridLineLayer.lineCap      = kCALineCapButt;
    gridLineLayer.fillColor    = [[UIColor clearColor] CGColor];
    gridLineLayer.lineWidth    = 1.0;
    gridLineLayer.strokeEnd    = 0.0;
    [gridLineLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1.3],[NSNumber numberWithInt:2],nil]];
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:startPoint];
    [progressline addLineToPoint:endPoint];
    
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    gridLineLayer.path = progressline.CGPath;
    gridLineLayer.strokeColor = lineColor.CGColor;
    gridLineLayer.strokeEnd = 1.0;
    
    [self.layer insertSublayer:gridLineLayer atIndex:0];
    
    return gridLineLayer;
}

@end
